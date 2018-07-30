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

    it "should be able to start" do
        expect(command("service postgres start").exit_status).to eq(0)
    end

    it "should contain these files" do
        expect(file("/etc/apt/sources.list.d/postgres.list")).to exist
        expect(file("/var/lib/postgresql/data")).to be_directory
        expect(file("/var/run/postgresql")).to be_directory
        expect(file("/docker-entrypoint-initdb.d")).to be_directory
    end

    it "should have these packages installed" do
        expect(package("postgresql-#{ENV['DOCKER_IMAGE_TAG']}")).to be_installed
        expect(package("postgresql-common")).to be_installed
        expect(package("postgresql-client-#{ENV['DOCKER_IMAGE_TAG']}")).to be_installed
        expect(package("postgresql-client-common")).to be_installed
    end

    it "should have a postgres user" do
        expect(user("postgres")).to exist
        expect(user("postgres")).to belong_to_group "postgres"
    end

    it "should be correct version" do
        psqlv = command("sudo -H -u postgres bash -c \"psql -t -c 'SHOW server_version;'\"").stdout.strip
        vlength = ENV['DOCKER_IMAGE_TAG'] - 1
        psqlv_short = mongov[0..vlength]
        expect(psqlv_short).to eq(ENV['DOCKER_IMAGE_TAG'])
    end

    # it "should be able to execute an operation on mongo shell" do
    #     expect(command("mongo admin --eval 'db.stats();'").exit_status).to eq(0)
    # end

    # it "should be able to execute scripts" do
    #     expect(command("mongo /root/articles.js").exit_status).to eq(0)
    #     expect(command("mongo /root/aggregate.js").exit_status).to eq(0)
    # end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end