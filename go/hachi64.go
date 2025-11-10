// Package hachi64 provides encoding and decoding functions for Hachi64,
// a Base64-style encoding using 64 Chinese characters.
//
// 哈基米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码。
package hachi64

import (
	"fmt"
	"strings"
)

// HachiAlphabet 哈基米64字符集：64个中文字符，按同音字分组
const HachiAlphabet = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"

// alphabetRunes contains the Hachi alphabet as a slice of runes for indexing
var alphabetRunes []rune

// reverseMap maps each character to its index in the alphabet
var reverseMap map[rune]int

func init() {
	alphabetRunes = []rune(HachiAlphabet)
	if len(alphabetRunes) != 64 {
		panic("HachiAlphabet must contain exactly 64 characters")
	}

	reverseMap = make(map[rune]int, 64)
	for i, r := range alphabetRunes {
		reverseMap[r] = i
	}
}

// Encode encodes the given byte slice into a Hachi64 string.
//
// Parameters:
//   - data: The bytes to encode
//   - padding: Whether to use '=' for padding (default true)
//
// Returns the encoded string.
func Encode(data []byte, padding bool) string {
	if len(data) == 0 {
		return ""
	}

	var result strings.Builder
	result.Grow((len(data)/3 + 1) * 4)

	// Process data in chunks of 3 bytes
	for i := 0; i < len(data); i += 3 {
		// Get byte values, padding with 0 if needed
		byte1 := data[i]
		var byte2, byte3 byte
		chunkLen := 1

		if i+1 < len(data) {
			byte2 = data[i+1]
			chunkLen = 2
		}
		if i+2 < len(data) {
			byte3 = data[i+2]
			chunkLen = 3
		}

		// Split 24 bits into 4 6-bit indices
		idx1 := byte1 >> 2
		idx2 := ((byte1 & 0x03) << 4) | (byte2 >> 4)
		idx3 := ((byte2 & 0x0F) << 2) | (byte3 >> 6)
		idx4 := byte3 & 0x3F

		// Add first two characters (always present)
		result.WriteRune(alphabetRunes[idx1])
		result.WriteRune(alphabetRunes[idx2])

		// Handle third character
		if chunkLen > 1 {
			result.WriteRune(alphabetRunes[idx3])
		} else if padding {
			result.WriteRune('=')
		}

		// Handle fourth character
		if chunkLen > 2 {
			result.WriteRune(alphabetRunes[idx4])
		} else if padding {
			result.WriteRune('=')
		}
	}

	return result.String()
}

// Decode decodes a Hachi64 string back into bytes.
//
// Parameters:
//   - encodedStr: The string to decode
//   - padding: Whether the input string uses '=' for padding (default true)
//
// Returns the decoded bytes and any error encountered.
func Decode(encodedStr string, padding bool) ([]byte, error) {
	if encodedStr == "" {
		return []byte{}, nil
	}

	// Handle padding
	padCount := 0
	if padding {
		padCount = strings.Count(encodedStr, "=")
		if padCount > 0 {
			encodedStr = strings.TrimRight(encodedStr, "=")
		}
	}

	runes := []rune(encodedStr)
	result := make([]byte, 0, (len(runes)*3)/4)

	// Process in chunks of 4 characters
	for i := 0; i < len(runes); i += 4 {
		chunkLen := 4
		if i+4 > len(runes) {
			chunkLen = len(runes) - i
		}

		// Get indices
		idx1, ok := reverseMap[runes[i]]
		if !ok {
			return nil, fmt.Errorf("invalid character in input: %c", runes[i])
		}

		var idx2, idx3, idx4 int
		if chunkLen > 1 {
			idx2, ok = reverseMap[runes[i+1]]
			if !ok {
				return nil, fmt.Errorf("invalid character in input: %c", runes[i+1])
			}
		}
		if chunkLen > 2 {
			idx3, ok = reverseMap[runes[i+2]]
			if !ok {
				return nil, fmt.Errorf("invalid character in input: %c", runes[i+2])
			}
		}
		if chunkLen > 3 {
			idx4, ok = reverseMap[runes[i+3]]
			if !ok {
				return nil, fmt.Errorf("invalid character in input: %c", runes[i+3])
			}
		}

		// Reconstruct 3 bytes from 4 6-bit indices
		byte1 := byte((idx1 << 2) | (idx2 >> 4))
		result = append(result, byte1)

		if chunkLen > 2 {
			byte2 := byte(((idx2 & 0x0F) << 4) | (idx3 >> 2))
			result = append(result, byte2)
		}

		if chunkLen > 3 {
			byte3 := byte(((idx3 & 0x03) << 6) | idx4)
			result = append(result, byte3)
		}
	}

	return result, nil
}
