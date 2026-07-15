# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "docker-api"
require "serverspec"

describe "%s %s container" % [ENV["DOCKER_IMAGE_TYPE"], ENV["DOCKER_IMAGE_TAG"]] do
    before(:all) do
        Docker.options[:read_timeout] = 1200
        Docker.options[:write_timeout] = 1200

        @image = Docker::Image.get(ENV["DOCKER_IMAGE_NAME"])
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true, 'Cmd' => ['bash'])
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    def python_version
        command("python3 -c \"import sys; print('%s.%s' % (sys.version_info[0], sys.version_info[1]))\"").stdout.strip
    end

    def python_version_container_var
        command("echo $PYTHON_VER_NUM").stdout.strip
    end

    def python_version_long
        releaselevel = command("python3 -c \"import sys; print(sys.version_info.releaselevel)\"").stdout.strip
        case releaselevel
        when "alpha"
            command("python3 -c \"import sys; print('%s.%s.%sa%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "beta"
            command("python3 -c \"import sys; print('%s.%s.%sb%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "candidate"
            command("python3 -c \"import sys; print('%s.%s.%src%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "final"
            command("python3 -c \"import sys; print('%s.%s.%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2]))\"").stdout.strip
        end
    end

    def get_tests_list
        case python_version()
        when "3.14"
            ['test_builtin', 'test_doctest.test_doctest2', 'test_grammar', 'test_opcodes', 'test_types']
        when "3.11", "3.12", "3.13"
            ['test_builtin', 'test_dict', 'test_doctest.test_doctest2', 'test_grammar', 'test_opcodes', 'test_types']
        else
            ['test_builtin', 'test_dict', 'test_doctest2', 'test_grammar', 'test_opcodes', 'test_types']
        end
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "OS architecture should be %s" % ENV["DOCKER_IMAGE_ARCH"] do
        case ENV['DOCKER_IMAGE_ARCH']
        when "amd64"
            expect(os[:arch]).to eq("x86_64")
        when "arm64"
            expect(os[:arch]).to eq("aarch64")
        end
    end

    it "should have a python interpreter" do
        expect(file("/usr/bin/python#{python_version()}")).to be_executable
        expect(file("/usr/bin/python3")).to be_symlink
        expect(file("/usr/bin/python3")).to be_linked_to("/usr/bin/python#{python_version()}")
    end

    it "should have the correct python version" do
        expect(python_version()).to eq(ENV["DOCKER_IMAGE_TYPE_VERSION"])
        expect(python_version()).to eq(python_version_container_var())
    end

    it "should be able to install a python package" do
        expect(command("pip3 install virtualenv").exit_status).to eq(0)
        expect(file('/usr/local/bin/virtualenv')).to be_executable
    end

    it "should be able to uninstall a python package" do
        expect(command("pip3 uninstall -y virtualenv").exit_status).to eq(0)
        expect(file('/usr/local/bin/virtualenv')).not_to exist
    end

    it "should have setuptools installed by pip" do
        expect(package('setuptools')).to be_installed.by('pip')
    end

    it "shouldn't have invalid packages installed by pip" do
        expect(package('invalid-pip')).not_to be_installed.by('pip').with_version('invalid-version')
    end

    it "should pass basic internal tests" do
        expect(command("apt-get update", 120).exit_status).to eq(0)
        expect(command("apt-get install git rsync").exit_status).to eq(0)
        expect(command("git clone --branch v#{python_version_long()} --depth 1 https://github.com/python/cpython /tmp/cpython").exit_status).to eq(0)
        expect(command("rsync -avz /tmp/cpython/Lib/test/ /usr/lib/python#{python_version()}/test/").exit_status).to eq(0)

        for test_suite in get_tests_list()
            expect(command("python3 -m test.regrtest #{test_suite}").exit_status).to eq(0)
        end
    end

    it "should create and activate a virtual environment" do
        expect(command("python3 -m venv /tmp/test-venv").exit_status).to eq(0)
        expect(file("/tmp/test-venv/bin/python3")).to be_executable
        expect(command("/tmp/test-venv/bin/python3 -c 'import sys; print(sys.prefix)'").stdout.strip).to eq("/tmp/test-venv")
    end

    it "should have core standard library modules functional" do
        expect(command("python3 -c 'import json; print(json.dumps({\"a\": 1}))'").stdout.strip).to eq('{"a": 1}')
        expect(command("python3 -c 'import re; print(re.match(\"^test\", \"test\").group())'").stdout.strip).to eq("test")
        expect(command("python3 -c 'import datetime; print(datetime.date.today().year)'").stdout.strip).to match(/^\d{4}$/)
        expect(command("python3 -c 'import math; print(math.sqrt(4))'").stdout.strip).to eq("2.0")
    end

    it "should support hashlib and secrets" do
        expect(command("python3 -c 'import hashlib; print(hashlib.sha256(b\"test\").hexdigest())'").exit_status).to eq(0)
        expect(command("python3 -c 'import secrets; print(len(secrets.token_hex(16)))'").stdout.strip).to eq("32")
    end

    it "should support sqlite3" do
        script = 'import sqlite3; conn = sqlite3.connect(":memory:"); conn.execute("CREATE TABLE t (c TEXT)"); conn.execute("INSERT INTO t VALUES (?)", ("ok",)); print(conn.execute("SELECT * FROM t").fetchone()[0]); conn.close()'
        expect(command("python3 -c '#{script}'").stdout.strip).to eq("ok")
    end

    it "should support pathlib and file I/O" do
        script = %q(from pathlib import Path; p = Path("/tmp/test-pathlib"); p.write_text("hello"); print(p.read_text()))
        expect(command(%Q(python3 -c '#{script}')).stdout.strip).to eq("hello")
    end

    it "should support subprocess execution" do
        expect(command("python3 -c 'import subprocess; result = subprocess.run([\"echo\", \"child\"], capture_output=True, text=True); print(result.stdout.strip())'").stdout.strip).to eq("child")
    end

    it "should support threading" do
        script = 'import threading; result = []\ndef worker(): result.append("thread")\nt = threading.Thread(target=worker); t.start(); t.join(); print(result[0])'
        expect(command("echo '#{script}' | python3").stdout.strip).to eq("thread")
    end

    it "should support urllib and make an HTTPS request" do
        expect(command("python3 -c 'import urllib.request; response = urllib.request.urlopen(\"https://deb.debian.org/\"); print(response.status)'").stdout.strip).to eq("200")
    end

    it "should support socket and ssl modules" do
        expect(command("python3 -c 'import socket; print(socket.gethostname())'").stdout.strip).not_to be_empty
        expect(command("python3 -c 'import ssl; print(ssl.OPENSSL_VERSION)'").stdout.strip).to match(/^OpenSSL/)
    end

    it "should support UTF-8 filenames and string operations" do
        expect(command("python3 -c 'open(\"/tmp/ñ_test_文件\", \"w\").write(\"ok\")'").exit_status).to eq(0)
        expect(command("python3 -c 'print(open(\"/tmp/ñ_test_文件\").read())'").stdout.strip).to eq("ok")
    end

    it "should install packages using wheels" do
        expect(command("pip3 install requests").exit_status).to eq(0)
        expect(command("python3 -c 'import requests; print(requests.__version__)'").stdout.strip).to match(/^\d+\.\d+/)
    end

    it "should compile a package with C extensions" do
        expect(command("pip3 install --no-binary :all: markupsafe").exit_status).to eq(0)
        expect(command("python3 -c 'import markupsafe; print(markupsafe.__version__)'").stdout.strip).to match(/^\d+\.\d+/)
    end

    it "should have pip cache cleanable" do
        expect(command("pip3 cache purge").exit_status).to eq(0)
    end

    it "should have pip configured for the official PyPI index" do
        expect(command("pip3 config get global.index-url 2>/dev/null || echo https://pypi.org/simple").stdout.strip).to match(/pypi\.org/)
    end

    it "should support environment variable access" do
        expect(command("python3 -c 'import os; print(os.environ.get(\"HOME\"))'").stdout.strip).to eq("/root")
    end

    it "should support compression modules" do
        expect(command("python3 -c 'import gzip; import io; buf = io.BytesIO(); f = gzip.GzipFile(fileobj=buf, mode=\"wb\"); f.write(b\"compressed\"); f.close(); buf.seek(0); print(gzip.GzipFile(fileobj=buf).read().decode())'").stdout.strip).to eq("compressed")
    end

    it "should support csv and xml modules" do
        expect(command("python3 -c 'import csv; import io; f = io.StringIO(); w = csv.writer(f); w.writerow([\"a\", \"b\"]); print(f.getvalue().strip())'").stdout.strip).to eq("a,b")
        expect(command("python3 -c 'import xml.etree.ElementTree as ET; e = ET.Element(\"root\"); print(e.tag)'").stdout.strip).to eq("root")
    end

    it "should support typing and dataclasses" do
        script = "from dataclasses import dataclass\n@dataclass\nclass Point:\n    x: int\n    y: int\np = Point(1, 2); print(p.x + p.y)"
        expect(command("echo '#{script}' | python3").stdout.strip).to eq("3")
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end
