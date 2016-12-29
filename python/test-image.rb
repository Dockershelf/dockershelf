require "docker-api"
require "serverspec"

describe "%s %s container" % [ENV["DOCKER_IMAGE_TYPE"], ENV["DOCKER_IMAGE_TAG"]] do
    before(:all) do
        @image = Docker::Image.create('fromImage' => ENV["DOCKER_IMAGE_NAME"])
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true)
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    it "should have a python interpreter" do
        expect(file("/usr/bin/python%s" % )).to be_executable
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end