//
//  SHSPhoneNumberFormatter.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import Foundation

/**
 Formatter class that converts input string to phone format.
 */
public final class SHSPhoneNumberFormatter: Formatter {

    public weak var textField: SHSPhoneTextField?

    /**
     If you want to use leftView or leftViewMode property set this property to false.
     Default is false.
     */
    public var canAffectLeftViewByFormatter: Bool = false

    /**
     Prefix for all formats.
     */
    private var _prefix: String?
    public var prefix: String? {
        get {
            return _prefix
        }
        set {
            let phoneNumber = textField?.phoneNumberWithoutPrefix
            _prefix = newValue
            SHSPhoneLogic.applyFormat(textField: textField,
                                      forText: _prefix?.appending(phoneNumber ?? ""))
        }
    }

    internal var config: [String: Any?]?

    // MARK: - Life cycle
    public override init() {
        super.init()
        resetFormats()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Filtering Input String
    /**
     Returns all digits from a string.
     */
    public func digitsOnlyString(from aString: String?) -> String {
        return SHSPhoneNumberFormatter.digitsOnlyString(from: aString)
    }

    private func stringWithoutFormat(aString: String) -> String {
        var theString = aString

        let dict = configForSequence(aString: aString)
        let format = dict?[Keys.format] as? String

        let aStringChars = aString.unicodeScalars.map { UnicodeScalar($0) }
        let formatChars = (format ?? "").unicodeScalars.map { UnicodeScalar($0) }
        var removeRanges: [NSRange] = []
        for i in 0..<min(formatChars.count, aStringChars.count) {
            let formatCh = formatChars[i]
            if formatCh != aStringChars[i] { break }
            if SHSPhoneNumberFormatter.isValuable(char: formatCh) {
                removeRanges.append(NSRange(location: i, length: 1))
            }
        }

        for value in removeRanges.reversed() {
            theString = (theString as NSString).replacingCharacters(in: value,
                                                                    with: "")
        }

        return digitsOnlyString(from: theString)
    }

    // MARK: - Find Matched Dictionary
    private func matchString(aString: String,
                             withPattern pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: .caseInsensitive)
            let match = regex.firstMatch(in: aString,
                                         options: [],
                                         range: NSRange(location: 0,
                                                        length: aString.characters.count))
            return match != nil
        } catch {
            print(error)
        }
        return false
    }

    private func configForSequence(aString: String) -> [String: Any?]? {
        let defaultConfig = config?[Keys.defaultConfig] as? [String: Any?]
        guard let notNilConfig = config else {
            return defaultConfig
        }

        for format in notNilConfig.keys {
            if matchString(aString: aString, withPattern: format) {
                return notNilConfig[format] as? [String: Any?]
            }
        }
        return defaultConfig
    }

    // MARK: - Getting Formatted String and Image Path
    private func requireSubstitute(char: UnicodeScalar) -> Bool {
        return char == "#"
    }

    private func applyFormat(_ format: String?,
                             forFormattedString formattedDigits: String) -> String {
        var result = ""
        guard let notNilFormat = format else { return result }

        let formatUnichars = notNilFormat.unicodeScalars.map { UnicodeScalar($0) }
        let formattedDigitsUnichars = formattedDigits.unicodeScalars.map { UnicodeScalar($0) }

        var charIndex = 0
        for char in formatUnichars {
            guard charIndex < formattedDigitsUnichars.count else { break }
            if requireSubstitute(char: char) {
                let sp = formattedDigitsUnichars[charIndex]
                charIndex += 1
                result.append(String(sp))
            } else {
                result.append(String(char))
            }
        }

        return String(format: "%@%@", prefix ?? "", result)
    }

    /**
     Converts input string to a dictionary.
     Return value format {text: "FORMATTED_PHONE_NUMBER", image: "PATH_TO_IMAGE"}
     Image path can be nil
     */
    public func values(for aString: String) -> [String: Any?] {
        var nonPrefix = aString
        if let notNilPrefix = prefix {
            if aString.hasPrefix(notNilPrefix) {
                nonPrefix = aString.substring(from: notNilPrefix.endIndex)
            }
        }
        let formattedDigits = stringWithoutFormat(aString: nonPrefix)
        let configDict = configForSequence(aString: formattedDigits)
        let result = applyFormat(configDict?[Keys.format] as? String,
                                 forFormattedString: formattedDigits)

        return [Keys.image: configDict?[Keys.image] as? String, Keys.text: result]
    }

    // MARK: - Class methods
    /**
     Removes required number of digits in the phone text.
     */
    class func formattedRemove(string: String, atIndex range: NSRange) -> String {
        var newString = string
        var removeCount = valuableCharCount(in: (newString as NSString).substring(with: range))
        if range.length == 1 { removeCount = 1 }

        var newStringUnichars = newString.unicodeScalars.map { UnicodeScalar($0) }
        for wordCount in 0..<removeCount {
            for i in (0...(range.location + range.length - wordCount - 1)).reversed() {
                let char = newStringUnichars[i]
                if isValuable(char: char) {
                    newStringUnichars.remove(at: i)
                    break
                }
            }
        }
        let ans = newStringUnichars.map { Character($0) }
        return String(ans)
    }

    /**
     Checks if a char is a valuable symbol (i.e. part of a number).
     Valuable chars are all digits.
     */
    class func isValuable(char: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(char)
    }
    
    /**
     Returns a count of valuable symbols in a string.
     */
    class func valuableCharCount(in string: String) -> Int {
        var count = 0
        for unicodeChar in string.unicodeScalars {
            if isValuable(char: unicodeChar) { count += 1 }
        }
        return count
    }

    /**
     Returns all digits from a string.
     */
    class func digitsOnlyString(from aString: String?) -> String {
        guard let notNilString = aString else { return "" }
        do {
            let regex = try NSRegularExpression(pattern: "\\D",
                                            options: .caseInsensitive)
            return regex.stringByReplacingMatches(in: notNilString,
                                                  options: [],
                                                  range: NSRange(location: 0,
                                                                 length: notNilString.characters.count),
                                                  withTemplate: "")
        } catch {
            print(error)
        }
        return ""
    }

    // MARK: - Formatter
    public override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard obj != nil else { return false }
        obj?.pointee =  digitsOnlyString(from: string) as AnyObject
        return true
    }

    public override func string(for obj: Any?) -> String? {
        if !(obj is String) { return nil }
        return values(for: obj as! String)[Keys.text] as? String
    }

}
