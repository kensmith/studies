package main

import (
	"log/slog"

	"github.com/kensmith/gobatt/sys"
)

var Batterizers = map[string]func() float64{
	"Linux": func() float64 {
		slog.Info("batterizer 100 for linux")
		return 0.0
	},
}

func main() {
	if sys.Uname() == "Linux" {
		slog.Info("yes")
	} else {
		slog.Info("no")
	}

	uname := sys.Uname()
	batterizer, ok := Batterizers[uname]
	if !ok {
		slog.Error("no batterizer implemented", "uname", uname)
		panic(uname)
	}
	slog.Info("asdf", "batterizer", batterizer())
}
