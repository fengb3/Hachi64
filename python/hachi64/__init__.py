"""
Hachi64: Custom Base64 Encoding and Decoding
"""

class Hachi64:
    """
    A custom Base64 encoder/decoder.
    """

    def __init__(self, alphabet: str, padding: bool = True):
        """
        Initializes the Hachi64 encoder/decoder with a custom alphabet.

        :param alphabet: A string of 64 unique characters.
        :param padding: Whether to use '=' for padding.
        :raises ValueError: If the alphabet is not 64 unique characters.
        """
        if len(alphabet) != 64:
            raise ValueError("Alphabet must be 64 characters long.")
        
        if len(set(alphabet)) != 64:
            raise ValueError("Alphabet must contain 64 unique characters.")

        self.alphabet = alphabet
        self.padding = padding
        self._reverse_map = {char: i for i, char in enumerate(alphabet)}

    def encode(self, data: bytes) -> str:
        """
        Encodes a byte string into a custom Base64 string.

        :param data: The bytes to encode.
        :return: The encoded string.
        """
        result = []
        data_len = len(data)
        i = 0

        while i < data_len:
            chunk = data[i:i+3]
            i += 3

            byte1 = chunk[0]
            byte2 = chunk[1] if len(chunk) > 1 else 0
            byte3 = chunk[2] if len(chunk) > 2 else 0

            idx1 = byte1 >> 2
            idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4)
            idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6)
            idx4 = byte3 & 0x3F

            result.append(self.alphabet[idx1])
            result.append(self.alphabet[idx2])

            if len(chunk) > 1:
                result.append(self.alphabet[idx3])
            elif self.padding:
                result.append('=')

            if len(chunk) > 2:
                result.append(self.alphabet[idx4])
            elif self.padding:
                result.append('=')
        
        return "".join(result)

    def decode(self, encoded_str: str) -> bytes:
        """
        Decodes a custom Base64 string into bytes.

        :param encoded_str: The string to decode.
        :return: The decoded bytes.
        :raises ValueError: If the input string is invalid.
        """
        pad_count = 0
        if self.padding:
            pad_count = encoded_str.count('=')
            if pad_count > 0:
                encoded_str = encoded_str[:-pad_count]

        result = bytearray()
        data_len = len(encoded_str)
        i = 0

        while i < data_len:
            chunk = encoded_str[i:i+4]
            i += 4

            try:
                idx1 = self._reverse_map[chunk[0]]
                idx2 = self._reverse_map[chunk[1]]
                idx3 = self._reverse_map[chunk[2]] if len(chunk) > 2 else 0
                idx4 = self._reverse_map[chunk[3]] if len(chunk) > 3 else 0
            except KeyError as e:
                raise ValueError(f"Invalid character in input: {e}") from e

            byte1 = (idx1 << 2) | (idx2 >> 4)
            byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2)
            byte3 = ((idx3 & 0x03) << 6) | idx4

            result.append(byte1)
            if len(chunk) > 2:
                result.append(byte2)
            if len(chunk) > 3:
                result.append(byte3)

        if self.padding and pad_count > 0:
            return bytes(result[:-pad_count])
            
        return bytes(result)
