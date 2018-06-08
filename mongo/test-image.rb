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

    it "should be able to execute an operation on mongo shell" do
        expect(command("service mongodb start").exit_status).to eq(0)
        expect(command("mongo admin --eval 'db.stats();'").exit_status).to eq(0)
    end
    

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end