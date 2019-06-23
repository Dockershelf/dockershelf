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

    def php_version
        command("php -r \"echo join('.', array_slice(explode('.', explode('-', PHP_VERSION)[0]), 0, -1));\"").stdout.strip
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "should have a php interpreter" do
        expect(file("/usr/bin/php#{php_version()}")).to be_executable
        expect(file("/usr/bin/php")).to be_symlink
        expect(file("/usr/bin/php")).to be_linked_to("/usr/bin/php#{php_version()}")
    end


    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end