all: libexample.so app
asm-dump: asm-dump.libexample.so asm-dump.app

PHONY: all asm-dump

libexample.so: libexample.c
	@echo "building $@"
	@gcc -shared -fPIC -o $@ $<

app: go-app/main.go
	@echo "building $@"
	go build -o $@ $<

asm-dump.libexample.so: libexample.so
	@echo "disassembling $<"
	@objdump -d $<

asm-dump.app: app
	@echo "disassembling $<"
	@go tool objdump -gnu -s 'main.hello' $<

PHONY: asm-dump.libexample.so asm-dump.go-app


#qemu-system-aarch64