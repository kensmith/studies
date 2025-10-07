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

func GetMoonPhasesForOneYear(httpClient http.Client, year int) (*MoonPhasesResponse, error) {
	startDateStr := fmt.Sprintf("%d-01-01", year)

	query := url.Values{}
	query.Set("date", startDateStr)
	query.Set("nump", "50")
	queryUrl, err := url.Parse(_baseUrl)
	if err != nil {
		return nil, err
	}
	queryUrl.RawQuery = query.Encode()
	resp, err := httpClient.Get(queryUrl.String())
	if err != nil {
		return nil, err
	}

	if resp == nil {
		return nil, fmt.Errorf("nil response received while err was nil")
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("received unexpected response code %d", resp.StatusCode)
	}

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var moonPhasesResponse MoonPhasesResponse
	err = json.Unmarshal(bodyBytes, &moonPhasesResponse)
	if err != nil {
		return nil, err
	}
	return &moonPhasesResponse, nil
}

func main() {
	ConfigureLogging()

	httpClient := http.Client{
		Timeout: _httpTimeout,
	}

	if len(os.Args) < 3 {
		Usage()
	}
	startDateStr := os.Args[1]
	startDate, err := time.Parse(time.DateOnly, startDateStr)
	if err != nil {
		slog.Error("couldn't parse first argument as a date (eg. 2025-10-06)", "os.Args[1]", startDateStr)
		os.Exit(1)
	}

	endDateStr := os.Args[2]
	endDate, err := time.Parse(time.DateOnly, endDateStr)
	if err != nil {
		slog.Error("couldn't parse second argument as a date (eg. 2025-11-07)", "os.Args[2]", endDateStr)
		os.Exit(1)
	}

	startYear := startDate.Year()
	endYear := endDate.Year()
	var moonPhasesForYears []*MoonPhasesResponse
	for year := startYear; year <= endYear; year++ {
		resp, err := GetMoonPhasesForOneYear(httpClient, year)
		if err != nil {
			slog.Error("failed to get moon phases for year", "year", year, "err", err)
			os.Exit(1)
		}
		moonPhasesForYears = append(moonPhasesForYears, resp)
	}

	fullmoons := 0
	for _, moonPhaseResponse := range moonPhasesForYears {
		for _, phaseData := range moonPhaseResponse.PhaseData {
			if moonPhaseResponse.Year != phaseData.Year {
				continue
			}
			month := time.Month(phaseData.Month)
			phaseDate := time.Date(phaseData.Year, month, phaseData.Day, 0, 0, 0, 0, time.UTC)
			if phaseDate.Before(startDate) {
				continue
			}
			if phaseDate.After(endDate) {
				continue
			}
			if phaseData.Phase == _fullMoonString {
				fullmoons += 1
			}
		}
	}
	fmt.Printf("%d full moons\n", fullmoons)
}
