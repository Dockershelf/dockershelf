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

    def python_bin
        case ENV['DOCKER_IMAGE_TAG']
        when "2.7"
            "python"
        else
            "python3"
        end
    end

    def pip_bin
        case ENV['DOCKER_IMAGE_TAG']
        when "2.7"
            "pip"
        else
            "pip3"
        end
    end

    def python_version
        command("#{python_bin()} -c \"import sys; print('%s.%s' % (sys.version_info[0], sys.version_info[1]))\"").stdout.strip
    end

    def python_version_long
        releaselevel = command("#{python_bin()} -c \"import sys; print(sys.version_info.releaselevel)\"").stdout.strip
        case releaselevel
        when "alpha"
            command("#{python_bin()} -c \"import sys; print('%s.%s.%sa%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "beta"
            command("#{python_bin()} -c \"import sys; print('%s.%s.%sb%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "candidate"
            command("#{python_bin()} -c \"import sys; print('%s.%s.%src%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2], sys.version_info[4]))\"").stdout.strip
        when "final"
            command("#{python_bin()} -c \"import sys; print('%s.%s.%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2]))\"").stdout.strip
        end
    end

    basic_tests = ['test_grammar', 'test_opcodes', 'test_dict', 'test_builtin', 'test_types', 'test_doctest2']

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "should have a python interpreter" do
        expect(file("/usr/bin/python#{python_version()}")).to be_executable
        expect(file("/usr/bin/#{python_bin()}")).to be_symlink
        expect(file("/usr/bin/#{python_bin()}")).to be_linked_to("/usr/bin/python#{python_version()}")
    end

    it "should be able to install a python package" do
        expect(command("#{pip_bin()} install virtualenv").exit_status).to eq(0)
        expect(file('/usr/local/bin/virtualenv')).to be_executable
    end

    it "should be able to uninstall a python package" do
        expect(command("#{pip_bin()} uninstall -y virtualenv").exit_status).to eq(0)
        expect(file('/usr/local/bin/virtualenv')).not_to exist
    end

    it "should have setuptools installed by pip" do
        expect(package('setuptools')).to be_installed.by('pip')
    end

    it "shouldn't have invalid packages installed by pip" do
        expect(package('invalid-pip')).not_to be_installed.by('pip').with_version('invalid-version')
    end

    it "should pass basic internal tests" do
        expect(command("apt-get update", 120).exit_status).to eq(0)
        expect(command("apt-get install git rsync").exit_status).to eq(0)
        expect(command("git clone --branch v#{python_version_long()} --depth 1 https://github.com/python/cpython /tmp/cpython").exit_status).to eq(0)
        expect(command("rsync -avz /tmp/cpython/Lib/test/ /usr/lib/python#{python_version()}/test/").exit_status).to eq(0)
        for test_suite in basic_tests
            expect(command("#{python_bin()} -m test.regrtest #{test_suite}").exit_status).to eq(0)
        end
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end