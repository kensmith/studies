package sys

import (
	"bytes"

	"golang.org/x/sys/unix"
)

func Uname() string {
	utsname := unix.Utsname{}
	err := unix.Uname(&utsname)
	if err != nil {
		panic(err)
	}
	sysname := string(bytes.TrimRight(utsname.Sysname[:], "\x00"))
	return sysname
}
