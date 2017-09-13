//
//  SHSPhoneNumberFormatter+UserConfig.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

extension SHSPhoneNumberFormatter {

    internal enum Keys {
        static let defaultConfig  = "default"
        static let format         = "format"
        static let image          = "image"
        static let defaultPattern = "#############"
        static let regexp         = "regexp"
        static let imagePath      = "imagePath"
        static let text           = "text"
    }

    // MARK: - Predefined configs
    var defaultPattern: [String: Any?] {
        return [Keys.format: Keys.defaultPattern, Keys.image: nil]
    }

    var resetConfig: [String: Any?] {
        return [Keys.defaultConfig: defaultPattern]
    }

    // MARK: - Format setters
    /**
     Removes all patterns and applies a clear format style.
     Default format is @"#############", imagePath is nil.
     */
    public func resetDefaultFormat() {
        if config != nil {
            config![Keys.defaultConfig] = defaultPattern
        } else {
            config = [Keys.defaultConfig: defaultPattern]
        }
    }

    /**
     Removes all patterns and applies a clear format style.
     Default format is @"#############", imagePath is nil.
     */
    public func resetFormats() {
        if let defPattern = config?[Keys.defaultConfig] {
            // Don't reset default pattern if it exists
            config = [Keys.defaultConfig: defPattern]
        } else {
            config = resetConfig
        }
    }

    /**
     Applies default format style and image.
     Symbol '#' represents any digit.
     Example: "+# (###) ###-##-##", imagePath is "flag_ru".
     */
    public func setDefaultOutputPattern(_ pattern: String,
                                        imagePath: String? = nil) {
        if imagePath != nil {
            canAffectLeftViewByFormatter = true
        }
        config?[Keys.defaultConfig] = [Keys.format: pattern,
                                       Keys.image: imagePath]
    }

    /**
     All numbers matched your regexp will be formatted with your style and image
     Symbol '#' represents any digit.
     Example: pattern is "+# (###) ###-##-##", imagePath is "flag_ru", regexp is "^375\\d*$"
     */
    public func addOutputPattern(_ pattern: String,
                                 forRegExp regexp: String,
                                 imagePath: String? = nil) {
        if imagePath != nil {
            canAffectLeftViewByFormatter = true
        }
        config?[regexp] = [Keys.format: pattern,
                           Keys.image: imagePath]
    }

    /**
     Patterns array keep references to dictionaries each with individual patterns configuration. Each pattern dictionary should contain key "format" with format representation string, key for regular expression named "regexp" with string value and optionally "imagePath" key with image name string

     All numbers matched your regexp will be formatted with your style and image
     Symbol '#' represents any digit.
     Example: format is "+# (###) ###-##-##", imagePath is "flag_ru", regexp is "^375\\d*$"
     */
    public func setOutputPatterns(from patterns: [[String: Any?]]) {
        for pattern in patterns {
            guard let format = pattern[Keys.format] as? String,
                let regexp = pattern[Keys.regexp] as? String else { continue }
            addOutputPattern(format,
                             forRegExp: regexp,
                             imagePath: pattern[Keys.imagePath] as? String)
        }
    }

}
