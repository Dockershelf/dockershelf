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

    it "should have an odoo binary" do
        expect(file("/usr/bin/odoo")).to be_executable
    end

    it "should contain these files" do
        expect(file("/etc/apt/sources.list.d/odoo.list")).to exist
        expect(file("/mnt/extra-addons")).to be_directory
        expect(file("/mnt/addons")).to be_symlink
    end

    it "should have these packages installed" do
        expect(package("odoo")).to be_installed
    end

    it "should have a odoo user" do
        expect(user('odoo')).to exist
        expect(user('odoo')).to belong_to_group 'odoo'
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end