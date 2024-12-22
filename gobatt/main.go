package main

/* Usage example .screenrc

cat << EOF >> $HOME/.screenrc
backtick 1 0 0 $HOME/.local/bin/gobatt
hardstatus on
hardstatus alwayslastline
hardstatus string "%{+b}%H %w%=%1` %c %M%d%D%{-b}"
EFO

Will send notifications at low and critical thresholds. Use with Dunst
https://github.com/dunst-project/dunst , for example.
*/

import (
	"fmt"
	"log/slog"
	"math"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gen2brain/beeep"

	"github.com/kensmith/studies/gobatt/sys"
)

const (
	batterySysFileGlob       = "/sys/bus/acpi/drivers/battery/PNP0C0A:0*/power_supply/*"
	lowBatteryThreshold      = 15
	criticalBatteryThreshold = 5
)

var lowBatteryGate = false
var criticalBatteryGate = false

func assertPath(path string) string {
	glob, err := filepath.Glob(path)
	if err != nil || len(glob) <= 0 {
		panic("path assertion failed: " + path)
	}
	return glob[0]
}

func readString(path string) string {
	contents, err := os.ReadFile(path)
	if err != nil || len(contents) <= 0 {
		panic("couldn't read contents of file")
	}
	s := strings.Trim(string(contents), " \n\t\r")
	return s
}

func assertString(path string) string {
	return readString(assertPath(path))
}

func readInt(path string) int {
	s := readString(path)
	val, err := strconv.Atoi(s)
	if err != nil {
		panic("couldn't convert file contents to int")
	}
	return val
}

func assertInt(path string) int {
	return readInt(assertPath(path))
}

// these should be platform specific ways to get the current battery
// fullness as a number between 0 and 1 and the discharging state (true =
// discharging)
var Batterizers = map[string]func() (float64, bool){
	"Linux": func() (float64, bool) {
		baseDir := assertPath(batterySysFileGlob)
		energyNow := assertInt(baseDir + "/energy_now")
		energyFull := assertInt(baseDir + "/energy_full")
		batt := float64(energyNow) / float64(energyFull)
		statusString := assertString(baseDir + "/status")
		status := statusString == "Discharging"

		return batt, status
	},
}

func main() {
	uname := sys.Uname()
	batterizer, ok := Batterizers[uname]
	if !ok {
		slog.Error("no batterizer implemented", "uname", uname)
		panic(uname)
	}
	for {
		ratio, discharging := batterizer()
		percentage := math.Round(ratio * 100)
		msg := fmt.Sprintf("%v%%", percentage)
		if discharging {
			msg = fmt.Sprintf("{%v}", msg)
		} else {
			msg = fmt.Sprintf("[%v]", msg)
		}
		fmt.Println(msg)
		os.Stdout.Sync()

		if percentage <= criticalBatteryThreshold && !criticalBatteryGate {
			if discharging {
				critMsg := fmt.Sprintf("battery is critical: %v%%", percentage)
				criticalBatteryGate = true
				_ = beeep.Alert("battery", critMsg, "")
			}
		} else if percentage <= lowBatteryThreshold && !lowBatteryGate {
			if discharging {
				lowMsg := fmt.Sprintf("battery is low: %v%%", percentage)
				lowBatteryGate = true
				_ = beeep.Notify("battery", lowMsg, "")
			}
		} else {
			if !discharging {
				criticalBatteryGate = false
				lowBatteryGate = false
			}
		}

		time.Sleep(1 * time.Second)
	}
}
