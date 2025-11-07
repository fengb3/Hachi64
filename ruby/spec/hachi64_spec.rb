# frozen_string_literal: true

require_relative '../lib/hachi64'

RSpec.describe Hachi64 do
  describe '.encode and .decode' do
    it 'encodes and decodes consistently' do
      test_cases = [
        'Hello, World!',
        'rust',
        'a',
        'ab',
        'abc',
        'Python',
        'Hachi64',
        '', # empty string
        'The quick brown fox jumps over the lazy dog'
      ]

      test_cases.each do |test_data|
        encoded = Hachi64.encode(test_data)
        decoded = Hachi64.decode(encoded)
        expect(decoded).to eq(test_data), "Failed for: #{test_data}"
      end
    end

    it 'encodes to specific expected results' do
      test_cases = {
        'Hello' => '豆米啊拢嘎米多=',
        'abc' => '西阿南呀',
        'a' => '西律==',
        'ab' => '西阿迷='
      }

      test_cases.each do |input, expected|
        encoded = Hachi64.encode(input)
        expect(encoded).to eq(expected), "Failed for: #{input}"
      end
    end

    it 'handles binary data correctly' do
      # Test all byte values 0-255
      test_data = (0..255).to_a.pack('C*')
      encoded = Hachi64.encode(test_data)
      decoded = Hachi64.decode(encoded)
      expect(decoded).to eq(test_data)
    end

    it 'encodes and decodes without padding' do
      test_cases = ['a', 'ab', 'abc', 'Hello']

      test_cases.each do |test_data|
        encoded_no_pad = Hachi64.encode(test_data, padding: false)
        decoded = Hachi64.decode(encoded_no_pad, padding: false)
        expect(decoded).to eq(test_data)
      end
    end

    it 'handles padding behavior correctly' do
      test_data = 'a'

      encoded_with_padding = Hachi64.encode(test_data, padding: true)
      encoded_without_padding = Hachi64.encode(test_data, padding: false)

      # With padding should end with ==
      expect(encoded_with_padding).to end_with('==')

      # Without padding should not contain =
      expect(encoded_without_padding).not_to include('=')

      # Both should decode correctly
      decoded_with_padding = Hachi64.decode(encoded_with_padding, padding: true)
      decoded_without_padding = Hachi64.decode(encoded_without_padding, padding: false)

      expect(decoded_with_padding).to eq(test_data)
      expect(decoded_without_padding).to eq(test_data)
    end

    it 'raises error for invalid characters' do
      expect { Hachi64.decode('包含无效字符X的字符串') }.to raise_error(ArgumentError)
    end

    it 'decodes empty string to empty bytes' do
      result = Hachi64.decode('')
      expect(result).to eq(''.b)
    end
  end

  describe 'HACHI_ALPHABET' do
    it 'has exactly 64 characters' do
      expect(Hachi64::HACHI_ALPHABET.length).to eq(64)
    end

    it 'has 64 unique characters' do
      expect(Hachi64::HACHI_ALPHABET.chars.uniq.length).to eq(64)
    end

    it 'encodes and decodes long data correctly' do
      # Test with longer data to ensure all characters can be used
      long_data = (0..255).to_a.pack('C*') * 3
      encoded = Hachi64.encode(long_data)
      decoded = Hachi64.decode(encoded)
      expect(decoded).to eq(long_data)
    end
  end

  describe 'compatibility with other implementations' do
    it 'matches Python implementation examples' do
      test_cases = {
        'Hello' => '豆米啊拢嘎米多=',
        'abc' => '西阿南呀',
        'Python' => '抖咪酷丁息米都慢',
        'Hello, World!' => '豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==',
        'Base64' => '律苦集叮希斗西丁',
        'Hachi64' => '豆米集呀息米库咚背哈=='
      }

      test_cases.each do |input, expected|
        encoded = Hachi64.encode(input)
        expect(encoded).to eq(expected), "Failed for: #{input}"
        
        decoded = Hachi64.decode(expected)
        expect(decoded).to eq(input), "Failed decoding: #{expected}"
      end
    end
  end
end
