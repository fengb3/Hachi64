# frozen_string_literal: true

# Hachi64: 哈吉米64 Encoding and Decoding
# This module provides encoding and decoding using the Hachi64 character set.

module Hachi64
  # The Hachi64 alphabet - 64 unique Chinese characters
  HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"

  # Encodes a byte string into a Hachi64 string using the Hachi64 alphabet.
  #
  # @param data [String] The bytes to encode (binary string)
  # @param padding [Boolean] Whether to use '=' for padding (default: true)
  # @return [String] The encoded string
  def self.encode(data, padding: true)
    alphabet = HACHI_ALPHABET
    result = []
    data_len = data.bytesize
    i = 0

    while i < data_len
      chunk = data.byteslice(i, 3)
      i += 3

      byte1 = chunk.getbyte(0)
      byte2 = chunk.bytesize > 1 ? chunk.getbyte(1) : 0
      byte3 = chunk.bytesize > 2 ? chunk.getbyte(2) : 0

      idx1 = byte1 >> 2
      idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4)
      idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6)
      idx4 = byte3 & 0x3F

      result << alphabet[idx1]
      result << alphabet[idx2]

      if chunk.bytesize > 1
        result << alphabet[idx3]
      elsif padding
        result << '='
      end

      if chunk.bytesize > 2
        result << alphabet[idx4]
      elsif padding
        result << '='
      end
    end

    result.join
  end

  # Decodes a Hachi64 string into bytes using the Hachi64 alphabet.
  #
  # @param encoded_str [String] The string to decode
  # @param padding [Boolean] Whether the input string uses '=' for padding (default: true)
  # @return [String] The decoded bytes (binary string)
  # @raise [ArgumentError] If the input string contains invalid characters
  def self.decode(encoded_str, padding: true)
    alphabet = HACHI_ALPHABET
    reverse_map = {}
    alphabet.each_char.with_index { |char, i| reverse_map[char] = i }

    # Handle empty string
    return ''.b if encoded_str.empty?

    pad_count = 0
    if padding
      pad_count = encoded_str.count('=')
      if pad_count > 0
        encoded_str = encoded_str[0...-pad_count]
      end
    end

    result = []
    data_len = encoded_str.length
    i = 0

    while i < data_len
      chunk_end = [i + 4, data_len].min
      chunk = encoded_str[i...chunk_end]
      i += 4

      idx1 = reverse_map[chunk[0]]
      idx2 = chunk.length > 1 ? reverse_map[chunk[1]] : 0
      idx3 = chunk.length > 2 ? reverse_map[chunk[2]] : 0
      idx4 = chunk.length > 3 ? reverse_map[chunk[3]] : 0

      raise ArgumentError, "Invalid character in input" if idx1.nil? || (chunk.length > 1 && idx2.nil?)

      byte1 = (idx1 << 2) | (idx2 >> 4)
      result << byte1

      if chunk.length > 2
        byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2)
        result << byte2
      end

      if chunk.length > 3
        byte3 = ((idx3 & 0x03) << 6) | idx4
        result << byte3
      end
    end

    result.pack('C*')
  end
end
