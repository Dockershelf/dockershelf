# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "docker-api"
require "serverspec"

describe "%s %s container" % [ENV["DOCKER_IMAGE_TYPE"], ENV["DOCKER_IMAGE_TAG"]] do
    before(:all) do
        Docker.options[:read_timeout] = 1200
        Docker.options[:write_timeout] = 1200

        @image = Docker::Image.get(ENV["DOCKER_IMAGE_NAME"])
        @container = Docker::Container.create('Image' => @image.id, 'Tty' => true, 'Cmd' => ['bash'])
        @container.start

        set :backend, :docker
        set :docker_container, @container.id
    end

    def go_version
        command("go version").stdout.strip.split(" ")[2].gsub("go", "")
    end

    def go_version_short
        go_version().split(".")[0..1].join(".")
    end

    def go_version_container_var
        command("echo $GO_VER_NUM").stdout.strip
    end

    it "should exist" do
        expect(@container).not_to be_nil
    end

    it "OS architecture should be %s" % ENV["DOCKER_IMAGE_ARCH"] do
        case ENV['DOCKER_IMAGE_ARCH']
        when "amd64"
            expect(os[:arch]).to eq("x86_64")
        when "arm64"
            expect(os[:arch]).to eq("aarch64")
        end
    end

    it "should have a go interpreter" do
        expect(file("/usr/lib/go-#{go_version_short()}/bin/go")).to be_executable
        expect(file("/usr/bin/go")).to be_symlink
        expect(file("/usr/bin/go")).to be_linked_to("../lib/go-#{go_version_short()}/bin/go")
    end

    it "should have the correct go version" do
        expect(go_version_short()).to eq(ENV["DOCKER_IMAGE_TYPE_VERSION"])
        expect(go_version()).to eq(go_version_container_var())
    end

    it "should support go module management" do
        expect(command("mkdir -p /tmp/testmod && cd /tmp/testmod && go mod init example.com/test").exit_status).to eq(0)
        expect(file("/tmp/testmod/go.mod")).to exist
        expect(file("/tmp/testmod/go.mod")).to contain("module example.com/test")
    end

    it "should build and execute a simple program" do
        program = 'package main\nimport "fmt"\nfunc main() { fmt.Println("test-output") }'
        expect(command("mkdir -p /tmp/testbuild && cd /tmp/testbuild && echo '#{program}' > main.go && go build -o testprog main.go").exit_status).to eq(0)
        expect(file("/tmp/testbuild/testprog")).to be_executable
        expect(command("/tmp/testbuild/testprog").stdout.strip).to eq("test-output")
    end

    it "should have go standard tools available" do
        expect(command("which gofmt").exit_status).to eq(0)
        expect(command("go help vet").exit_status).to eq(0)
        expect(command("go help test").exit_status).to eq(0)
        expect(command("go help doc").exit_status).to eq(0)
    end

    it "should have go environment variables properly configured" do
        expect(command("go env GOROOT").stdout.strip).to eq("/usr/lib/go-#{go_version_short()}")
        expect(command("go env GOPATH").stdout.strip).not_to be_empty
        expect(command("which go").stdout.strip).to eq("/usr/bin/go")
    end

    it "should compile and run a program using the standard library" do
        program = 'package main\nimport ("fmt";"os")\nfunc main() { fmt.Println(os.Getenv("HOME")) }'
        expect(command("mkdir -p /tmp/teststdlib && cd /tmp/teststdlib && echo '#{program}' > main.go && go build -o teststdlib main.go").exit_status).to eq(0)
        expect(file("/tmp/teststdlib/teststdlib")).to be_executable
        expect(command("/tmp/teststdlib/teststdlib").stdout.strip).to eq("/root")
    end

    it "should report CGO status correctly" do
        expect(command("go env CGO_ENABLED").stdout.strip).to match(/^[01]$/)
    end

    it "should run go test and report results" do
        test_program = 'package main\nimport "testing"\nfunc TestAdd(t *testing.T) { if 1+1 != 2 { t.Fatal("math is broken") } }'
        expect(command("mkdir -p /tmp/testunit && cd /tmp/testunit && go mod init example.com/testunit && echo '#{test_program}' > main_test.go && go test -v .").exit_status).to eq(0)
        expect(command("cd /tmp/testunit && go test -v .").stdout.strip).to match(/PASS/)
    end

    it "should build a static binary" do
        program = 'package main\nimport "fmt"\nfunc main() { fmt.Println("static") }'
        expect(command("mkdir -p /tmp/teststatic && cd /tmp/teststatic && go mod init example.com/teststatic && echo '#{program}' > main.go && CGO_ENABLED=0 go build -ldflags='-extldflags=-static' -o teststatic main.go").exit_status).to eq(0)
        expect(file("/tmp/teststatic/teststatic")).to be_executable
        expect(command("/tmp/teststatic/teststatic").stdout.strip).to eq("static")
    end

    it "should support cross-compilation for another OS" do
        program = 'package main\nimport "fmt"\nfunc main() { fmt.Println("cross") }'
        expect(command("mkdir -p /tmp/testcross && cd /tmp/testcross && echo '#{program}' > main.go && GOOS=windows GOARCH=amd64 go build -o testcross.exe main.go").exit_status).to eq(0)
        expect(file("/tmp/testcross/testcross.exe")).to exist
    end

    it "should have go vet run without crashing" do
        program = 'package main\nimport "fmt"\nfunc main() { fmt.Println("vet-me") }'
        expect(command("mkdir -p /tmp/testvet && cd /tmp/testvet && go mod init example.com/testvet && echo '#{program}' > main.go && go vet ./...").exit_status).to eq(0)
    end

    it "should compile a program using goroutines and channels" do
        program = 'package main\nimport "fmt"\nfunc main() { ch := make(chan string); go func() { ch <- "concurrent" }(); fmt.Println(<-ch) }'
        expect(command("mkdir -p /tmp/testconcurrent && cd /tmp/testconcurrent && echo '#{program}' > main.go && go build -o testconcurrent main.go").exit_status).to eq(0)
        expect(file("/tmp/testconcurrent/testconcurrent")).to be_executable
        expect(command("/tmp/testconcurrent/testconcurrent").stdout.strip).to eq("concurrent")
    end

    it "should have gofmt produce expected output" do
        unformatted = 'package main\nimport "fmt"\nfunc main(){fmt.Println("fmt")}'
        expect(command("mkdir -p /tmp/testfmt && cd /tmp/testfmt && echo '#{unformatted}' > main.go && gofmt -w main.go").exit_status).to eq(0)
        expect(file("/tmp/testfmt/main.go")).to contain("func main() {")
    end

    it "should compile a program with the net/http package" do
        program = 'package main\nimport ("fmt";"net/http")\nfunc main() { fmt.Println(http.StatusOK) }'
        expect(command("mkdir -p /tmp/testnet && cd /tmp/testnet && echo '#{program}' > main.go && go build -o testnet main.go").exit_status).to eq(0)
        expect(file("/tmp/testnet/testnet")).to be_executable
        expect(command("/tmp/testnet/testnet").stdout.strip).to eq("200")
    end

    after(:all) do
        @container.kill
        @container.delete(:force => true)
    end
end
