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

    def node_version
        command("node -e 'console.log(process.version);'").stdout.strip
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "should have a node interpreter" do
        expect(file("/usr/bin/node")).to exist
        expect(file("/usr/bin/nodejs")).to exist
    end

    it "should be able to install a npm package" do
        expect(command("npm install -g gulp").exit_status).to eq(0)
        expect(file('/usr/bin/gulp')).to be_executable
    end

    it "should be able to uninstall a npm package" do
        expect(command("npm uninstall -g gulp").exit_status).to eq(0)
        expect(file('/usr/bin/gulp')).not_to exist
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end