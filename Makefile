PREFIX ?= /usr/local
INSTALLBIN ?= "$(PREFIX)/bin"
LIBDIR ?= ./lib
BUILDDIR ?= ./build

CC = gcc
CFLAGS = -Wall
LIBS = $(shell pkg-config --cflags --libs x11)

default: install

check_build_deps:
	@echo "Checking build dependencies"
	@./utils/check_build_deps.zsh
	@echo

check_package_deps:
	@echo "Checking package dependencies"
	@./utils/check_package_deps.zsh
	@echo

check: check_build_deps check_package_deps

build: check_build_deps ./lib/toggle-decorations.c
	@echo "Building toggle-decorations binary"
	@mkdir -p $(BUILDDIR)
	$(CC) "$(LIBDIR)/toggle-decorations.c" $(CFLAGS) -o "$(BUILDDIR)/toggle-decorations" $(LIBS)
	@echo

install: build check_package_deps
	@echo "Installing toggle-decorations binary to $(INSTALLBIN)"
	@mkdir -p $(INSTALLBIN)
	@cp -f "$(BUILDDIR)/toggle-decorations" $(INSTALLBIN)
	@echo

uninstall:
	@echo "Uninstalling toggle-decorations binary from $(INSTALLBIN)"
	@rm -rf "$(INSTALLBIN)/toggle-decorations"
	@echo

clean:
	@echo "Cleaning up"
	@rm -rf $(BUILDDIR)

.PHONY: default check_build_deps check_package_deps check build install uninstall clean
