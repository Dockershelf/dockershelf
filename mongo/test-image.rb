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

    # def python_version
    #     command("python -c \"import sys; print('%s.%s' % (sys.version_info[0], sys.version_info[1]))\"").stdout.strip
    # end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    # it "should have a python interpreter" do
    #     expect(file("/usr/bin/python%s" % python_version)).to be_executable
    #     expect(file("/usr/bin/python")).to be_symlink
    #     expect(file("/usr/bin/python")).to be_linked_to("/usr/bin/python%s" % python_version)
    # end

    # it "should be able to install a python package" do
    #     expect(command("pip install virtualenv").exit_status).to eq(0)
    #     expect(file('/usr/local/bin/virtualenv')).to be_executable
    # end

    # it "should be able to uninstall a python package" do
    #     expect(command("pip uninstall -y virtualenv").exit_status).to eq(0)
    #     expect(file('/usr/local/bin/virtualenv')).not_to exist
    # end

    # it "should have setuptools installed by pip" do
    #     expect(package('setuptools')).to be_installed.by('pip')
    # end

    # it "shouldn't have invalid packages installed by pip" do
    #     expect(package('invalid-pip')).not_to be_installed.by('pip').with_version('invalid-version')
    # end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end