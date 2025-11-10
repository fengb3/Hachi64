<?php
/**
 * Example usage of Hachi64 PHP implementation
 */

require_once __DIR__ . '/src/Hachi64.php';

use Hachi64\Hachi64;

echo "=== Hachi64 PHP Implementation Example ===\n\n";

// Example 1: Basic encoding and decoding
echo "Example 1: Basic encoding and decoding\n";
echo "---------------------------------------\n";
$data = "Hello, World!";
echo "Original: {$data}\n";
$encoded = Hachi64::encode($data);
echo "Encoded:  {$encoded}\n";
$decoded = Hachi64::decode($encoded);
echo "Decoded:  {$decoded}\n";
echo "\n";

// Example 2: Different text examples
echo "Example 2: Different text examples\n";
echo "-----------------------------------\n";
$examples = [
    "Hello" => "豆米啊拢嘎米多=",
    "Python" => "抖咪酷丁息米都慢",
    "Hachi64" => "豆米集呀息米库咚背哈=="
];

foreach ($examples as $original => $expected) {
    $encoded = Hachi64::encode($original);
    $match = ($encoded === $expected) ? "✓" : "✗";
    echo "{$match} '{$original}' -> {$encoded}\n";
}
echo "\n";

// Example 3: Encoding without padding
echo "Example 3: Encoding without padding\n";
echo "------------------------------------\n";
$data = "abc";
$withPadding = Hachi64::encode($data, true);
$withoutPadding = Hachi64::encode($data, false);
echo "With padding:    {$withPadding}\n";
echo "Without padding: {$withoutPadding}\n";
echo "\n";

// Example 4: Binary data
echo "Example 4: Binary data\n";
echo "----------------------\n";
$binaryData = chr(0x48) . chr(0x65) . chr(0x6C) . chr(0x6C) . chr(0x6F); // "Hello" in hex
$encoded = Hachi64::encode($binaryData);
$decoded = Hachi64::decode($encoded);
echo "Binary data (hex): " . bin2hex($binaryData) . "\n";
echo "Encoded:           {$encoded}\n";
echo "Decoded (text):    {$decoded}\n";
echo "Match:             " . ($decoded === $binaryData ? "✓" : "✗") . "\n";
echo "\n";

// Example 5: UTF-8 text
echo "Example 5: UTF-8 text\n";
echo "---------------------\n";
$utf8Text = "哈基米64编码器";
$encoded = Hachi64::encode($utf8Text);
$decoded = Hachi64::decode($encoded);
echo "Original: {$utf8Text}\n";
echo "Encoded:  {$encoded}\n";
echo "Decoded:  {$decoded}\n";
echo "Match:    " . ($decoded === $utf8Text ? "✓" : "✗") . "\n";
echo "\n";

echo "=== All examples completed successfully! ===\n";
