# Implementation Notes for JavaScript/TypeScript

## Overview
This document provides technical details about the JavaScript/TypeScript implementation of Hachi64.

## Architecture

### Core Components

1. **index.ts** - Main implementation file
   - `HACHI_ALPHABET` constant - The 64-character Chinese alphabet
   - `Hachi64` class - Main encoder/decoder class
   - `encode()` / `decode()` - Convenience functions
   - `hachi64` - Default instance for convenience

2. **Optimization Strategy**
   - Reverse map is cached globally for performance
   - Static methods use the same cache as instance methods
   - No need to rebuild the reverse map on every decode operation

3. **Type Safety**
   - Full TypeScript type definitions
   - Support for both `Buffer` (Node.js) and `Uint8Array` (browser)
   - Strict type checking enabled

## Algorithm Implementation

### Encoding Process
1. Process input in 3-byte chunks
2. Convert each chunk to 4 6-bit indices
3. Map each index to a character in HACHI_ALPHABET
4. Add padding ('=') if needed

### Decoding Process
1. Remove padding if present
2. Process input in 4-character chunks
3. Convert each character to 6-bit index via reverse map
4. Reconstruct original bytes from indices

## Testing

### Test Coverage
- 46 comprehensive unit tests
- All tests passing
- Test categories:
  - Encode/decode consistency (9 tests)
  - Class methods (3 tests)
  - Specific encodings (16 tests)
  - Binary data (1 test)
  - Padding behavior (4 tests)
  - Edge cases (3 tests)
  - Invalid input (3 tests)
  - Alphabet properties (3 tests)
  - Convenience functions (2 tests)
  - Roundtrip tests (2 tests)

### Test Framework
- Jest 29.5.0
- ts-jest for TypeScript support
- Node.js test environment

## Browser Compatibility

### Module System
- Uses ES modules (import/export)
- CommonJS output for Node.js compatibility
- TypeScript target: ES2015

### Browser Requirements
- ES2015 (ES6) support required
- TextEncoder/TextDecoder for string conversion
- Modern browsers (Chrome 51+, Firefox 54+, Safari 10.1+, Edge 79+)

## Node.js Compatibility

### Requirements
- Node.js 12.x or higher
- Buffer support (built-in)

### Usage Patterns
1. Static methods: `Hachi64.encode()` / `Hachi64.decode()`
2. Instance methods: `hachi64.encode()` / `hachi64.decode()`
3. Convenience functions: `encode()` / `decode()`

## Performance Considerations

1. **Memory Efficiency**
   - Single global reverse map (lazy-loaded)
   - Efficient string building with arrays
   - Minimal allocations

2. **CPU Efficiency**
   - Bitwise operations for encoding/decoding
   - No regular expressions
   - Direct character access

## Security

- No runtime dependencies (production)
- No known vulnerabilities in dev dependencies
- Input validation for decode operations
- Type-safe operations throughout

## Build Process

1. **TypeScript Compilation**
   - Input: `src/index.ts`
   - Output: `dist/index.js` + `dist/index.d.ts`
   - Target: ES2015, CommonJS modules

2. **No Bundling**
   - Direct TypeScript output
   - No webpack/rollup required
   - Simple and transparent

## Comparison with Other Implementations

### Python Implementation
- Similar class-based structure
- Static methods match
- Same test cases and expected outputs

### Rust Implementation
- Similar algorithm
- Performance optimized with lazy statics
- Same test cases and expected outputs

### C# Implementation
- Different language paradigm
- Same encoding/decoding logic
- Compatible outputs

## Future Enhancements

Possible improvements (not implemented):
1. WebAssembly version for better performance
2. Streaming API for large data
3. CLI tool for command-line usage
4. Browser extension
5. React/Vue component wrappers
