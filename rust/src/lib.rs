//! # Hachi64
//!
//! A library for performing Base64 encoding and decoding using a custom,
//! user-defined 64-character alphabet.

use std::collections::HashMap;

/// A custom Base64 encoder/decoder.
#[derive(Debug, Clone)]
pub struct Hachi64 {
    alphabet: [u8; 64],
    reverse_map: HashMap<u8, u8>,
    padding: bool,
}

/// Represents errors that can occur during encoding or decoding.
#[derive(Debug, PartialEq, Eq)]
pub enum HachiError {
    /// The provided alphabet is not 64 characters long.
    InvalidAlphabetLength,
    /// The provided alphabet contains duplicate characters.
    InvalidAlphabetChars,
    /// The input string for decoding is invalid (e.g., contains characters not in the alphabet).
    InvalidInput,
}

impl Hachi64 {
    /// Creates a new `Hachi64` instance with a custom alphabet.
    ///
    /// # Arguments
    ///
    /// * `alphabet_str` - A string containing 64 unique ASCII characters.
    /// * `padding` - Whether to use padding (`=`) or not.
    ///
    /// # Errors
    ///
    /// Returns an error if the alphabet is not 64 characters long or contains non-unique characters.
    pub fn new(alphabet_str: &str, padding: bool) -> Result<Self, HachiError> {
        if alphabet_str.len() != 64 {
            return Err(HachiError::InvalidAlphabetLength);
        }

        let alphabet_bytes = alphabet_str.as_bytes();
        let mut alphabet = [0u8; 64];
        alphabet.copy_from_slice(alphabet_bytes);

        let mut reverse_map = HashMap::with_capacity(64);
        for (i, &byte) in alphabet.iter().enumerate() {
            if reverse_map.insert(byte, i as u8).is_some() {
                return Err(HachiError::InvalidAlphabetChars);
            }
        }

        Ok(Hachi64 {
            alphabet,
            reverse_map,
            padding,
        })
    }

    /// Encodes a byte slice into a custom Base64 string.
    pub fn encode(&self, data: &[u8]) -> String {
        let mut result = String::with_capacity((data.len() / 3 + 1) * 4);

        for chunk in data.chunks(3) {
            let byte1 = chunk[0];
            let byte2 = chunk.get(1).copied().unwrap_or(0);
            let byte3 = chunk.get(2).copied().unwrap_or(0);

            let idx1 = byte1 >> 2;
            let idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
            let idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
            let idx4 = byte3 & 0x3F;

            result.push(self.alphabet[idx1 as usize] as char);
            result.push(self.alphabet[idx2 as usize] as char);

            if chunk.len() > 1 {
                result.push(self.alphabet[idx3 as usize] as char);
            } else if self.padding {
                result.push('=');
            }

            if chunk.len() > 2 {
                result.push(self.alphabet[idx4 as usize] as char);
            } else if chunk.len() > 1 && self.padding {
                result.push('=');
            }
        }
        result
    }

    /// Decodes a custom Base64 string into a byte vector.
    pub fn decode(&self, encoded_str: &str) -> Result<Vec<u8>, HachiError> {
        let s = if self.padding {
            encoded_str.trim_end_matches('=')
        } else {
            encoded_str
        };
        
        let pad_count = if self.padding { encoded_str.len() - s.len() } else { 0 };

        let mut result = Vec::with_capacity((s.len() * 3) / 4);

        for chunk in s.as_bytes().chunks(4) {
            let idx1 = *self.reverse_map.get(&chunk[0]).ok_or(HachiError::InvalidInput)?;
            let idx2 = *self.reverse_map.get(&chunk[1]).ok_or(HachiError::InvalidInput)?;
            let idx3 = if chunk.len() > 2 { *self.reverse_map.get(&chunk[2]).ok_or(HachiError::InvalidInput)? } else { 0 };
            let idx4 = if chunk.len() > 3 { *self.reverse_map.get(&chunk[3]).ok_or(HachiError::InvalidInput)? } else { 0 };

            let byte1 = (idx1 << 2) | (idx2 >> 4);
            let byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2);
            let byte3 = ((idx3 & 0x03) << 6) | idx4;

            result.push(byte1);
            if chunk.len() > 2 {
                result.push(byte2);
            }
            if chunk.len() > 3 {
                result.push(byte3);
            }
        }

