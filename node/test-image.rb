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

    def node_version
        command("node -e 'console.log(process.version.replace(\"v\", \"\").split(\".\")[0]);'").stdout.strip
    end

    def node_version_container_var
        command("echo $NODE_VER_NUM").stdout.strip
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

    it "should have a node interpreter" do
        expect(file("/usr/bin/node")).to exist
        expect(file("/usr/bin/nodejs")).to exist
    end

    it "should have the correct node version" do
        expect(node_version()).to eq(ENV["DOCKER_IMAGE_TYPE_VERSION"])
        expect(node_version()).to eq(node_version_container_var())
    end

    it "should have a clean npm cache on a fresh image" do
        expect(command("npm cache ls 2>/dev/null | wc -l").stdout.strip).to eq("0")
    end

    it "should be able to install a npm package" do
        expect(command("npm install -g gulp").exit_status).to eq(0)
        expect(file('/usr/bin/gulp')).to be_executable
    end

    it "should be able to uninstall a npm package" do
        expect(command("npm uninstall -g gulp").exit_status).to eq(0)
        expect(file('/usr/bin/gulp')).not_to exist
    end

    it "should be able to install and use local packages" do
        expect(command("mkdir -p /tmp/test-project && cd /tmp/test-project && npm init -y").exit_status).to eq(0)
        expect(command("cd /tmp/test-project && npm install lodash").exit_status).to eq(0)
        expect(file('/tmp/test-project/node_modules')).to be_directory
        expect(file('/tmp/test-project/node_modules/lodash')).to be_directory
        expect(command("cd /tmp/test-project && node -e \"const _ = require('lodash'); console.log(_.VERSION);\"").exit_status).to eq(0)
    end

    it "should have npx available and be able to execute packages" do
        expect(file("/usr/bin/npx")).to exist
        expect(file("/usr/bin/npx")).to be_executable
        expect(command("npx --yes cowsay 'Hello Dockershelf'").exit_status).to eq(0)
    end

    it "should be able to execute Node.js scripts with module loading" do
        expect(command("node -e \"const fs = require('fs'); const path = require('path'); const http = require('http'); console.log('success');\"").exit_status).to eq(0)
        expect(command("echo \"console.log('CommonJS works');\" > /tmp/test-cjs.js && node /tmp/test-cjs.js").exit_status).to eq(0)
        if node_version().to_i >= 14
            expect(command("echo '{\"type\": \"module\"}' > /tmp/test-esm-package.json && echo \"console.log('ESM works');\" > /tmp/test-esm.mjs && node /tmp/test-esm.mjs").exit_status).to eq(0)
        end
    end

    it "should support npm scripts and package.json workflow" do
        expect(command("mkdir -p /tmp/test-npm-scripts && cd /tmp/test-npm-scripts && npm init -y").exit_status).to eq(0)
        expect(command("cd /tmp/test-npm-scripts && echo \"console.log('App started');\" > index.js").exit_status).to eq(0)
        expect(command("cd /tmp/test-npm-scripts && npm pkg set scripts.start=\"node index.js\"").exit_status).to eq(0)
        expect(command("cd /tmp/test-npm-scripts && npm pkg set scripts.test=\"echo 'test passed'\"").exit_status).to eq(0)
        expect(command("cd /tmp/test-npm-scripts && npm run start").exit_status).to eq(0)
        expect(command("cd /tmp/test-npm-scripts && npm test").exit_status).to eq(0)
    end

    it "should have core Node.js modules functional" do
        expect(command("node -e \"const fs = require('fs'); fs.writeFileSync('/tmp/core-test', 'ok'); console.log(fs.readFileSync('/tmp/core-test', 'utf8'));\"").exit_status).to eq(0)
        expect(command("node -e \"const path = require('path'); console.log(path.join('/tmp', 'test'));\"").stdout.strip).to eq("/tmp/test")
        expect(command("node -e \"const os = require('os'); console.log(typeof os.platform());\"").stdout.strip).to eq("string")
    end

    it "should support crypto operations" do
        expect(command("node -e \"const crypto = require('crypto'); console.log(crypto.createHash('sha256').update('test').digest('hex'));\"").exit_status).to eq(0)
        expect(command("node -e \"const crypto = require('crypto'); console.log(crypto.randomBytes(16).length);\"").stdout.strip).to eq("16")
    end

    it "should be able to start an HTTP server and respond" do
        server_script = 'const http = require("http"); const server = http.createServer((req, res) => { res.end("ok"); server.close(); }); server.listen(8765, () => { console.log("ready"); });'
        expect(command("node -e '#{server_script}' &").exit_status).to eq(0)
        expect(command("sleep 1 && curl -s http://localhost:8765/").stdout.strip).to eq("ok")
    end

    it "should support Buffer and stream operations" do
        expect(command("node -e \"const buf = Buffer.from('hello'); console.log(buf.toString());\"").stdout.strip).to eq("hello")
        expect(command("node -e \"const fs = require('fs'); const stream = fs.createReadStream('/etc/os-release'); stream.on('data', () => {}); stream.on('end', () => console.log('done'));\"").stdout.strip).to eq("done")
    end

    it "should support child process execution" do
        expect(command("node -e \"const { execSync } = require('child_process'); console.log(execSync('echo child').toString().trim());\"").stdout.strip).to eq("child")
    end

    it "should support DNS resolution" do
        expect(command("node -e \"const dns = require('dns'); dns.lookup('deb.debian.org', (err, addr) => { if (err) throw err; console.log(addr); });\"").exit_status).to eq(0)
    end

    it "should be able to make an HTTPS request" do
        expect(command("node -e \"const https = require('https'); https.get('https://deb.debian.org/', (res) => { console.log(res.statusCode); });\"").stdout.strip).to eq("200")
    end

    it "should have npm config pointing to the official registry" do
        expect(command("npm config get registry").stdout.strip).to eq("https://registry.npmjs.org/")
    end

    it "should have node-gyp available for native addon builds" do
        expect(command("which node-gyp || ls /usr/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js").exit_status).to eq(0)
    end

    it "should run npm audit without crashing" do
        expect(command("mkdir -p /tmp/test-audit && cd /tmp/test-audit && npm init -y && npm audit --audit-level=critical").exit_status).to be_between(0, 1)
    end

    it "should support timers and the event loop" do
        expect(command("node -e \"setTimeout(() => { console.log('timer'); }, 10);\"").stdout.strip).to eq("timer")
        expect(command("node -e \"let i = 0; const id = setInterval(() => { i++; if (i === 3) { clearInterval(id); console.log('interval'); } }, 5);\"").stdout.strip).to eq("interval")
    end

    it "should evaluate expressions via node -p" do
        expect(command("node -p \"1 + 1\"").stdout.strip).to eq("2")
        expect(command("node -p \"process.version\"").stdout.strip).to match(/^v/)
    end

    it "should resolve packages correctly" do
        expect(command("mkdir -p /tmp/test-resolve && cd /tmp/test-resolve && npm init -y && npm install lodash").exit_status).to eq(0)
        expect(command("cd /tmp/test-resolve && node -e \"console.log(require.resolve('lodash'));\"").stdout.strip).to match(%r{lodash/lodash\.js})
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end
