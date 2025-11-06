package hachi64

import (
	"bytes"
	"testing"
)

// TestEncodeHachi64Examples tests the encoding examples from the documentation
func TestEncodeHachi64Examples(t *testing.T) {
	testCases := []struct {
		input    string
		expected string
	}{
		{"Hello", "豆米啊拢嘎米多="},
		{"abc", "西阿南呀"},
		{"Python", "抖咪酷丁息米都慢"},
		{"Hello, World!", "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=="},
		{"Base64", "律苦集叮希斗西丁"},
		{"Hachi64", "豆米集呀息米库咚背哈=="},
	}

	for _, tc := range testCases {
		t.Run(tc.input, func(t *testing.T) {
			result := Encode([]byte(tc.input), true)
			if result != tc.expected {
				t.Errorf("Encode(%q) = %q, want %q", tc.input, result, tc.expected)
			}
		})
	}
}

// TestDecodeHachi64Examples tests the decoding examples from the documentation
func TestDecodeHachi64Examples(t *testing.T) {
	testCases := []struct {
		input    string
		expected string
	}{
		{"豆米啊拢嘎米多=", "Hello"},
		{"西阿南呀", "abc"},
		{"抖咪酷丁息米都慢", "Python"},
		{"豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==", "Hello, World!"},
		{"律苦集叮希斗西丁", "Base64"},
		{"豆米集呀息米库咚背哈==", "Hachi64"},
	}

	for _, tc := range testCases {
		t.Run(tc.expected, func(t *testing.T) {
			result, err := Decode(tc.input, true)
			if err != nil {
				t.Fatalf("Decode(%q) returned error: %v", tc.input, err)
			}
			if string(result) != tc.expected {
				t.Errorf("Decode(%q) = %q, want %q", tc.input, string(result), tc.expected)
			}
		})
	}
}

// TestEncodeEdgeCases tests edge cases for encoding
func TestEncodeEdgeCases(t *testing.T) {
	testCases := []struct {
		name     string
		input    []byte
		expected string
	}{
		{"empty", []byte(""), ""},
		{"single byte", []byte("a"), "西律=="},
		{"two bytes", []byte("ab"), "西阿迷="},
		{"three bytes", []byte("abc"), "西阿南呀"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			result := Encode(tc.input, true)
			if result != tc.expected {
				t.Errorf("Encode(%q) = %q, want %q", tc.input, result, tc.expected)
			}
		})
	}
}

// TestDecodeEdgeCases tests edge cases for decoding
func TestDecodeEdgeCases(t *testing.T) {
	testCases := []struct {
		name     string
		input    string
		expected []byte
	}{
		{"empty", "", []byte("")},
		{"single byte", "西律==", []byte("a")},
		{"two bytes", "西阿迷=", []byte("ab")},
		{"three bytes", "西阿南呀", []byte("abc")},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			result, err := Decode(tc.input, true)
			if err != nil {
				t.Fatalf("Decode(%q) returned error: %v", tc.input, err)
			}
			if !bytes.Equal(result, tc.expected) {
				t.Errorf("Decode(%q) = %v, want %v", tc.input, result, tc.expected)
			}
		})
	}
}

// TestDecodeInvalidInput tests decoding with invalid characters
func TestDecodeInvalidInput(t *testing.T) {
	testCases := []struct {
		name  string
		input string
	}{
		{"ASCII letters", "ABC"},
		{"mixed with invalid", "哈哈哈X"},
		{"numbers", "123"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			_, err := Decode(tc.input, true)
			if err == nil {
				t.Errorf("Decode(%q) should return error for invalid input", tc.input)
			}
		})
	}
}

// TestRoundtrip tests that encoding then decoding returns the original data
func TestRoundtrip(t *testing.T) {
	testCases := [][]byte{
		[]byte("Hello, World!"),
		[]byte("rust"),
		[]byte("a"),
		[]byte("ab"),
		[]byte("abc"),
		[]byte("Python"),
		[]byte("Hachi64"),
		[]byte(""),
		[]byte("The quick brown fox jumps over the lazy dog"),
	}

	for _, tc := range testCases {
		t.Run(string(tc), func(t *testing.T) {
			encoded := Encode(tc, true)
			decoded, err := Decode(encoded, true)
			if err != nil {
				t.Fatalf("Decode returned error: %v", err)
			}
			if !bytes.Equal(decoded, tc) {
				t.Errorf("Roundtrip failed: original %q, decoded %q", tc, decoded)
			}
		})
	}
}

