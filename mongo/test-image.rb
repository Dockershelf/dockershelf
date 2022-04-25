# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2022, Dockershelf Developers.

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
        @image = Docker::Image.get(ENV["DOCKER_IMAGE_NAME"])
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true, 'Cmd' => 'bash')
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "should be able to start" do
        case ENV['DOCKER_IMAGE_NAME'].split(":")[1]
        when "4.2", "4.4", "5.0"
            mongod = command("mongod --fork --syslog && sleep 5")
        else
            mongod = command("mongod --fork --syslog --smallfiles && sleep 5")
        end
        expect(mongod.exit_status).to eq(0)
    end

    it "should contain these files" do
        expect(file("/etc/apt/sources.list.d/mongo.list")).to exist
        expect(file("/data/db")).to be_directory
        expect(file("/data/configdb")).to be_directory
        expect(file("/docker-entrypoint-initdb.d")).to be_directory
    end

    it "should have these packages installed" do
        expect(package("mongodb-org")).to be_installed
        expect(package("mongodb-org-server")).to be_installed
        expect(package("mongodb-org-shell")).to be_installed
        expect(package("mongodb-org-mongos")).to be_installed
        expect(package("mongodb-org-tools")).to be_installed
    end

    it "should have a mongodb user" do
        expect(user('mongodb')).to exist
        expect(user('mongodb')).to belong_to_group 'mongodb'
    end

    it "should be correct version" do
        mongov = command("mongo --quiet admin --eval 'db.version();'").stdout.strip
        mongov_short = mongov[0..2]
        expect(mongov_short).to eq(ENV['DOCKER_IMAGE_TAG'])
    end

    it "should be able to execute an operation on mongo shell" do
        expect(command("mongo admin --eval 'db.stats();'").exit_status).to eq(0)
    end

    it "should be able to execute scripts" do
        expect(command("mongo /root/articles.js").exit_status).to eq(0)
        expect(command("mongo /root/aggregate.js").exit_status).to eq(0)
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end