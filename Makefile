all: libexample.so

PHONY: all

libexample.so: libexample.c
	@echo "building $@"
	@gcc -shared -fPIC -o $@ $<