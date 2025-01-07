//go:build tools

package main

import (
	_ "github.com/conventionalcommit/commitlint"
	_ "github.com/evilmartians/lefthook"
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
	_ "github.com/goreleaser/goreleaser"
	_ "github.com/stretchr/testify/assert"
	_ "github.com/stretchr/testify/mock"
	_ "github.com/stretchr/testify/suite"
)
