package main

import (
	"io"
	"log"
	"os"

	"github.com/kensmith/studies/nato/nato"
)

func main() {
	bytes, err := io.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}

	pronunciation := nato.NATO(string(bytes))
	for _, p := range pronunciation {
		print(p + "\n")
	}
}
