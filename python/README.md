# Hachi64 for Python

This is the Python implementation of the Hachi64 custom Base64 encoder/decoder.

## Installation

```bash
pip install .
```

## Usage

```python
from hachi64 import Hachi64

# Define your custom alphabet (must be 64 unique characters)
my_alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_"
encoder = Hachi64(my_alphabet)

# Encode data
original_data = b"Hello, World!"
encoded_string = encoder.encode(original_data)
print(f"Encoded: {encoded_string}")

# Decode data
decoded_data = encoder.decode(encoded_string)
print(f"Decoded: {decoded_data.decode('utf-8')}")
```
