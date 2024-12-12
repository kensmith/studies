package nato

// for quick recitation over voice channels
// minus elided lexemes
var nato = map[byte]string{
	'a': "alpha",
	'b': "bravo",
	'c': "charlie",
	'd': "delta",
	'e': "echo",
	'f': "foxtrot",
	'g': "golf",
	'h': "hotel",
	'i': "india",
	'j': "juliet",
	'k': "kilo",
	'l': "lima",
	'm': "mike",
	'n': "november",
	'o': "oscar",
	'p': "papa",
	'q': "quebec",
	'r': "romeo",
	's': "sierra",
	't': "tango",
	'u': "uniform",
	'v': "victor",
	'w': "whiskey",
	'x': "xray",
	'y': "yankee",
	'z': "zulu",
	'A': "ALPHA",
	'B': "BRAVO",
	'C': "CHARLIE",
	'D': "DELTA",
	'E': "ECHO",
	'F': "FOXTROT",
	'G': "GOLF",
	'H': "HOTEL",
	'I': "INDIA",
	'J': "JULIET",
	'K': "KILO",
	'L': "LIMA",
	'M': "MIKE",
	'N': "NOVEMBER",
	'O': "OSCAR",
	'P': "PAPA",
	'Q': "QUEBEC",
	'R': "ROMEO",
	'S': "SIERRA",
	'T': "TANGO",
	'U': "UNIFORM",
	'V': "VICTOR",
	'W': "WHISKEY",
	'X': "XRAY",
	'Y': "YANKEE",
	'Z': "ZULU",
	'0': "ZERO",
	'1': "WUN",
	'2': "TOO",
	'3': "TREE",
	'4': "FOWER",
	'5': "FIFE",
	'6': "SIX",
	'7': "SEVEN",
	'8': "AIT",
	'9': "NINER",
	'-': "dash",
}

func NATO(s string) []string {
	bytes := []byte(s)
	n := len(bytes)
	natoString := make([]string, n)

	for i := 0; i < n; i++ {
		natoString[i] = nato[bytes[i]]
	}

	return natoString
}
