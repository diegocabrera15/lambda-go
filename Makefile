compile = env GOOS=linux  GOARCH=arm64  go build -v -ldflags '-s -w -v' -tags lambda.norpc -o

build:
	go mod download github.com/aws/aws-lambda-go

	$(compile) bin/hello/bootstrap hello/main.go
	$(compile) bin/world/bootstrap world/main.go

zip:
	zip -j -r bin/hello.zip bin/hello/bootstrap
	zip -j -r bin/world.zip bin/world/bootstrap

clean:
	rm -rf ./bin ./vendor go.sum

deploy: clean build zip
	sls deploy --verbose

gomodgen:
	chmod u+x gomod.sh
	./gomod.sh
