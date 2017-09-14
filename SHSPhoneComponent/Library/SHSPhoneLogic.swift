//
//  SHSPhoneLogic.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import UIKit

/**
 Incapsulate number formatting and caret positioning logics. Also used as inner delegate.
 */
internal class SHSPhoneLogic: NSObject, UITextFieldDelegate {

    weak var delegate: UITextFieldDelegate?

    /**
     Incapsulate number formatting and caret positioning logics.
     */
    class func logicTextField(_ textField: SHSPhoneTextField,
                              shouldChangeCharactersIn range: NSRange,
                              replacementString string: String) -> Bool {
        if let notNilPrefix = textField.formatter.prefix {
            if range.location < notNilPrefix.characters.count {
                return false
            }
        }

        let caretPosition = pushCaretPosition(textField: textField, range: range)
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range,
                                                                                 with: string)

        applyFormat(textField: textField, forText: newString)
        popCaretPosition(textField: textField,
                         range: range,
                         caretPosition: caretPosition)

        textField.sendActions(for: .valueChanged)
        if textField.textDidChangeBlock != nil {
            textField.textDidChangeBlock!(textField)
        }
        return false
    }

    /**
     Formate a text and set it to a textfield.
     */
    class func applyFormat(textField: SHSPhoneTextField?, forText text: String?) {
        guard let notNilTextField = textField else { return }
        let result = notNilTextField.formatter.values(for: text ?? "")
        notNilTextField.text = result["text"] as? String
        if notNilTextField.formatter.canAffectLeftViewByFormatter {
            updateLeftImageView(textField: notNilTextField,
                                imagePath: result["image"] as? String)
        }
    }

    // MARK: - Logic Methods
    class func setImageLeftView(textField: UITextField, image: UIImage?) {
        if !(textField.leftView is SHSFlagAccessoryView) {
            textField.leftView = SHSFlagAccessoryView(with: textField)
        }
        textField.leftViewMode = .always
        (textField.leftView as? SHSFlagAccessoryView)?.set(image: image)
    }

    class func updateLeftImageView(textField: UITextField, imagePath: String?) {
        if let notNilImagePath = imagePath {
            let givenImage = UIImage(named: notNilImagePath)
            setImageLeftView(textField: textField, image: givenImage)
        } else {
            textField.leftViewMode = .never
        }
    }

    // MARK: - Caret Control
    class func pushCaretPosition(textField: UITextField, range: NSRange) -> Int {
        let subString = ((textField.text ?? "") as NSString)
                        .substring(to: range.location + range.length)
        return SHSPhoneNumberFormatter.valuableCharCount(in: subString)
    }

    class func popCaretPosition(textField: UITextField,
                                range: NSRange,
                                caretPosition: Int) {
        guard let text = textField.text else { return }
        var lasts = caretPosition
        var start = text.unicodeScalars.count
        let textUnichars = text.unicodeScalars.map { UnicodeScalar($0) }

        for index in (0..<text.unicodeScalars.count).reversed() {
            if lasts == 0 { break }
            let char = textUnichars[index]
            if SHSPhoneNumberFormatter.isValuable(char: char) {
                lasts -= 1
            }
            if lasts <= 0 {
                start = index
                break
            }
        }

        selectText(forInput: textField,
                   atRange: NSRange(location: start, length: 0))
    }

    class func selectText(forInput input: UITextField, atRange range: NSRange) {
        guard let start = input.position(from: input.beginningOfDocument,
                                         offset: range.location) else { return }
        guard let end = input.position(from: start, offset: range.length) else {
            return
        }
        input.selectedTextRange = input.textRange(from: start, to: end)
    }

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let phoneTextField = textField as? SHSPhoneTextField else {
            return false
        }
        _ = SHSPhoneLogic.logicTextField(phoneTextField,
                                         shouldChangeCharactersIn: range,
                                         replacementString: string)

        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textField(_:shouldChangeCharactersIn:replacementString:))) {
                _ = notNilDelegate.textField!(textField,
                                              shouldChangeCharactersIn: range,
                                              replacementString: string)
            }
        }
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let phoneTextField = textField as? SHSPhoneTextField else {
            return false
        }

        if phoneTextField.formatter.canAffectLeftViewByFormatter {
            textField.leftViewMode = .never
        }

        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldShouldClear(_:))) {
                return notNilDelegate.textFieldShouldClear!(textField)
            }
        }

        if phoneTextField.formatter.prefix != nil {
            phoneTextField.set(formattedText: "")
            return false
        } else {
            return true
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldShouldBeginEditing(_:))) {
                return notNilDelegate.textFieldShouldBeginEditing!(textField)
            }
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldDidBeginEditing(_:))) {
                return notNilDelegate.textFieldDidBeginEditing!(textField)
            }
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldShouldEndEditing(_:))) {
                return notNilDelegate.textFieldShouldEndEditing!(textField)
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldDidEndEditing(_:))) {
                return notNilDelegate.textFieldDidEndEditing!(textField)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let notNilDelegate = delegate {
            if notNilDelegate.responds(to: #selector(textFieldShouldReturn(_:))) {
                return notNilDelegate.textFieldShouldReturn!(textField)
            }
        }
        return true
    }
}
