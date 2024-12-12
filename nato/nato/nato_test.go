package nato

import (
	"testing"
)

func TestBasicNATO(t *testing.T) {
	s := "hgbrrn"
	nato := NATO(s)

	if nato == nil {
		t.Errorf("NATO(s): %s", NATO(s))
	}

	expected := []string{"hotel", "golf", "bravo", "romeo", "romeo", "november"}
	for i := 0; i < len(nato); i++ {
		if nato[i] != expected[i] {
			t.Errorf("nato[%d]: %s", i, nato[i])
		}
	}
}
