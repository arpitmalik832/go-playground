mainFile := $(wildcard *.go)

prepare:
	chmod +x git-hooks/*
	lefthook install

build: $(mainFile)
	go build -o bin/main $^

run: $(mainFile)
	go run $^

fileSizes-pre-commit:
	./git-hooks/fileSizes.sh

lint-pre-commit:
	./git-hooks/lint.sh

validate-branch-name:
	./git-hooks/validateBranchName.sh

lint:
	golangci-lint run

lint-fix:
	golangci-lint run --fix

formatter-fix:
	go fmt ./...