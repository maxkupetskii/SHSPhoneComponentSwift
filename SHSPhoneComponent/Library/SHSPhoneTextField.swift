//
//  SHSPhoneTextField.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import UIKit

/**
 Simple UITextField subclass to handle phone numbers formats
 */
class SHSPhoneTextField: UITextField {
    
    /**
     SHSPhoneNumberFormatter instance.
     Use it to configure format properties.
     */
//    @property (readonly, strong) SHSPhoneNumberFormatter *formatter;
    
    /**
     Phone number without formatting. Ex: 89201235678
     */
    var phoneNumber: String? {
        return "" // TODO:
    }
    
    /**
     Phone number without formatting and prefix
     */
    var phoneNumberWithoutPrefix: String? {
        return "" // TODO:
    }
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        logicInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logicInitialization()
    }
    
    private func logicInitialization() {
//        _formatter = [[SHSPhoneNumberFormatter alloc] init];
//        _formatter.textField = self;
//        
//        logicDelegate = [[SHSPhoneLogic alloc] init];
//        
//        [super setDelegate:logicDelegate];
        self.keyboardType = UIKeyboardType.numberPad
    }

    
    /**
     Formats a text and sets it to a textfield.
     */
    func set(formattedText text: String) {
        // TODO:
    }
    
    // MARK: - Delegates
}
