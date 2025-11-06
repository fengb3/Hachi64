import { Hachi64, hachi64, HACHI_ALPHABET, encode, decode } from '../src/index';

describe('Hachi64', () => {
  describe('encode/decode consistency', () => {
    const testCases = [
      'Hello, World!',
      'rust',
      'a',
      'ab',
      'abc',
      'Python',
      'Hachi64',
      '',  // empty string
      'The quick brown fox jumps over the lazy dog'
    ];

    testCases.forEach(testStr => {
      it(`should encode and decode "${testStr}" consistently`, () => {
        const testData = Buffer.from(testStr, 'utf-8');
        const encoded = hachi64.encode(testData);
        const decoded = hachi64.decode(encoded);
        expect(Buffer.from(decoded).toString('utf-8')).toBe(testStr);
      });
    });
  });

  describe('class methods', () => {
    it('should work with static methods', () => {
      const testData = Buffer.from('Hello, World!', 'utf-8');
      const encodedStatic = Hachi64.encode(testData);
      const decodedStatic = Hachi64.decode(encodedStatic);
      expect(Buffer.from(decodedStatic).toString('utf-8')).toBe('Hello, World!');
    });

    it('should work with instance methods', () => {
      const testData = Buffer.from('Hello, World!', 'utf-8');
      const encodedInstance = hachi64.encode(testData);
      const decodedInstance = hachi64.decode(encodedInstance);
      expect(Buffer.from(decodedInstance).toString('utf-8')).toBe('Hello, World!');
    });

    it('should produce same results for static and instance methods', () => {
      const testData = Buffer.from('Hello, World!', 'utf-8');
      const encodedStatic = Hachi64.encode(testData);
      const encodedInstance = hachi64.encode(testData);
      expect(encodedStatic).toBe(encodedInstance);
    });
  });

  describe('specific encodings', () => {
    const testCases: [string, string][] = [
      ['Hello', '豆米啊拢嘎米多='],
      ['abc', '西阿南呀'],
      ['Python', '抖咪酷丁息米都慢'],
      ['Hello, World!', '豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=='],
      ['Base64', '律苦集叮希斗西丁'],
      ['Hachi64', '豆米集呀息米库咚背哈=='],
      ['a', '西律=='],
      ['ab', '西阿迷=']
    ];

    testCases.forEach(([input, expected]) => {
      it(`should encode "${input}" to "${expected}"`, () => {
        const testData = Buffer.from(input, 'utf-8');
        const encoded = hachi64.encode(testData);
        expect(encoded).toBe(expected);
      });

      it(`should decode "${expected}" to "${input}"`, () => {
        const decoded = hachi64.decode(expected);
        expect(Buffer.from(decoded).toString('utf-8')).toBe(input);
      });
    });
  });

  describe('binary data', () => {
    it('should handle binary data correctly', () => {
      const testData = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        testData[i] = i;
      }
      const encoded = hachi64.encode(testData);
      const decoded = hachi64.decode(encoded);
      expect(decoded).toEqual(testData);
    });
  });

  describe('padding behavior', () => {
    it('should use padding by default', () => {
      const testData = Buffer.from('a', 'utf-8');
      const encoded = hachi64.encode(testData, true);
      expect(encoded.endsWith('==')).toBe(true);
    });

    it('should not use padding when disabled', () => {
      const testData = Buffer.from('a', 'utf-8');
      const encoded = hachi64.encode(testData, false);
      expect(encoded.includes('=')).toBe(false);
    });

    it('should decode with padding', () => {
      const testData = Buffer.from('a', 'utf-8');
      const encodedWithPadding = hachi64.encode(testData, true);
      const decoded = hachi64.decode(encodedWithPadding, true);
      expect(Buffer.from(decoded).toString('utf-8')).toBe('a');
    });

    it('should decode without padding', () => {
      const testData = Buffer.from('a', 'utf-8');
      const encodedWithoutPadding = hachi64.encode(testData, false);
      const decoded = hachi64.decode(encodedWithoutPadding, false);
      expect(Buffer.from(decoded).toString('utf-8')).toBe('a');
    });
  });

  describe('edge cases', () => {
    it('should handle empty string', () => {
      const testData = Buffer.from('', 'utf-8');
      const encoded = hachi64.encode(testData);
      expect(encoded).toBe('');
      const decoded = hachi64.decode(encoded);
      expect(decoded).toEqual(new Uint8Array(0));
    });

    it('should handle single byte', () => {
      const testData = Buffer.from('a', 'utf-8');
      const encoded = hachi64.encode(testData);
      const decoded = hachi64.decode(encoded);
      expect(Buffer.from(decoded).toString('utf-8')).toBe('a');
    });

    it('should handle two bytes', () => {
      const testData = Buffer.from('ab', 'utf-8');
      const encoded = hachi64.encode(testData);
      const decoded = hachi64.decode(encoded);
      expect(Buffer.from(decoded).toString('utf-8')).toBe('ab');
    });
  });

  describe('invalid input', () => {
    it('should throw error on invalid characters', () => {
      expect(() => hachi64.decode('包含无效字符X的字符串')).toThrow('Invalid character in input');
    });

    it('should handle empty string decode', () => {
      const result = hachi64.decode('');
      expect(result).toEqual(new Uint8Array(0));
    });
  });

  describe('alphabet properties', () => {
    it('should have 64 characters', () => {
      expect(HACHI_ALPHABET.length).toBe(64);
    });

    it('should have unique characters', () => {
      const uniqueChars = new Set(HACHI_ALPHABET);
      expect(uniqueChars.size).toBe(64);
    });

    it('should handle long data with all characters potentially used', () => {
      const longData = new Uint8Array(256 * 3);
      for (let i = 0; i < longData.length; i++) {
        longData[i] = i % 256;
      }
      const encoded = hachi64.encode(longData);
      const decoded = hachi64.decode(encoded);
      expect(decoded).toEqual(longData);
    });
  });

  describe('convenience functions', () => {
    it('should work with encode function', () => {
      const testData = Buffer.from('Hello', 'utf-8');
      const encoded = encode(testData);
      expect(encoded).toBe('豆米啊拢嘎米多=');
    });

    it('should work with decode function', () => {
      const decoded = decode('豆米啊拢嘎米多=');
      expect(Buffer.from(decoded).toString('utf-8')).toBe('Hello');
    });
  });

  describe('roundtrip tests', () => {
    it('should roundtrip ASCII text', () => {
      const testData = Buffer.from('The quick brown fox jumps over the lazy dog', 'utf-8');
      const encoded = encode(testData);
      const decoded = decode(encoded);
      expect(Buffer.from(decoded)).toEqual(testData);
    });

    it('should roundtrip binary data', () => {
      const binaryData = new Uint8Array([0, 1, 2, 3, 255, 254, 253, 127, 128]);
      const encoded = encode(binaryData);
      const decoded = decode(encoded);
      expect(decoded).toEqual(binaryData);
    });
  });
});
