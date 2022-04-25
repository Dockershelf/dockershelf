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
        expect(command("pg_ctlcluster #{ENV['DOCKER_IMAGE_TAG']} main start").exit_status).to eq(0)
    end

    it "should contain these files" do
        expect(file("/etc/apt/sources.list.d/postgres.list")).to exist
        expect(file("/var/lib/postgresql/data")).to be_directory
        expect(file("/var/run/postgresql")).to be_directory
        expect(file("/docker-entrypoint-initdb.d")).to be_directory
    end

    it "should have these packages installed" do
        expect(package("postgresql-#{ENV['DOCKER_IMAGE_TAG']}")).to be_installed
        expect(package("postgresql-common")).to be_installed
        expect(package("postgresql-client-#{ENV['DOCKER_IMAGE_TAG']}")).to be_installed
        expect(package("postgresql-client-common")).to be_installed
    end

    it "should have a postgres user" do
        expect(user("postgres")).to exist
        expect(user("postgres")).to belong_to_group "postgres"
    end

    it "should be correct version" do
        psqlv = command("sudo -H -u postgres bash -c \"psql -t -c 'SHOW server_version;'\"").stdout.strip
        vlength = ENV['DOCKER_IMAGE_TAG'].length - 1
        psqlv_short = psqlv[0..vlength]
        expect(psqlv_short).to eq(ENV['DOCKER_IMAGE_TAG'])
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end