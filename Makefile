.PHONY: build-client build-server build clean run test

build:	clean build-client build-server

test:
	export GO111MODULE=on
	go test .

build-client: go.sum test
	export GO111MODULE=on
	env GOARCH=wasm GOOS=js go build -ldflags="-s -w" -o bin/client.wasm .

build-server: build-client
	export GO111MODULE=on
	go build -ldflags="-s -w" -o bin/server server/main.go
	cp server/index.html bin/index.html
	cp server/wasm_exec.js bin/wasm_exec.js

run:	build
	./bin/server

clean:
	rm -rf ./bin ./vendor Gopkg.lock

go.mod:
	env GO111MODULE=on go mod init "github.com/paul-nelson-baker/wasm-game-of-life"

go.sum: go.mod
	env GO111MODULE=on go mod vendor
