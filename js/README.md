# Hachi64 for JavaScript/TypeScript

This is the JavaScript/TypeScript implementation of the Hachi64 custom Base64 encoder/decoder.

## Features

- Uses the fixed Hachi64 character set (64 Chinese characters)
- Supports both padded and unpadded encoding modes
- Compatible with both Node.js and browser environments
- Written in TypeScript with full type definitions
- Zero dependencies (dev dependencies for testing only)
- Fully compliant with Base64 encoding standards

## Installation

### From npm (Recommended - Once Published)

**Status:** 📦 Package name `hachi64` is available on npm but not yet published.

**To publish:** Repository maintainer needs to configure `NPM_TOKEN` in GitHub Secrets. See [NPM_SETUP.md](./NPM_SETUP.md) for instructions.

Once published, install with:

```bash
npm install hachi64
```

### Temporary: Install from source

Until the package is published to npm, you can install from source:

```bash
cd js
npm install
npm run build
```

Then copy the built files to your project, or use it directly from the repository.

## Quick Start

### Basic Usage (Node.js)

```typescript
import { encode, decode, hachi64, Hachi64 } from 'hachi64';

// Method 1: Using convenience functions (recommended)
const encoded = encode(Buffer.from('Hello'));
console.log('Encoded:', encoded);  // 豆米啊拢嘎米多=

const decoded = decode(encoded);
console.log('Decoded:', Buffer.from(decoded).toString('utf-8'));  // Hello

// Method 2: Using instance methods
const encoded2 = hachi64.encode(Buffer.from('Hello'));
const decoded2 = hachi64.decode(encoded2);

// Method 3: Using static methods
const encoded3 = Hachi64.encode(Buffer.from('Hello'));
const decoded3 = Hachi64.decode(encoded3);
```

### Browser Usage

```html
<script type="module">
  import { encode, decode } from './dist/index.js';

  // Encode string to Hachi64
  const text = 'Hello, World!';
  const data = new TextEncoder().encode(text);
  const encoded = encode(data);
  console.log('Encoded:', encoded);

  // Decode back to string
  const decoded = decode(encoded);
  const result = new TextDecoder().decode(decoded);
  console.log('Decoded:', result);
</script>
```

### Without Padding

```typescript
import { encode, decode } from 'hachi64';

const data = Buffer.from('Hello');
const encoded = encode(data, false);  // No padding
console.log(encoded);  // 豆米啊拢嘎米多

const decoded = decode(encoded, false);
console.log(Buffer.from(decoded).toString('utf-8'));  // Hello
```

## Encoding Examples

Based on the examples from the main README:

| Original Data | Encoded Result |
|--------------|----------------|
| `"Hello"` | `豆米啊拢嘎米多=` |
| `"abc"` | `西阿南呀` |
| `"Python"` | `抖咪酷丁息米都慢` |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `"Base64"` | `律苦集叮希斗西丁` |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` |

## API Documentation

### Functions

#### `encode(data: Uint8Array | Buffer, padding?: boolean): string`

Encodes a byte array into a Hachi64 string.

- **Parameters:**
  - `data`: The data to encode (Buffer in Node.js, Uint8Array in browser)
  - `padding`: Whether to use '=' for padding (default: `true`)
- **Returns:** The encoded string

#### `decode(encodedStr: string, padding?: boolean): Uint8Array`

Decodes a Hachi64 string into bytes.

- **Parameters:**
  - `encodedStr`: The string to decode
  - `padding`: Whether the input uses '=' for padding (default: `true`)
- **Returns:** The decoded bytes as Uint8Array
- **Throws:** Error if the input contains invalid characters

### Class: Hachi64

The main encoder/decoder class.

**Static Methods:**

- `Hachi64.encode(data: Uint8Array | Buffer, padding?: boolean): string` - Static encoding method
- `Hachi64.decode(encodedStr: string, padding?: boolean): Uint8Array` - Static decoding method

**Instance Methods:**

- `encode(data: Uint8Array | Buffer, padding?: boolean): string` - Instance encoding method
- `decode(encodedStr: string, padding?: boolean): Uint8Array` - Instance decoding method

### Constants

#### `HACHI_ALPHABET`

The 64-character Chinese alphabet used for encoding:
```
哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济
```

#### `hachi64`

A default instance of the Hachi64 class for convenience.

## Examples

### Node.js Example

Run the Node.js example to see various usage patterns:

```bash
node example-node.js
```

### Browser Example

Open `example-browser.html` in a web browser to try encoding and decoding interactively. You'll need to build the project first:

```bash
npm run build
```

Then open the file in a browser (using a local server if needed to avoid CORS issues with ES modules).

## Development

### Setup

```bash
npm install
```

### Build

```bash
npm run build
```

### Run Tests

```bash
npm test
```

### Watch Tests

```bash
npm run test:watch
```

## Browser Compatibility

This library is compatible with modern browsers that support ES2015 (ES6). For older browsers, you may need to transpile the code using Babel or similar tools.

## Node.js Compatibility

Requires Node.js 12.x or higher.

## License

MIT