        if self.padding {
            let final_len = result.len() - pad_count;
            result.truncate(final_len);
        }

        Ok(result)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const STANDARD_ALPHABET: &str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const URL_SAFE_ALPHABET: &str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

    #[test]
    fn test_new_hachi64() {
        assert!(Hachi64::new(STANDARD_ALPHABET, true).is_ok());
        assert_eq!(Hachi64::new("short", true), Err(HachiError::InvalidAlphabetLength));
        assert_eq!(Hachi64::new("abcabc...", true), Err(HachiError::InvalidAlphabetChars));
    }

    #[test]
    fn test_encode_standard() {
        let encoder = Hachi64::new(STANDARD_ALPHABET, true).unwrap();
        assert_eq!(encoder.encode(b"Hello, World!"), "SGVsbG8sIFdvcmxkIQ==");
        assert_eq!(encoder.encode(b"rust"), "cnVzdA==");
        assert_eq!(encoder.encode(b"a"), "YQ==");
        assert_eq!(encoder.encode(b"ab"), "YWI=");
        assert_eq!(encoder.encode(b"abc"), "YWJj");
    }

    #[test]
    fn test_decode_standard() {
        let decoder = Hachi64::new(STANDARD_ALPHABET, true).unwrap();
        assert_eq!(decoder.decode("SGVsbG8sIFdvcmxkIQ==").unwrap(), b"Hello, World!");
        assert_eq!(decoder.decode("cnVzdA==").unwrap(), b"rust");
        assert_eq!(decoder.decode("YQ==").unwrap(), b"a");
        assert_eq!(decoder.decode("YWI=").unwrap(), b"ab");
        assert_eq!(decoder.decode("YWJj").unwrap(), b"abc");
    }

    #[test]
    fn test_encode_url_safe() {
        let encoder = Hachi64::new(URL_SAFE_ALPHABET, true).unwrap();
        // 251, 239, 191 -> /+/ -> _-_
        assert_eq!(encoder.encode(&[251, 239, 191]), "-_-_");
    }

    #[test]
    fn test_decode_url_safe() {
        let decoder = Hachi64::new(URL_SAFE_ALPHABET, true).unwrap();
        assert_eq!(decoder.decode("-_-_").unwrap(), &[251, 239, 191]);
    }
    
    #[test]
    fn test_no_padding_encode() {
        let encoder = Hachi64::new(STANDARD_ALPHABET, false).unwrap();
        assert_eq!(encoder.encode(b"a"), "YQ");
        assert_eq!(encoder.encode(b"ab"), "YWI");
        assert_eq!(encoder.encode(b"abc"), "YWJj");
    }

    #[test]
    fn test_no_padding_decode() {
        let decoder = Hachi64::new(STANDARD_ALPHABET, false).unwrap();
        assert_eq!(decoder.decode("YQ").unwrap(), b"a");
        assert_eq!(decoder.decode("YWI").unwrap(), b"ab");
        assert_eq!(decoder.decode("YWJj").unwrap(), b"abc");
    }

    #[test]
    fn test_decode_invalid_input() {
        let decoder = Hachi64::new(STANDARD_ALPHABET, true).unwrap();
        assert_eq!(decoder.decode("SGVsbG8sIFdvcmxkIQ="), Err(HachiError::InvalidInput)); // Contains '=' in the middle
        assert_eq!(decoder.decode("SGVsbG8.IFdvcmxkIQ=="), Err(HachiError::InvalidInput)); // Contains '.'
    }
}
