package debug

import (
	"log/slog"
	"runtime"
	"time"
)

type Wallclock struct {
	startTime time.Time
	src       slog.Source
}

func NewWallclock() *Wallclock {
	pc, file, line, ok := runtime.Caller(1)
	src := slog.Source{
		Function: "unknown",
	}
	if ok {
		fn := runtime.FuncForPC(pc)
		if fn != nil {
			src = slog.Source{
				Function: fn.Name(),
				File:     file,
				Line:     line,
			}
		}
	}
	return &Wallclock{
		startTime: time.Now(),
		src:       src,
	}
}

func (wc *Wallclock) LogDuration() {
	durationMs := float64(time.Since(wc.startTime).Nanoseconds()) / 1e6
	slog.Info("Wallclock", slog.SourceKey, wc.src, "duration_ms", durationMs)
}
