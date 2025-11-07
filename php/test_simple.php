<?php
/**
 * Simple test script for Hachi64 - runs without PHPUnit
 */

require_once __DIR__ . '/src/Hachi64.php';

use Hachi64\Hachi64;

// ANSI color codes for output
$GREEN = "\033[0;32m";
$RED = "\033[0;31m";
$RESET = "\033[0m";
$YELLOW = "\033[1;33m";

$passedTests = 0;
$failedTests = 0;

function test($name, $condition, $message = "") {
    global $passedTests, $failedTests, $GREEN, $RED, $RESET;
    
    if ($condition) {
        $passedTests++;
        echo "{$GREEN}✓{$RESET} {$name}\n";
    } else {
        $failedTests++;
        echo "{$RED}✗{$RESET} {$name}\n";
        if ($message) {
            echo "  {$message}\n";
        }
    }
}

echo "\n=== Testing Hachi64 PHP Implementation ===\n\n";

// Test 1: Basic encode/decode
$data = "Hello";
$encoded = Hachi64::encode($data);
$decoded = Hachi64::decode($encoded);
test("Basic encode/decode", $decoded === $data, "Expected: {$data}, Got: {$decoded}");

// Test 2: Specific encoding
$expected = "豆米啊拢嘎米多=";
test("Specific encoding for 'Hello'", $encoded === $expected, "Expected: {$expected}, Got: {$encoded}");

// Test 3: Empty string
$emptyEncoded = Hachi64::encode("");
$emptyDecoded = Hachi64::decode("");
test("Empty string encode", $emptyEncoded === "", "Expected empty, Got: {$emptyEncoded}");
test("Empty string decode", $emptyDecoded === "", "Expected empty, Got: {$emptyDecoded}");

// Test 4: Multiple test cases
$testCases = [
    ["abc", "西阿南呀"],
    ["a", "西律=="],
    ["ab", "西阿迷="],
    ["Python", "抖咪酷丁息米都慢"],
    ["Hello, World!", "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=="],
    ["Base64", "律苦集叮希斗西丁"],
    ["Hachi64", "豆米集呀息米库咚背哈=="]
];

foreach ($testCases as [$input, $expected]) {
    $encoded = Hachi64::encode($input);
    $decoded = Hachi64::decode($encoded);
    test("Encode '{$input}'", $encoded === $expected, "Expected: {$expected}, Got: {$encoded}");
    test("Roundtrip '{$input}'", $decoded === $input, "Expected: {$input}, Got: {$decoded}");
}

// Test 5: No padding
$noPadEncoded = Hachi64::encode("a", false);
$noPadDecoded = Hachi64::decode($noPadEncoded, false);
test("No padding encode", strpos($noPadEncoded, '=') === false, "Should not contain '=': {$noPadEncoded}");
test("No padding decode", $noPadDecoded === "a", "Expected: a, Got: {$noPadDecoded}");

// Test 6: Padding behavior
$padEncoded = Hachi64::encode("a", true);
test("With padding encode", substr($padEncoded, -2) === "==", "Should end with '==': {$padEncoded}");

// Test 7: Binary data
$binaryData = '';
for ($i = 0; $i < 256; $i++) {
    $binaryData .= chr($i);
}
$binaryEncoded = Hachi64::encode($binaryData);
$binaryDecoded = Hachi64::decode($binaryEncoded);
test("Binary data roundtrip", $binaryDecoded === $binaryData, "Binary data encoding/decoding failed");

// Test 8: Alphabet length
$alphabetLen = mb_strlen(Hachi64::HACHI_ALPHABET, 'UTF-8');
test("Alphabet length is 64", $alphabetLen === 64, "Expected: 64, Got: {$alphabetLen}");

// Test 9: Alphabet uniqueness
$uniqueChars = [];
for ($i = 0; $i < $alphabetLen; $i++) {
    $char = mb_substr(Hachi64::HACHI_ALPHABET, $i, 1, 'UTF-8');
    $uniqueChars[$char] = true;
}
test("Alphabet has 64 unique characters", count($uniqueChars) === 64, "Expected: 64, Got: " . count($uniqueChars));

// Test 10: Invalid input handling
try {
    Hachi64::encode(null);
    test("Null encode throws exception", false, "Should have thrown exception");
} catch (\InvalidArgumentException $e) {
    test("Null encode throws exception", true);
}

try {
    Hachi64::decode(null);
    test("Null decode throws exception", false, "Should have thrown exception");
} catch (\InvalidArgumentException $e) {
    test("Null decode throws exception", true);
}

try {
    Hachi64::decode("包含无效字符X的字符串");
    test("Invalid character throws exception", false, "Should have thrown exception");
} catch (\InvalidArgumentException $e) {
    test("Invalid character throws exception", true);
}

// Test 11: Various data lengths
$lengths = [1, 2, 3, 10, 100, 255];
foreach ($lengths as $length) {
    $data = '';
    for ($i = 0; $i < $length; $i++) {
        $data .= chr($i % 256);
    }
    $encoded = Hachi64::encode($data);
    $decoded = Hachi64::decode($encoded);
    test("Length {$length} roundtrip", $decoded === $data, "Failed for length {$length}");
}

// Test 12: UTF-8 text
$utf8Text = "The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#$%^&*()";
$utf8Encoded = Hachi64::encode($utf8Text);
$utf8Decoded = Hachi64::decode($utf8Encoded);
test("UTF-8 text roundtrip", $utf8Decoded === $utf8Text, "UTF-8 text failed");

// Summary
echo "\n" . str_repeat("=", 50) . "\n";
echo "Results: {$GREEN}{$passedTests} passed{$RESET}, ";
if ($failedTests > 0) {
    echo "{$RED}{$failedTests} failed{$RESET}\n";
} else {
    echo "{$YELLOW}{$failedTests} failed{$RESET}\n";
}

exit($failedTests > 0 ? 1 : 0);
