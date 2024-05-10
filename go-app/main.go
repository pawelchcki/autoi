package main

import (
	// Force the binary to be dinamically linked.
	_ "net"
)

//go:noinline
func hello() {
	println("Hello, world!")
}

func main() {
	hello()
}
