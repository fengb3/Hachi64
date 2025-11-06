#!/usr/bin/env node

/**
 * Hachi64 Node.js Example
 * 
 * This example demonstrates basic usage of Hachi64 in Node.js
 */

// Import the library
const { encode, decode, Hachi64, HACHI_ALPHABET } = require('./dist/index');

console.log('=== Hachi64 Node.js Example ===\n');

// Example 1: Basic encoding
console.log('Example 1: Basic Encoding');
const text1 = 'Hello, World!';
const encoded1 = encode(Buffer.from(text1));
console.log(`Original: ${text1}`);
console.log(`Encoded:  ${encoded1}`);
console.log();

// Example 2: Basic decoding
console.log('Example 2: Basic Decoding');
const encoded2 = '豆米啊拢嘎米多=';
const decoded2 = decode(encoded2);
console.log(`Encoded:  ${encoded2}`);
console.log(`Decoded:  ${Buffer.from(decoded2).toString('utf-8')}`);
console.log();

// Example 3: Round-trip encoding and decoding
console.log('Example 3: Round-trip');
const original = 'Hachi64 is awesome!';
const encoded = encode(Buffer.from(original));
const decoded = decode(encoded);
const result = Buffer.from(decoded).toString('utf-8');
console.log(`Original: ${original}`);
console.log(`Encoded:  ${encoded}`);
console.log(`Decoded:  ${result}`);
console.log(`Match:    ${original === result ? '✓' : '✗'}`);
console.log();

// Example 4: Without padding
console.log('Example 4: Without Padding');
const text4 = 'Hello';
const withPadding = encode(Buffer.from(text4), true);
const withoutPadding = encode(Buffer.from(text4), false);
console.log(`Text:            ${text4}`);
console.log(`With padding:    ${withPadding}`);
console.log(`Without padding: ${withoutPadding}`);
console.log();

// Example 5: Using class methods
console.log('Example 5: Using Class Methods');
const text5 = 'Python';
const encodedStatic = Hachi64.encode(Buffer.from(text5));
const decodedStatic = Hachi64.decode(encodedStatic);
console.log(`Original: ${text5}`);
console.log(`Encoded:  ${encodedStatic}`);
console.log(`Decoded:  ${Buffer.from(decodedStatic).toString('utf-8')}`);
console.log();

// Example 6: Binary data
console.log('Example 6: Binary Data');
const binaryData = Buffer.from([0, 1, 2, 255, 254, 253]);
const encodedBinary = encode(binaryData);
const decodedBinary = decode(encodedBinary);
console.log(`Original bytes: [${Array.from(binaryData).join(', ')}]`);
console.log(`Encoded:        ${encodedBinary}`);
console.log(`Decoded bytes:  [${Array.from(decodedBinary).join(', ')}]`);
console.log(`Match:          ${Buffer.from(decodedBinary).equals(binaryData) ? '✓' : '✗'}`);
console.log();

// Example 7: Alphabet info
console.log('Example 7: Alphabet Information');
console.log(`Alphabet: ${HACHI_ALPHABET}`);
console.log(`Length:   ${HACHI_ALPHABET.length} characters`);
console.log(`Unique:   ${new Set(HACHI_ALPHABET).size} unique characters`);
