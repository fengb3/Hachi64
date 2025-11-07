import XCTest
@testable import Hachi64

final class Hachi64Tests: XCTestCase {
    
    // MARK: - Test Encode Examples from Documentation
    
    func testEncodeHachi64Examples() {
        let testCases: [(String, String)] = [
            ("Hello", "豆米啊拢嘎米多="),
            ("abc", "西阿南呀"),
            ("Python", "抖咪酷丁息米都慢"),
            ("Hello, World!", "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=="),
            ("Base64", "律苦集叮希斗西丁"),
            ("Hachi64", "豆米集呀息米库咚背哈==")
        ]
        
        for (input, expected) in testCases {
            let data = input.data(using: .utf8)!
            let result = Hachi64.encode(data)
            XCTAssertEqual(result, expected, "Encode(\(input)) = \(result), want \(expected)")
        }
    }
    
    // MARK: - Test Decode Examples from Documentation
    
    func testDecodeHachi64Examples() {
        let testCases: [(String, String)] = [
            ("豆米啊拢嘎米多=", "Hello"),
            ("西阿南呀", "abc"),
            ("抖咪酷丁息米都慢", "Python"),
            ("豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==", "Hello, World!"),
            ("律苦集叮希斗西丁", "Base64"),
            ("豆米集呀息米库咚背哈==", "Hachi64")
        ]
        
        for (input, expected) in testCases {
            do {
                let result = try Hachi64.decode(input)
                let resultString = String(data: result, encoding: .utf8)!
                XCTAssertEqual(resultString, expected, "Decode(\(input)) = \(resultString), want \(expected)")
            } catch {
                XCTFail("Decode(\(input)) returned error: \(error)")
            }
        }
    }
    
    // MARK: - Test Edge Cases for Encoding
    
    func testEncodeEdgeCases() {
        let testCases: [(Data, String, String)] = [
            (Data(), "", "empty"),
            ("a".data(using: .utf8)!, "西律==", "single byte"),
            ("ab".data(using: .utf8)!, "西阿迷=", "two bytes"),
            ("abc".data(using: .utf8)!, "西阿南呀", "three bytes")
        ]
        
        for (input, expected, name) in testCases {
            let result = Hachi64.encode(input)
            XCTAssertEqual(result, expected, "\(name): Encode(\(String(data: input, encoding: .utf8) ?? "")) = \(result), want \(expected)")
        }
    }
    
    // MARK: - Test Edge Cases for Decoding
    
    func testDecodeEdgeCases() {
        let testCases: [(String, Data, String)] = [
            ("", Data(), "empty"),
            ("西律==", "a".data(using: .utf8)!, "single byte"),
            ("西阿迷=", "ab".data(using: .utf8)!, "two bytes"),
            ("西阿南呀", "abc".data(using: .utf8)!, "three bytes")
        ]
        
        for (input, expected, name) in testCases {
            do {
                let result = try Hachi64.decode(input)
                XCTAssertEqual(result, expected, "\(name): Decode(\(input)) mismatch")
            } catch {
                XCTFail("\(name): Decode(\(input)) returned error: \(error)")
            }
        }
    }
    
    // MARK: - Test Invalid Input
    
    func testDecodeInvalidInput() {
        let testCases = [
            "ABC",
            "哈哈哈X",
            "123"
        ]
        
        for input in testCases {
            do {
                _ = try Hachi64.decode(input)
                XCTFail("Decode(\(input)) should return error for invalid input")
            } catch {
                // Expected to throw
                XCTAssertTrue(error is Hachi64Error, "Expected Hachi64Error, got \(error)")
            }
        }
    }
    
    // MARK: - Test Roundtrip
    
    func testRoundtrip() {
        let testCases = [
            "Hello, World!",
            "rust",
            "a",
            "ab",
            "abc",
            "Python",
            "Hachi64",
            "",
            "The quick brown fox jumps over the lazy dog"
        ]
        
        for input in testCases {
            let data = input.data(using: .utf8)!
            let encoded = Hachi64.encode(data)
            
            do {
                let decoded = try Hachi64.decode(encoded)
                XCTAssertEqual(decoded, data, "Roundtrip failed for: \(input)")
            } catch {
                XCTFail("Decode returned error for \(input): \(error)")
            }
        }
    }
    
    // MARK: - Test Binary Data
    
    func testBinaryData() {
        // Create binary data with all byte values 0-255
        var binaryData = Data()
        for i in 0..<256 {
            binaryData.append(UInt8(i))
        }
        
        let encoded = Hachi64.encode(binaryData)
        
        do {
            let decoded = try Hachi64.decode(encoded)
            XCTAssertEqual(decoded, binaryData, "Binary data roundtrip failed")
        } catch {
            XCTFail("Decode returned error: \(error)")
        }
    }
    
    // MARK: - Test No Padding
    
    func testNoPaddingEncodeDecode() {
        let testCases = [
            "a",
            "ab",
            "abc",
            "Hello"
        ]
        
        for input in testCases {
            let data = input.data(using: .utf8)!
            let encodedNoPad = Hachi64.encode(data, padding: false)
            
            do {
                let decoded = try Hachi64.decode(encodedNoPad, padding: false)
                XCTAssertEqual(decoded, data, "No-padding roundtrip failed for: \(input)")
            } catch {
                XCTFail("Decode returned error for \(input): \(error)")
            }
        }
    }
    
    // MARK: - Test Padding Behavior
    
    func testPaddingBehavior() {
        let testData = "a".data(using: .utf8)!
        
        let encodedWithPadding = Hachi64.encode(testData, padding: true)
        let encodedWithoutPadding = Hachi64.encode(testData, padding: false)
        
        // With padding should end with ==
        XCTAssertTrue(encodedWithPadding.hasSuffix("=="), "Encoded with padding should end with ==, got \(encodedWithPadding)")
        
        // Without padding should not contain =
        XCTAssertFalse(encodedWithoutPadding.contains("="), "Encoded without padding should not contain =, got \(encodedWithoutPadding)")
        
        // Both should decode to the same result
        do {
            let decodedWithPadding = try Hachi64.decode(encodedWithPadding, padding: true)
            let decodedWithoutPadding = try Hachi64.decode(encodedWithoutPadding, padding: false)
            
            XCTAssertEqual(decodedWithPadding, testData, "Decoded with padding should equal original data")
            XCTAssertEqual(decodedWithoutPadding, testData, "Decoded without padding should equal original data")
        } catch {
            XCTFail("Decode returned error: \(error)")
        }
    }
    
    // MARK: - Test Alphabet Coverage
    
    func testAlphabetCoverage() {
        // Verify alphabet length
        let alphabetArray = Array(Hachi64.hachiAlphabet)
        XCTAssertEqual(alphabetArray.count, 64, "Alphabet length should be 64")
        
        // Verify no duplicate characters
        let uniqueChars = Set(alphabetArray)
        XCTAssertEqual(uniqueChars.count, 64, "Alphabet should contain 64 unique characters")
        
        // Test long data to ensure all characters can be used
        var longData = Data()
        for _ in 0..<3 {
            for i in 0..<256 {
                longData.append(UInt8(i))
            }
        }
        
        let encoded = Hachi64.encode(longData)
        
        do {
            let decoded = try Hachi64.decode(encoded)
            XCTAssertEqual(decoded, longData, "Long data roundtrip failed")
        } catch {
            XCTFail("Decode returned error: \(error)")
        }
    }
}
