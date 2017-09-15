//
//  SHSPhoneComponentSwiftTests.swift
//  SHSPhoneComponentSwiftTests
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import XCTest
@testable import SHSPhoneComponentSwift

class SHSPhoneComponentSwiftTests: XCTestCase {

    let formatter = SHSPhoneNumberFormatter()
    enum Keys {
        static let text  = "text"
        static let image = "image"
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testShouldFormatByDefault() {
        let inputNumber = "12345678901"
        formatter.setDefaultOutputPattern("+# (###) ###-##-##")

        var result = formatter.values(for: inputNumber)
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == "+1 (234) 567-89-01",
                      "should format number by default")
        XCTAssertTrue(result[Keys.image] as? String == nil,
                      "default image is nil")

        formatter.setDefaultOutputPattern("+# (###) ###-####")

        result = formatter.values(for: inputNumber)
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == "+1 (234) 567-8901",
                      "should format number by default")
        XCTAssertTrue(result[Keys.image] as? String == nil,
                      "default image is nil")
    }

    func testShouldDetectSpecificFormats() {
        let inputNumber = "12345678901"
        let specififcInputNumber = "38012345678901"

        let imagePath = "SOME_IMAGE_PATH"
        formatter.setDefaultOutputPattern("+# (###) ###-##-##")

        formatter.addOutputPattern("+### (##) ###-##-##",
                                   forRegExp: "^380\\d*$",
                                   imagePath: imagePath)

        var result = formatter.values(for: inputNumber)
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == "+1 (234) 567-89-01",
                      "should format number by default")
        XCTAssertTrue(result[Keys.image] as? String == nil,
                      "default image is nil")

        result = formatter.values(for: specififcInputNumber)
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == "+380 (12) 345-67-89",
                      "should format number by specific pattern")
        XCTAssertTrue(result[Keys.image] as? String == imagePath,
                      "image is specified")
    }

    func testShouldHandleSpecialSymbols() {
        var inputNumber = "!#dsti*&"

        formatter.setDefaultOutputPattern("+# (###) ###-##-##")
        var result = formatter.values(for: inputNumber)
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == "", "should format number by default")
        XCTAssertTrue(result[Keys.image] as? String == nil,
                      "default image is nil")

        inputNumber = "+12345678901"
        formatter.setDefaultOutputPattern("+# (###) ###-##-##")
        result = formatter.values(for: inputNumber)
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == "+1 (234) 567-89-01",
                      "should format number by default and handle + symbol")
        XCTAssertTrue(result[Keys.image] as? String == nil,
                      "image should be nil")
    }

    func testShouldHandleFormatWithDigits() {
        var inputNumber = "9201234567"

        formatter.setDefaultOutputPattern("+7 (###) ###-##-##")
        var result = formatter.values(for: inputNumber)
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == "+7 (920) 123-45-67", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        inputNumber = "7777778877"
        result = formatter.values(for: inputNumber)
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == "+7 (777) 777-88-77", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        inputNumber = "3211231"
        formatter.setDefaultOutputPattern("### 123 ##-##")
        result = formatter.values(for: inputNumber)
        let number3 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number3 == "321 123 12-31", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        inputNumber = "1113333"
        result = formatter.values(for: inputNumber)
        let number4 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number4 == "111 123 33-33", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")
    }

    func testShouldCheckPrefix() {
        let inputNumber = "9201234567"

        formatter.prefix = "pr3f1x"
        formatter.setDefaultOutputPattern("(###) ###-##-##")
        var result = formatter.values(for: inputNumber)
        let should = String(format: "%@%@", formatter.prefix!, "(920) 123-45-67")
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == should, "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: should)
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == should, "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")
    }

    func testShouldCheckPrefixAndDifferentFormats() {
        let inputNumber = "3801234567"
        let inputNumberNoImage = "1231234567"
        let imagePath = "SOME_IMAGE_PATH"
        formatter.prefix = "pr3-f1x"

        formatter.setDefaultOutputPattern("##########")
        formatter.addOutputPattern("+### (##) ###-##-##",
                                   forRegExp: "^380\\d*$",
                                   imagePath: imagePath)
        formatter.addOutputPattern("+### (##) ###-##-##", forRegExp: "^123\\d*$")

        var result = formatter.values(for: inputNumber)
        var should = String(format: "%@%@", formatter.prefix!, "+380 (12) 345-67")
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == should, "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == imagePath,
                      "image is specified")

        result = formatter.values(for: inputNumberNoImage)
        should = String(format: "%@%@", formatter.prefix!, "+123 (12) 345-67")
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == should, "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")
    }

    func testShouldHandlePrefixAndNumberFormatStyle() {
        formatter.setDefaultOutputPattern("+78 (###) ###-##-##")

        var result = formatter.values(for: "+7 (123")
        let number1 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number1 == "+78 (123", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: "+87 (1234")
        let number2 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number2 == "+78 (871) 234", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        formatter.setDefaultOutputPattern("+7 (###) 88#-##-##")

        result = formatter.values(for: "+7 (123")
        let number3 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number3 == "+7 (123", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: "1234")
        let number4 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number4 == "+7 (123) 884", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: "+7 (123) 884")
        let number5 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number5 == "+7 (123) 888-84", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: "+7 (123) 8887")
        let number6 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number6 == "+7 (123) 888-88-7", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        formatter.prefix = "pr3-f1x "

        result = formatter.values(for: "+7 (123")
        let number7 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number7 == "pr3-f1x +7 (123", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")

        result = formatter.values(for: "+7 (123) 8887")
        let number8 = result[Keys.text] as? String ?? ""
        XCTAssertTrue(number8 == "pr3-f1x +7 (123) 888-88-7", "should format correctly")
        XCTAssertTrue(result[Keys.image] as? String == nil, "image should be nil")
    }
    
}
