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