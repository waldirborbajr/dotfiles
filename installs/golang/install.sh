#!/usr/bin/env bash

#set -x
set -e
set -o pipefail

# INSTALL PACKAGES ------------------------------------------------------------

go install github.com/nao1215/gup@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/mgechev/revive@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install mvdan.cc/gofumpt@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/cosmtrek/air@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/aser/goreleaser@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/maaslalani/slides@latest
go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
go install github.com/spf13/cobra-cli@latest
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
go install github.com/dundee/gdu/v5/cmd/gdu@latest
go install -v github.com/incu6us/goimports-reviser/v3@latest



