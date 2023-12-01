.PHONY: build clean gomodgen


#$(compile) bin/authorization/bootstrap -tags lambda.norpc cmd/authorization/authorization_transaction_handler.go
build: gomodgen
	export GO111MODULE=on
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/hello hello/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/world world/main.go

	zip -j -r hello.zip bin/hello bootstrap
	zip -j -r world.zip bin/world bootstrap
	echo serverless > serverless-state.json
	mkdir my-artifacts
	mv hello.zip my-artifacts
	mv world.zip my-artifacts
clean:
	rm -rf ./bin ./vendor go.sum

deploy: clean build
	sls deploy --verbose

gomodgen:
	chmod u+x gomod.sh
	./gomod.sh
