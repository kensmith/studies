package main

import (
	"testing"
)

func TestSanitize(t *testing.T) {
	tests := []struct {
		input    string
		expected string
	}{
		{"\n", ""},
		{"\t", ""},
		{"\r", ""},
		{"\n\t\r", ""},
		{"\n\t\r1", "1"},
		{"\n\t\r1\n\t\r", "1"},
		{"1", "1"},
		{"1\t", "1"},
		{"1\n", "1"},
		{"1\r", "1"},
		{"1\n\t\r", "1"},
		{"1\n\t\r2", "1   2"},
		{"1\n\t\r2\n\t\r", "1   2"},
		{"1\n\t\r2\n\t\r3", "1   2   3"},
	}

	for _, test := range tests {
		t.Run(test.input, func(t *testing.T) {
			actual := sanitize(test.input)
			if actual != test.expected {
				t.Errorf("expected %q, got %q", test.expected, actual)
			}
		})
	}
}
