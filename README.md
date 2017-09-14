# SHSPhoneComponentSwift
A Swift version of SHSPhoneComponent framework
UITextField and Formatter subclasses for formatting phone numbers. Allows different formats for different countries (patterns). The caret positioning works excellent.

# Installation
## CocoaPods
To install SHSPhoneComponentSwift using CocoaPods just add the following line to your Podfile
```
pod 'SHSPhoneComponentSwift'
```

## Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
You can install Carthage with [HomeBrew](https://brew.sh/) using the following command:
```
$ brew update
$ brew install carthage
```
To integrate SHSPhoneComponentSwift into your Xcode project using Carthage, specify it in your `Cartfile`:
```
github "alucarders/SHSPhoneComponentSwift"
```
Run `carthage update` to build the framework and drag the built `SHSPhoneComponentSwift.framework` into your Xcode project.

# How To
After adding the framework to your project, you need to import the module
```swift
import SHSPhoneComponentSwift
```
After this you can start using `SHSPhoneTextField` type for displaying phone numbers

## Default format
```swift
phoneField.formatter.setDefaultOutputPattern("+# (###) ###-##-##")
```
![default](https://github.com/alucarders/SHSPhoneComponentSwift/blob/master/screenshots/default.png)

All input strings will be parsed in that way. Example: +7 (920) 123-45-67

## Prefix Format
You can set prefix for all inputs:
```swift
phoneField.formatter.setDefaultOutputPattern("(###) ###-##-##")
phoneField.formatter.prefix = "+7 "
```
![prefix](https://github.com/alucarders/SHSPhoneComponentSwift/blob/master/screenshots/prefix.jpeg)

## Multiple Formats
```swift
phoneField.formatter.prefix = nil
phoneField.formatter.addOutputPattern("+# (###) ###-##-##", 
                                      forRegExp: "^7[0-689]\\d*$",
                                      imagePath: "flag_ru")
phoneField.formatter.addOutputPattern("+### ###-##-##", 
                                      forRegExp: "^380\\d*$", 
                                      imagePath: "flag_ua")
```
![multiple](https://github.com/alucarders/SHSPhoneComponentSwift/blob/master/screenshots/double.jpeg)

## Multiple Formats with prefix
```swift
phoneField.formatter.setDefaultOutputPattern("### ### ###")
phoneField.formatter.prefix = "+7 "
phoneField.formatter.addOutputPattern("(###) ###-##-##",
                                      forRegExp: "^1\\d*$",
                                      imagePath:"flag_ru")
phoneField.formatter.addOutputPattern("(###) ###-###",
                                      forRegExp: "^2\\d*$",
                                      imagePath:"flag_ua")
```

## Specific Formats
If you want to format some numbers in a specific way just do
```swift
phoneField.formatter.addOutputPattern("+# (###) ###-##-##", 
                                      forRegExp: "^7[0-689]\\d*$",
                                      imagePath: "flag_ru")
phoneField.formatter.addOutputPattern("+### (##) ###-###", 
                                      forRegExp: "^374\\d*$", 
                                      imagePath: "flag_am")
```

# Formatting
If you need only formatting function you can use SHSPhoneNumberFormatter class.

# Requirements
iOS 9.3+

# License
SHSPhoneComponentSwift is available under the MIT license. See the LICENSE file for more info.
All credits go to the author of the original framework [SHSPhoneComponent](https://github.com/Serheo/SHSPhoneComponent).
