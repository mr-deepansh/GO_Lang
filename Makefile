# ==============================================================================
# Go Engineering Mastery — Makefile
# ==============================================================================

FILE ?= 01_basics/01_basic.go

.PHONY: all run test race bench vet escape tidy clean help

all: help

help:
	@echo "=========================================================="
	@echo "       GOLANG ENGINEERING MASTERY — COMMAND CHEATSHEET    "
	@echo "=========================================================="
	@echo "  make run FILE=<path>     Run a specific Go file"
	@echo "  make test                Run all unit tests with coverage"
	@echo "  make race FILE=<path>    Run target with Race Detector"
	@echo "  make bench               Run micro-benchmarks with memory stats"
	@echo "  make vet                 Run static code analysis (go vet)"
	@echo "  make escape FILE=<path>  Run escape analysis (-gcflags='-m')"
	@echo "  make tidy                Clean and sync go.mod / go.sum"
	@echo "  make clean               Remove compiled binaries and test cache"
	@echo "=========================================================="

run:
	go run $(FILE)

test:
	go test -v -cover ./...

race:
	go run -race $(FILE)

bench:
	go test -bench=. -benchmem ./...

vet:
	go vet ./...

escape:
	go build -gcflags="-m" $(FILE)

tidy:
	go mod tidy

clean:
	go clean -testcache
	rm -f *.exe *.out

