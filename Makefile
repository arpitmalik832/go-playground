mainFile := src/main.go

.PHONY: prepare
prepare:
	chmod +x git-hooks/*
	chmod +x scripts/*
	lefthook install

.PHONY: build
build: $(mainFile)
	@echo "Building the executable..."
	@go build -o bin/main $^

.PHONY: preview
preview:
	@echo "Running the executable..."
	@./bin/main

.PHONY: run
run: $(mainFile)
	@echo "Running the main file..."
	@air

.PHONY: fileSizes-pre-commit
fileSizes-pre-commit:
	./git-hooks/fileSizes.sh

.PHONY: lint-pre-commit
lint-pre-commit:
	./git-hooks/lint.sh

.PHONY: validate-branch-name-pre-commit
validate-branch-name-pre-commit:
	./git-hooks/validateBranchName.sh

.PHONY: lint
lint:
	@echo "Linting..."
	@golangci-lint run

.PHONY: lint-fix
lint-fix:
	@echo "Running the lint fix..."
	@golangci-lint run --fix

.PHONY: formatter-fix
formatter-fix:
	@echo "Running formatter fixes..."
	@go fmt ./...

.PHONY: additional-checks-fix
additional-checks-fix:
	@echo "Running additional checks..."
	@go vet ./...

.PHONY: update-changelog
update-changelog:
	@echo "Generating changelog..."
	@git-chglog -o CHANGELOG.md
	@git add CHANGELOG.md
	@git commit -m "chore(main): updating changelog"

.PHONY: release
release:
	@read -p "Enter version (e.g., v1.0.0): " version; \
	echo "Creating tag $$version..."; \
	git tag -a $$version -m "Release $$version" && \
	echo "Running goreleaser..." && \
	if goreleaser release --clean; then \
		echo "Release successful!"; \
	else \
		echo "Release failed, deleting tag..." && \
		git tag -d $$version && \
		echo "Tag $$version deleted."; \
		exit 1; \
	fi

# For testing release process
.PHONY: release-dry-run
release-dry-run:
	@echo "Running release dry runner..."
	@goreleaser release --snapshot --clean

.PHONY: update-dependencies
update-dependencies:
	@echo "Updating dependencies to latest versions..."
	@go get -u ./...
	@go mod tidy

.PHONY: vulnerability-check-pre-commit
vulnerability-check-pre-commit:
	./git-hooks/vulnerabilityCheck.sh

.PHONY: vulnerability-check
vulnerability-check:
	@echo "Running vulnerability check..."
	@govulncheck ./...

.PHONY: test
test:
	@echo "Running tests..."
	@go test -v ./...

.PHONY: test-coverage
test-coverage:
	@echo "Running tests with coverage..."
	@mkdir -p coverage
	@go test -v -race -coverprofile=coverage/coverage.out -covermode=atomic ./...
	@go tool cover -html=coverage/coverage.out -o coverage/coverage.html
	@go tool cover -func=coverage/coverage.out

.PHONY: test-coverage-check-pre-commit
test-coverage-check-pre-commit:
	./git-hooks/testCoverageCheck.sh

.PHONY: test-coverage-check
test-coverage-check:
	@echo "Running tests with coverage check..."
	@mkdir -p coverage
	@go test -coverprofile=coverage/coverage.out ./...
	@coverage=$$(go tool cover -func=coverage/coverage.out | grep total | awk '{print $$3}' | sed 's/%//'); \
	if [ $$(echo "$$coverage < 90" | bc -l) -eq 1 ]; then \
		echo "Coverage ($$coverage%) below 90%"; \
		exit 1; \
	fi

.PHONY: test-coverage-badge
test-coverage-badge:
	@echo "Generating coverage badge..."
	@go test -v -covermode=count -coverprofile=coverage/coverage.out ./...
	@go tool cover -func=coverage/coverage.out | grep total | awk '{print $$3}' > coverage/coverage.txt

.PHONY: test-watch
test-watch:
	@if command -v entr > /dev/null; then \
		find . -name "*.go" | entr -c go test ./...; \
	else \
		echo "Please install entr first"; \
		exit 1; \
	fi

.PHONY: e2e-tests
e2e-tests:
	@echo "Running E2E tests..."
	@go test -v ./src/e2e/...

.PHONY: e2e-tests-pre-commit
e2e-tests-pre-commit:
	./git-hooks/e2eTests.sh

.PHONY: commit
commit:
	./scripts/commit.sh

.PHONY: size-watch
size-watch: build
	@echo "Checking binary size..."
	@size_bytes=$$(stat -f %z bin/main 2>/dev/null || stat -c %s bin/main); \
	size_mb=$$(echo "scale=2; $$size_bytes/1048576" | bc); \
	echo "Binary size: $$size_mb MB"; \
	if [ $$size_bytes -gt 10485760 ]; then \
		echo "Warning: Binary size ($$size_mb MB) exceeds 10MB limit"; \
		exit 1; \
	fi

.PHONY: size-watch-pre-commit
size-watch-pre-commit:
	./git-hooks/sizeWatch.sh