// TestBinaryData tests encoding and decoding binary data
func TestBinaryData(t *testing.T) {
	// Create binary data with all byte values 0-255
	binaryData := make([]byte, 256)
	for i := 0; i < 256; i++ {
		binaryData[i] = byte(i)
	}

	encoded := Encode(binaryData, true)
	decoded, err := Decode(encoded, true)
	if err != nil {
		t.Fatalf("Decode returned error: %v", err)
	}
	if !bytes.Equal(decoded, binaryData) {
		t.Errorf("Binary data roundtrip failed")
	}
}

// TestNoPaddingEncodeDecode tests encoding and decoding without padding
func TestNoPaddingEncodeDecode(t *testing.T) {
	testCases := [][]byte{
		[]byte("a"),
		[]byte("ab"),
		[]byte("abc"),
		[]byte("Hello"),
	}

	for _, tc := range testCases {
		t.Run(string(tc), func(t *testing.T) {
			encodedNoPad := Encode(tc, false)
			decoded, err := Decode(encodedNoPad, false)
			if err != nil {
				t.Fatalf("Decode returned error: %v", err)
			}
			if !bytes.Equal(decoded, tc) {
				t.Errorf("No-padding roundtrip failed: original %q, decoded %q", tc, decoded)
			}
		})
	}
}

// TestPaddingBehavior tests the difference between padding and no padding
func TestPaddingBehavior(t *testing.T) {
	testData := []byte("a")

	encodedWithPadding := Encode(testData, true)
	encodedWithoutPadding := Encode(testData, false)

	// With padding should end with ==
	if !bytes.HasSuffix([]byte(encodedWithPadding), []byte("==")) {
		t.Errorf("Encoded with padding should end with ==, got %q", encodedWithPadding)
	}

	// Without padding should not contain =
	if bytes.Contains([]byte(encodedWithoutPadding), []byte("=")) {
		t.Errorf("Encoded without padding should not contain =, got %q", encodedWithoutPadding)
	}

	// Both should decode to the same result
	decodedWithPadding, err := Decode(encodedWithPadding, true)
	if err != nil {
		t.Fatalf("Decode with padding returned error: %v", err)
	}
	decodedWithoutPadding, err := Decode(encodedWithoutPadding, false)
	if err != nil {
		t.Fatalf("Decode without padding returned error: %v", err)
	}

	if !bytes.Equal(decodedWithPadding, testData) {
		t.Errorf("Decoded with padding = %q, want %q", decodedWithPadding, testData)
	}
	if !bytes.Equal(decodedWithoutPadding, testData) {
		t.Errorf("Decoded without padding = %q, want %q", decodedWithoutPadding, testData)
	}
}

// TestAlphabetCoverage tests that the alphabet is correct
func TestAlphabetCoverage(t *testing.T) {
	// Verify alphabet length
	if len(alphabetRunes) != 64 {
		t.Errorf("Alphabet length = %d, want 64", len(alphabetRunes))
	}

	// Verify no duplicate characters
	seen := make(map[rune]bool)
	for _, r := range alphabetRunes {
		if seen[r] {
			t.Errorf("Duplicate character in alphabet: %c", r)
		}
		seen[r] = true
	}

	// Test long data to ensure all characters can be used
	longData := make([]byte, 256*3)
	for i := 0; i < 256*3; i++ {
		longData[i] = byte(i % 256)
	}

	encoded := Encode(longData, true)
	decoded, err := Decode(encoded, true)
	if err != nil {
		t.Fatalf("Decode returned error: %v", err)
	}
	if !bytes.Equal(decoded, longData) {
		t.Errorf("Long data roundtrip failed")
	}
}
