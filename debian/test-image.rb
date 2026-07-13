require "docker-api"
require "serverspec"

describe "%s %s container (%s)" % [ENV["DOCKER_IMAGE_TYPE"], ENV["DOCKER_IMAGE_TAG"], ENV["DOCKER_IMAGE_ARCH"]] do
    before(:all) do
        Docker.options[:read_timeout] = 1200
        Docker.options[:write_timeout] = 1200

        @image = Docker::Image.get(ENV["DOCKER_IMAGE_NAME"])
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true, 'Cmd' => ['bash'])
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "OS family should be debian" do
        expect(os[:family]).to eq("debian")
    end

    it "OS release should be %s" % ENV["DOCKER_IMAGE_TAG"] do
        expect(file('/etc/os-release').content).to match(Regexp.new("PRETTY_NAME=.*" % ENV["DOCKER_IMAGE_TAG"]))
    end

    it "OS architecture should be %s" % ENV["DOCKER_IMAGE_ARCH"] do
        case ENV['DOCKER_IMAGE_ARCH']
        when "amd64"
            expect(os[:arch]).to eq("x86_64")
        when "arm64"
            expect(os[:arch]).to eq("aarch64")
        end
    end

    it "should have a proper root user" do
        expect(user('root')).to exist
        expect(user('root')).to belong_to_group 'root'
        expect(user('root')).not_to belong_to_group 'invalid-group'
        expect(user('root')).to have_uid 0
        expect(user('root')).not_to have_uid 'invalid-uid'
        expect(user('root')).to have_login_shell '/bin/bash'
        expect(user('root')).not_to have_login_shell 'invalid-login-shell'
        expect(user('root')).to have_home_directory '/root'
        expect(user('root')).not_to have_authorized_key 'invalid-key'
        expect(user('root')).not_to have_home_directory 'invalid-home-directory'
    end

    it "shouldn't have invalid users" do
        expect(user('invalid-user')).not_to exist
    end

    it "should have userdel and groupdel commands available" do
        expect(command("which userdel").exit_status).to eq(0)
        expect(command("which groupdel").exit_status).to eq(0)
        expect(command("userdel --help").exit_status).to eq(0)
        expect(command("groupdel --help").exit_status).to eq(0)
    end

    it "should have a proper /etc/passwd file" do
        expect(file('/etc/passwd')).to be_mode 644
        expect(file('/etc/passwd')).not_to be_mode 'invalid'
        expect(file('/etc/passwd')).to be_owned_by 'root'
        expect(file('/etc/passwd')).to be_grouped_into 'root'
        expect(file('/etc/passwd')).not_to be_owned_by 'invalid-owner'
        expect(file('/etc/passwd')).not_to be_grouped_into 'invalid-group'
    end

    it "should contain these files" do
        expect(file("/etc/debian_version")).to exist
        expect(file("/etc/os-release")).to exist
        expect(file("/etc/apt/sources.list")).to exist
        expect(file("/usr/share/dockershelf/clean-apt.sh")).to exist
        expect(file("/usr/share/dockershelf/clean-dpkg.sh")).to exist
        expect(file("/etc/apt/apt.conf.d/dockershelf")).to exist
        expect(file("/etc/dpkg/dpkg.cfg.d/dockershelf")).to exist
    end

    it "should have these locales configured" do
        case ENV['DOCKER_IMAGE_TAG']
        when "bullseye"
            expect(command("locale -a").stdout.split("\n")).to include("C", "C.UTF-8", "POSIX")
        else
            expect(command("locale -a").stdout.split("\n")).to include("C", "C.utf8", "POSIX")
        end
        expect(command("locale").stdout.split("\n")).to include("LANG=en_US.UTF-8")
    end

    it "should have these packages installed" do
        expect(package("inetutils-ping")).to be_installed
        expect(package("locales")).to be_installed
        expect(package("curl")).to be_installed
        expect(package("ca-certificates")).to be_installed
        expect(package("bash-completion")).to be_installed
        expect(package("iproute2")).to be_installed
    end

    it "shouldn't have invalid packages installed" do
        expect(package('invalid-package')).not_to be_installed
    end

    it "should have environmental variable" do
        debian_release = "DEBIAN_RELEASE=%s" % ENV["DOCKER_IMAGE_TAG"]
        expect(@image.json["Config"]["Env"]).to include(debian_release)
    end

    it "shouldn't have apt cache files" do
        expect(file("/var/cache/apt/pkgcache.bin")).not_to exist
        expect(file("/var/cache/apt/srcpkgcache.bin")).not_to exist
    end

    it "shouldn't contain apt cache files after an apt-get update" do
        expect(command("ls -1 /var/cache/apt").stdout).to be_empty
        expect(command("apt-get update", 120).exit_status).to eq(0)
        expect(command("ls -1 /var/cache/apt").stdout).to be_empty
        expect(file("/var/cache/apt/pkgcache.bin")).not_to exist
        expect(file("/var/cache/apt/srcpkgcache.bin")).not_to exist
    end

    it "should contain apt list files after an apt-get update" do
        expect(file("/var/lib/apt/lists/deb.debian.org_debian_dists_%s_InRelease" % ENV["DOCKER_IMAGE_TAG"])).to exist
    end

    it "should be able to install a package" do
        expect(command("apt-get update", 120).exit_status).to eq(0)
        expect(command("apt-get install make").exit_status).to eq(0)
        expect(file('/usr/bin/make')).to be_executable
    end

    it "should be able to uninstall a package" do
        expect(command("apt-get purge make").exit_status).to eq(0)
        expect(file('/usr/bin/make')).not_to exist
    end

    it "should have these directories empty" do
        expect(command("ls -1 /usr/share/doc").stdout).to be_empty
        expect(command("ls -1 /usr/share/locale").stdout).to be_empty
        expect(command("ls -1 /usr/share/man").stdout).to be_empty
        expect(command("ls -1 /var/cache/apt").stdout).to be_empty
        expect(command("ls -1 /var/cache/debconf").stdout).to be_empty
    end

    it "should have clean-apt.sh and clean-dpkg.sh executable" do
        expect(file("/usr/share/dockershelf/clean-apt.sh")).to be_executable
        expect(file("/usr/share/dockershelf/clean-dpkg.sh")).to be_executable
    end

    it "should have no broken packages according to dpkg" do
        expect(command("dpkg --audit").exit_status).to eq(0)
        expect(command("dpkg --audit").stdout).to be_empty
    end

    it "should not have apt or dpkg lock files" do
        expect(file("/var/lib/dpkg/lock")).not_to exist
        expect(file("/var/lib/dpkg/lock-frontend")).not_to exist
        expect(file("/var/cache/apt/archives/lock")).not_to exist
    end

    it "should have proper permissions on critical directories and files" do
        expect(file("/tmp")).to be_mode 1777
        expect(file("/root")).to be_mode 700
        expect(file("/etc/shadow")).to exist
        expect(file("/etc/shadow")).to be_mode 640
        expect(file("/etc/shadow")).to be_owned_by 'root'
    end

    it "should have essential system packages installed" do
        expect(package("apt")).to be_installed
        expect(package("dpkg")).to be_installed
        expect(package("libc6")).to be_installed
        expect(package("coreutils")).to be_installed
    end

    it "should have a working /bin/bash" do
        expect(file("/bin/bash")).to exist
        expect(file("/bin/bash")).to be_executable
    end

    it "should report the correct dpkg architecture" do
        case ENV['DOCKER_IMAGE_ARCH']
        when "amd64"
            expect(command("dpkg --print-architecture").stdout.strip).to eq("amd64")
        when "arm64"
            expect(command("dpkg --print-architecture").stdout.strip).to eq("arm64")
        end
    end

    it "should be able to resolve DNS" do
        expect(command("getent hosts deb.debian.org").exit_status).to eq(0)
    end

    it "should be able to fetch an HTTPS resource with curl" do
        expect(command("curl -fsSL -o /dev/null https://deb.debian.org/").exit_status).to eq(0)
    end

    it "should have an empty or minimal /var/log" do
        log_files = command("ls -1A /var/log").stdout.split("\n").reject { |f| f.empty? }
        allowed = ["apt", "dpkg.log", "alternatives.log", "lastlog", "wtmp", "btmp"]
        unexpected = log_files.reject { |f| allowed.include?(f) }
        expect(unexpected).to be_empty, "Unexpected log files: #{unexpected.join(', ')}"
    end

    it "should support UTF-8 filenames" do
        expect(command("touch /tmp/ñ_test_文件").exit_status).to eq(0)
        expect(file("/tmp/ñ_test_文件")).to exist
        expect(command("rm -f /tmp/ñ_test_文件").exit_status).to eq(0)
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end
