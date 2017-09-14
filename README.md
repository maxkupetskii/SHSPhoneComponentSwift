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

### Default format
```swift
phoneField.formatter.setDefaultOutputPattern("+# (###) ###-##-##")
```
