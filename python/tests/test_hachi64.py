import unittest
from hachi64 import Hachi64

STANDARD_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
URL_SAFE_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

class TestHachi64(unittest.TestCase):

    def test_init(self):
        Hachi64(STANDARD_ALPHABET)
        with self.assertRaises(ValueError):
            Hachi64("short")
        with self.assertRaises(ValueError):
            Hachi64("a" * 64)

    def test_encode_standard(self):
        encoder = Hachi64(STANDARD_ALPHABET, padding=True)
        self.assertEqual(encoder.encode(b"Hello, World!"), "SGVsbG8sIFdvcmxkIQ==")
        self.assertEqual(encoder.encode(b"rust"), "cnVzdA==")
        self.assertEqual(encoder.encode(b"a"), "YQ==")
        self.assertEqual(encoder.encode(b"ab"), "YWI=")
        self.assertEqual(encoder.encode(b"abc"), "YWJj")

    def test_decode_standard(self):
        decoder = Hachi64(STANDARD_ALPHABET, padding=True)
        self.assertEqual(decoder.decode("SGVsbG8sIFdvcmxkIQ=="), b"Hello, World!")
        self.assertEqual(decoder.decode("cnVzdA=="), b"rust")
        self.assertEqual(decoder.decode("YQ=="), b"a")
        self.assertEqual(decoder.decode("YWI="), b"ab")
        self.assertEqual(decoder.decode("YWJj"), b"abc")

    def test_encode_url_safe(self):
        encoder = Hachi64(URL_SAFE_ALPHABET, padding=True)
        # 251, 239, 191 -> /+/ -> _-_ in URL safe
        self.assertEqual(encoder.encode(b'\xfb\xef\xbf'), "-_-_")

    def test_decode_url_safe(self):
        decoder = Hachi64(URL_SAFE_ALPHABET, padding=True)
        self.assertEqual(decoder.decode("-_-_"), b'\xfb\xef\xbf')

    def test_no_padding_encode(self):
        encoder = Hachi64(STANDARD_ALPHABET, padding=False)
        self.assertEqual(encoder.encode(b"a"), "YQ")
        self.assertEqual(encoder.encode(b"ab"), "YWI")
        self.assertEqual(encoder.encode(b"abc"), "YWJj")

    def test_no_padding_decode(self):
        decoder = Hachi64(STANDARD_ALPHABET, padding=False)
        self.assertEqual(decoder.decode("YQ"), b"a")
        self.assertEqual(decoder.decode("YWI"), b"ab")
        self.assertEqual(decoder.decode("YWJj"), b"abc")

    def test_decode_invalid_input(self):
        decoder = Hachi64(STANDARD_ALPHABET, padding=True)
        with self.assertRaises(ValueError):
            decoder.decode("SGVsbG8sIFdvcmxkIQ=") # Contains '=' in the middle
        with self.assertRaises(ValueError):
            decoder.decode("SGVsbG8.IFdvcmxkIQ==") # Contains '.'

if __name__ == '__main__':
    unittest.main()
