require "docker-api"
require "serverspec"

# mirror = 'http://httpredir.debian.org/debian'
# secmirror = 'http://security.debian.org'
# resolv_conf_content = %(nameserver 8.8.8.8
# nameserver 8.8.4.4)

# case ENV['DOCKER_IMAGE_TAG']
# when 'sid'
#     sources_list_content = %(deb #{mirror} sid main
#     )
# else
# end

describe "Docker image" do
    before(:all) do
        @image = Docker::Image.all()
                    .detect{|i| i.info['RepoTags']
                    .detect{|r| r == ENV['DOCKER_IMAGE_NAME']}}
        set :os, family: :debian
        set :backend, :docker
        set :docker_image, @image.id
    end

    it "should exist" do
        expect(@image).not_to be_nil
    end

    case ENV['DOCKER_IMAGE_TYPE']
    when 'debian'

        it 'should contain these files' do
            expect(file('/etc/debian_version')).to exist
            expect(file('/etc/os-release')).to exist
            expect(file('/usr/share/docker/debian/clean-apt.sh')).to exist
            expect(file('/usr/share/docker/debian/clean-dpkg.sh')).to exist
            expect(file('/usr/share/docker/debian/library.sh')).to exist
            expect(file('/usr/share/docker/debian/build-image.sh')).to exist
            expect(file('/etc/apt/apt.conf.d/100-apt')).to exist
            expect(file('/etc/dpkg/dpkg.cfg.d/100-dpkg')).to exist
            expect(file('/etc/apt/sources.list')).to exist
        end

        it 'shouldn\'t contain these files' do
            expect(file('/etc/apt/apt.conf.d/docker-clean')).not_to exist
            expect(file('/etc/apt/apt.conf.d/docker-gzip-indexes')).not_to exist
            expect(file('/etc/apt/apt.conf.d/docker-autoremove-suggests')).not_to exist
            expect(file('/etc/apt/apt.conf.d/docker-no-languages')).not_to exist
            expect(file('/etc/dpkg/dpkg.cfg.d/docker-apt-speedup')).not_to exist
        end

        # it 'should have file content' do
        #     expect(file('/etc/resolv.conf').content).to eq(resolv_conf_content)
        #     expect(file('/etc/locale.gen').content).to eq('en_US.UTF-8 UTF-8')
        #     expect(file('/etc/apt/sources.list').content)
        #         .to eq('en_US.UTF-8 UTF-8')
        #     expect(file('/etc/dpkg/dpkg.cfg.d/100-dpkg').content)
        #         .to eq('en_US.UTF-8 UTF-8')
        #     expect(file('/etc/apt/apt.conf.d/100-apt').content)
        #         .to eq('en_US.UTF-8 UTF-8')
        # end

        it 'should have these packages installed' do
            expect(package('iproute')).to be_installed
            expect(package('inetutils-ping')).to be_installed
            expect(package('locales')).to be_installed
            expect(package('curl')).to be_installed
            expect(package('ca-certificates')).to be_installed
        end

        it 'should have environmental variable' do
            debian_release = 'DEBIAN_RELEASE=%s' % ENV['DOCKER_IMAGE_TAG']
            expect(@image.json['Config']['Env']).to include(debian_release)
        end

    when 'python'
    when 'pypicontents'
    when 'latex'
    end
end