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
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true)
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "should have these packages installed" do
        expect(package("texlive-fonts-recommended")).to be_installed
        expect(package("texlive-latex-base")).to be_installed
        expect(package("texlive-latex-extra")).to be_installed
        expect(package("texlive-latex-recommended")).to be_installed
    end

    it "should contain these files" do
        expect(file("/usr/bin/pdflatex")).to be_executable
    end

    it "should convert latex files to pdf" do
        expect(file("/root/sample.tex")).to exist
        expect(command("cd /root && pdflatex sample.tex").exit_status).to eq(0)
        expect(file("/root/sample.pdf")).to exist
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end