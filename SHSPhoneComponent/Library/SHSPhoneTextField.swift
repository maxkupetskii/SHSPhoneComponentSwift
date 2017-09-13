//
//  SHSPhoneTextField.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import UIKit

public typealias SHSTextBlock = (_ textField: UITextField) -> Void

/**
 Simple UITextField subclass to handle phone numbers formats
 */
public class SHSPhoneTextField: UITextField {
    
    /**
     SHSPhoneNumberFormatter instance.
     Use it to configure format properties.
     */
    public var formatter = SHSPhoneNumberFormatter()

    /**
     Block will be called when text changed
     */
    public var textDidChangeBlock: SHSTextBlock?

    /**
     Phone number without formatting. Ex: 89201235678
     */
    public var phoneNumber: String? {
        return formatter.digitsOnlyString(from: self.text)
    }
    
    /**
     Phone number without formatting and prefix
     */
    public var phoneNumberWithoutPrefix: String? {
        return formatter.digitsOnlyString(from: self.text?.replacingOccurrences(of: formatter.prefix,
                                                                                 with: ""))
    }
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        logicInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logicInitialization()
    }
    
    private func logicInitialization() {
        formatter.textField = self

//        logicDelegate = [[SHSPhoneLogic alloc] init];
        
//        [super setDelegate:logicDelegate];
        self.keyboardType = UIKeyboardType.numberPad
    }

    
    /**
     Formats a text and sets it to a textfield.
     */
    func set(formattedText text: String) {
        //
    }
    
    // MARK: - Delegates
}
