//go:build tools

package tools

import (
	_ "github.com/conventionalcommit/commitlint"
	_ "github.com/evilmartians/lefthook"
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
)
