package main

import (
	"log/slog"

	"golang.org/x/sys/unix"
)

func main() {
	utsname := unix.Utsname{}
	err := unix.Uname(&utsname)
	if err != nil {
		panic(err)
	}
	slog.Info("asdf", "Sysname", utsname.Sysname)
}
