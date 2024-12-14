package sort

import (
	"log/slog"
	"time"

	"golang.org/x/exp/constraints"
)

func SleepSort[T constraints.Integer | constraints.Float](s []T) []T {
	c := make(chan T)

	for _, v := range s {
		go func(v T) {
			sleepFor := float64(v)
			slog.Info("dispatching", "v", v)
			time.Sleep(time.Duration(sleepFor) * time.Second)
			c <- v
		}(v)
	}

	result := []T{}
	for i, _ := range s {
		slog.Info("receiving", "i", i)
		v := <-c
		result = append(result, v)
	}

	return result
}
