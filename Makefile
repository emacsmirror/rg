EMACS ?= emacs

PKG_NAME = $(shell cask info | head -1 | cut -f2 -d" ")
PKG_VERSION = $(shell cask version)
PKG = $(PKG_NAME)-$(PKG_VERSION).el

all: install test

test: build-test package-test ert-test

build-test:
	cask clean-elc
	cask emacs -batch -Q -eval "(progn (setq byte-compile-error-on-warn t) (batch-byte-compile))" *.el

package-test:
	-@rm -r dist 2> /dev/null || true
	cask package
	cask eval "(package-install-file \"dist/$(PKG)\")"

unit-test:
	cask exec ert-runner --pattern rg-unit

integration-test:
	cask exec ert-runner --pattern rg-integration

ert-test:
	cask exec ert-runner

install:
	cask install

.PHONY: test build-test package-test unit-test integration-test ert-test install
