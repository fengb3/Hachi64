/**
 * Hachi64: 哈吉米64 Encoding and Decoding
 * 
 * A custom Base64 encoder/decoder using 64 Chinese characters
 */

/**
 * The Hachi64 alphabet: 64 Chinese characters grouped by similar pronunciation
 */
export const HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";

/**
 * Cached reverse mapping for efficient decoding
 */
let cachedReverseMap: Map<string, number> | null = null;

/**
 * Get or create the reverse mapping
 */
function getReverseMap(): Map<string, number> {
  if (!cachedReverseMap) {
    cachedReverseMap = new Map();
    for (let i = 0; i < HACHI_ALPHABET.length; i++) {
      cachedReverseMap.set(HACHI_ALPHABET[i], i);
    }
  }
  return cachedReverseMap;
}

/**
 * Hachi64 encoder/decoder class
 */
export class Hachi64 {
  private readonly alphabet: string;
  private readonly reverseMap: Map<string, number>;

  constructor() {
    this.alphabet = HACHI_ALPHABET;
    this.reverseMap = getReverseMap();
  }

  /**
   * Encodes a byte array into a Hachi64 string
   * 
   * @param data - The data to encode (Buffer in Node.js, Uint8Array in browser)
   * @param padding - Whether to use '=' for padding (default: true)
   * @returns The encoded string
   */
  static encode(data: Uint8Array | Buffer, padding: boolean = true): string {
    const alphabet = HACHI_ALPHABET;
    const result: string[] = [];
    const dataLen = data.length;
    let i = 0;

    while (i < dataLen) {
      // Calculate chunk length first (how many bytes we have remaining)
      const remaining = dataLen - i;
      const chunkLen = Math.min(3, remaining);
      
      // Get up to 3 bytes
      const byte1 = data[i];
      const byte2 = chunkLen > 1 ? data[i + 1] : 0;
      const byte3 = chunkLen > 2 ? data[i + 2] : 0;
      
      i += chunkLen;
      
      // Split 24 bits into 4 groups of 6 bits
      const idx1 = byte1 >> 2;
      const idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
      const idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
      const idx4 = byte3 & 0x3F;

      // Add first two characters (always present)
      result.push(alphabet[idx1]);
      result.push(alphabet[idx2]);

      // Add third character or padding
      if (chunkLen > 1) {
        result.push(alphabet[idx3]);
      } else if (padding) {
        result.push('=');
      }

      // Add fourth character or padding
      if (chunkLen > 2) {
        result.push(alphabet[idx4]);
      } else if (padding) {
        result.push('=');
      }
    }

    return result.join('');
  }

  /**
   * Decodes a Hachi64 string into bytes
   * 
   * @param encodedStr - The string to decode
   * @param padding - Whether the input uses '=' for padding (default: true)
   * @returns The decoded bytes as Uint8Array
   * @throws Error if the input contains invalid characters
   */
  static decode(encodedStr: string, padding: boolean = true): Uint8Array {
    const reverseMap = getReverseMap();

    // Handle empty string
    if (!encodedStr) {
      return new Uint8Array(0);
    }

    // Handle padding
    let padCount = 0;
    if (padding) {
      for (let i = encodedStr.length - 1; i >= 0 && encodedStr[i] === '='; i--) {
        padCount++;
      }
      if (padCount > 0) {
        encodedStr = encodedStr.slice(0, -padCount);
      }
    }

    const result: number[] = [];
    const dataLen = encodedStr.length;
    let i = 0;

    while (i < dataLen) {
      // Get up to 4 characters
      const chars = encodedStr.slice(i, i + 4);
      i += 4;

      // Get indices from reverse map
      const idx1 = reverseMap.get(chars[0]);
      const idx2 = chars.length > 1 ? reverseMap.get(chars[1]) : 0;
      const idx3 = chars.length > 2 ? reverseMap.get(chars[2]) : 0;
      const idx4 = chars.length > 3 ? reverseMap.get(chars[3]) : 0;

      if (idx1 === undefined || (chars.length > 1 && idx2 === undefined) ||
          (chars.length > 2 && idx3 === undefined) || (chars.length > 3 && idx4 === undefined)) {
        throw new Error(`Invalid character in input`);
      }

      // Reconstruct bytes from 6-bit indices
      const byte1 = (idx1 << 2) | ((idx2 ?? 0) >> 4);
      result.push(byte1);

      if (chars.length > 2) {
        const byte2 = (((idx2 ?? 0) & 0x0F) << 4) | ((idx3 ?? 0) >> 2);
        result.push(byte2);
      }

      if (chars.length > 3) {
        const byte3 = (((idx3 ?? 0) & 0x03) << 6) | (idx4 ?? 0);
        result.push(byte3);
      }
    }

    return new Uint8Array(result);
  }

  /**
   * Instance method for encoding
   */
  encode(data: Uint8Array | Buffer, padding: boolean = true): string {
    return Hachi64.encode(data, padding);
  }

  /**
   * Instance method for decoding
   */
  decode(encodedStr: string, padding: boolean = true): Uint8Array {
    return Hachi64.decode(encodedStr, padding);
  }
}

/**
 * Default instance for convenience
 */
export const hachi64 = new Hachi64();

/**
 * Convenience function for encoding with default settings
 */
export function encode(data: Uint8Array | Buffer, padding: boolean = true): string {
  return Hachi64.encode(data, padding);
}

/**
 * Convenience function for decoding with default settings
 */
export function decode(encodedStr: string, padding: boolean = true): Uint8Array {
  return Hachi64.decode(encodedStr, padding);
}
