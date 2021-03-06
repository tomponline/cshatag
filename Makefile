PREFIX ?= /usr/local
GITVERSION := $(shell git describe --dirty)

.PHONY: all
all: cshatag README.md

cshatag: *.go Makefile
	CGO_ENABLED=0 go build "-ldflags=-X main.GitVersion=${GITVERSION}"

.PHONY: install
install: cshatag
	@mkdir -v -p ${PREFIX}/bin
	@cp -v cshatag ${PREFIX}/bin
	@mkdir -v -p ${PREFIX}/share/man/man1
	@cp -v cshatag.1 ${PREFIX}/share/man/man1

.PHONY: clean
clean:
	rm -f cshatag README.md

.PHONY: format
format:
	go fmt ./...

README.md: cshatag.1 Makefile
	@echo '[![Build Status](https://travis-ci.org/rfjakob/cshatag.svg?branch=master)](https://travis-ci.org/rfjakob/cshatag)' > README.md
	@echo '[![Go Report Card](https://goreportcard.com/badge/github.com/rfjakob/cshatag)](https://goreportcard.com/report/github.com/rfjakob/cshatag)' >> README.md
	@echo '[Changelog](CHANGELOG.md)' >> README.md
	@echo >> README.md
	@echo '```' >> README.md
	MANWIDTH=80 man ./cshatag.1 >> README.md
	@echo '```' >> README.md

.PHONY: test
test: cshatag
	./tests/run_tests.sh
