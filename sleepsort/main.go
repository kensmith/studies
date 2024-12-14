package main

import (
	"io"
	"log/slog"
	"os"
	"strconv"
	"strings"

	"github.com/kensmith/studies/sleepsort/sort"
)

func sanitize(input string) string {
	result := strings.ReplaceAll(input, "\n", " ")
	result = strings.ReplaceAll(result, "\t", " ")
	result = strings.ReplaceAll(result, "\r", " ")
	return strings.TrimSpace(result)
}

func main() {
	bytes, err := io.ReadAll(os.Stdin)
	if err != nil {
		slog.Error("failed to read stdin", "err", err)
		os.Exit(1)
	}

	input := sanitize(string(bytes))

	tokens := strings.Split(input, " ")
	nums := []int{}
	for _, token := range tokens {
		n, err := strconv.Atoi(token)
		if err != nil {
			slog.Error("failed to parse token as int", "token", token, "err", err)
			os.Exit(1)
		}
		nums = append(nums, n)
	}

	result := sort.SleepSort(nums)

	results := []string{}
	for _, num := range result {
		results = append(results, strconv.Itoa(num))
	}

	print(strings.Join(results, " "), "\n")
}
