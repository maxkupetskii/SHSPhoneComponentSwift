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
public class SHSPhoneNumberFormatter: Formatter {

    /**
     If you want to use leftView or leftViewMode property set this property to false.
     Default is false.
     */
    public var canAffectLeftViewByFormatter: Bool = true
    /**
     Prefix for all formats.
     */
    private var prefix: String?
    private weak var textField: SHSPhoneTextField?

    private var config: [String: Any?] = [:]

    /**
     Returns all digits from a string.
     */
    func digitOnlyString(from aString: String) -> String {
        return ""
    }

    /**
     Converts input string to a dictionary.
     Return value format {text: "FORMATTED_PHONE_NUMBER", image: "PATH_TO_IMAGE"}
     Image path can be nil
     */
    private func values(for aString: String) -> [String: Any?] {
        return [:]
    }

    // MARK: - Class methods
    /**
     Removes required number of digits in the phone text.
     */
    class func formattedRemove(string: String, atIndex range: NSRange) -> String {
        return ""
    }

    /**
     Checks if a char is a valuable symbol (i.e. part of a number).
     Valuable chars are all digits.
     */
    class func isValuable(char: UniChar) -> Bool {
        return true
    }
    
    /**
     Returns a count of valuable symbols in a string.
     */
    class func valuableCharCount(inString string: String) -> Int {
        return 0
    }

    /**
     Returns all digits from a string.
     */
    class func digitOnlyString(from aString: String) -> String {
        return ""
    }

}
