package sort

import (
	"slices"
	"testing"
)

func TestSleepSort(t *testing.T) {
	test := []struct {
		in   []int
		want []int
	}{
		{
			[]int{2, 6, 1, 3, 10, 5, 7, 4, 8, 9},
			[]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
	}

	for _, tt := range test {
		got := SleepSort(tt.in)
		if !slices.Equal(got, tt.want) {
			t.Errorf("SleepSort(%v) = %v, want %v", tt.in, got, tt.want)
		}
	}
}
