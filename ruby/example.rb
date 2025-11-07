#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/hachi64'

puts "=== Hachi64 Ruby Example ==="
puts ""

# Basic encoding and decoding
puts "1. Basic Encoding and Decoding:"
text = "Hello, World!"
encoded = Hachi64.encode(text)
decoded = Hachi64.decode(encoded)

puts "  Original: #{text}"
puts "  Encoded:  #{encoded}"
puts "  Decoded:  #{decoded}"
puts "  Match:    #{text == decoded}"
puts ""

# Without padding
puts "2. Encoding Without Padding:"
text = "Hello"
encoded_with_padding = Hachi64.encode(text, padding: true)
encoded_without_padding = Hachi64.encode(text, padding: false)

puts "  Original: #{text}"
puts "  With padding:    #{encoded_with_padding}"
puts "  Without padding: #{encoded_without_padding}"
puts ""

# Multiple test cases
puts "3. Multiple Test Cases:"
test_cases = {
  "abc" => "西阿南呀",
  "Python" => "抖咪酷丁息米都慢",
  "Base64" => "律苦集叮希斗西丁",
  "Hachi64" => "豆米集呀息米库咚背哈=="
}

test_cases.each do |input, expected|
  encoded = Hachi64.encode(input)
  match = encoded == expected ? "✓" : "✗"
  puts "  #{match} #{input.ljust(10)} => #{encoded}"
end
puts ""

# Binary data
puts "4. Binary Data Encoding:"
binary_data = [0xFF, 0x00, 0xAB, 0xCD].pack('C*')
encoded = Hachi64.encode(binary_data)
decoded = Hachi64.decode(encoded)

puts "  Binary input:  #{binary_data.unpack('H*').first}"
puts "  Encoded:       #{encoded}"
puts "  Decoded:       #{decoded.unpack('H*').first}"
puts "  Match:         #{binary_data == decoded}"
puts ""

# Character set info
puts "5. Character Set Information:"
puts "  Alphabet length: #{Hachi64::HACHI_ALPHABET.length}"
puts "  Unique chars:    #{Hachi64::HACHI_ALPHABET.chars.uniq.length}"
puts "  First 10 chars:  #{Hachi64::HACHI_ALPHABET[0...10]}"
puts ""

puts "=== Example Complete ==="
