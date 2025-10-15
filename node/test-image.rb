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
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true, 'Cmd' => 'bash')
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

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end