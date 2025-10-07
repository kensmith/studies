package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"net/url"
	"os"
	"time"
)

const (
	_httpTimeout        = 5 * time.Second
	_baseUrl            = "https://aa.usno.navy.mil/api/moon/phases/date"
	_newMoonString      = "New Moon"
	_firstQuarterString = "First Quarter"
	_fullMoonString     = "Full Moon"
	_lastQuarterString  = "Last Quarter"
)

type PhaseDataResponse struct {
	Day   int    `json:"day"`
	Month int    `json:"month"`
	Year  int    `json:"year"`
	Time  string `json:"time"`
	Phase string `json:"phase"`
}

type MoonPhasesResponse struct {
	ApiVersion string              `json:"apiversion"`
	Day        int                 `json:"day"`
	Month      int                 `json:"month"`
	Year       int                 `json:"year"`
	NumPhases  int                 `json:"numphaes"`
	PhaseData  []PhaseDataResponse `json:"phasedata"`
}

/*

https://aa.usno.navy.mil/api/moon/phases/date?date=1976-01-01&nump=50

{
  "apiversion": "4.0.1",
  "day": 1,
  "month": 1,
  "numphases": 4,
  "phasedata": [
    {
      "day": 1,
      "month": 1,
      "phase": "New Moon",
      "time": "14:40",
      "year": 1976
    },
    {
      "day": 9,
      "month": 1,
      "phase": "First Quarter",
      "time": "12:40",
      "year": 1976
    },
    {
      "day": 17,
      "month": 1,
      "phase": "Full Moon",
      "time": "04:47",
      "year": 1976
    },
    {
      "day": 23,
      "month": 1,
      "phase": "Last Quarter",
      "time": "23:04",
      "year": 1976
    }
  ],
  "year": 1976
}

*/

func ConfigureLogging() {
	options := &slog.HandlerOptions{
		AddSource: true,
		Level:     slog.LevelInfo,
	}
	handler := slog.NewTextHandler(os.Stdout, options)
	logger := slog.New(handler)
	slog.SetDefault(logger)
}

func Usage() {
	fmt.Printf("Usage:\n%s <start date> <end date>\n", os.Args[0])
	os.Exit(1)
}

func main() {
	ConfigureLogging()

	httpClient := http.Client{
		Timeout: _httpTimeout,
	}

	queryUrl, err := url.Parse(_baseUrl)
	if err != nil {
		slog.Error("internal error: couldn't parse base URL", "baseUrl", _baseUrl)
		os.Exit(1)
	}

	if len(os.Args) < 3 {
		Usage()
	}
	startDateStr := os.Args[1]
	_, err = time.Parse(time.DateOnly, startDateStr)
	if err != nil {
		slog.Error("couldn't parse first argument as a date (eg. 2025-10-06)", "os.Args[1]", startDateStr)
		os.Exit(1)
	}

	endDateStr := os.Args[2]
	_, err = time.Parse(time.DateOnly, endDateStr)
	if err != nil {
		slog.Error("couldn't parse second argument as a date (eg. 2025-11-07)", "os.Args[2]", endDateStr)
		os.Exit(1)
	}

	query := url.Values{}
	query.Set("date", startDateStr)
	query.Set("nump", "50")
	queryUrl.RawQuery = query.Encode()
	slog.Info("queryUrl", "queryUrl", queryUrl.String(), "httpClient", httpClient)
	resp, err := httpClient.Get(queryUrl.String())
	if err != nil {
		slog.Error("couldn't complete query", "err", err)
		os.Exit(1)
	}

	if resp == nil {
		slog.Error("nil response received while err was nil")
		os.Exit(1)
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		slog.Error("received unexpected response code", "code", resp.StatusCode)
		os.Exit(1)
	}

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		slog.Error("failed to receive response body", "err", err)
		os.Exit(1)
	}

	var moonPhasesResponse MoonPhasesResponse
	err = json.Unmarshal(bodyBytes, &moonPhasesResponse)
	if err != nil {
		slog.Error("failed to unmarshal response", "err", err)
		os.Exit(1)
	}
	slog.Info("msg", "moonPhasesResponse", moonPhasesResponse)
}
