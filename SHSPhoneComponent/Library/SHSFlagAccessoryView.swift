//
//  SHSFlagAccessoryView.swift
//  SHSPhoneComponentSwift
//
//  Created by Maksim Kupetskii on 12/09/2017.
//  Copyright © 2017 Maksim Kupetskii. All rights reserved.
//

import UIKit

/**
 Accessory view that shows flag images.
 */
internal class SHSFlagAccessoryView: UIView {
    
    private enum Sizes {
        static let iconSize: CGFloat       = 18
        static let minShift: CGFloat       = 5
        static let fontCorrection: CGFloat = 1
    }
    private var imageView: UIImageView?
    
    // MARK: - Life cycle
    init(with textField: UITextField) {
        super.init(frame: .zero)

        let fieldRect = textField.textRect(forBounds: textField.bounds)
        self.frame = CGRect(x: 0, y: 0,
                            width: viewWidth(for: fieldRect),
                            height: textField.frame.size.height)
        
        imageView = UIImageView(frame:
            CGRect(x: leftShift(for: fieldRect),
                   y: fieldRect.origin.y + (fieldRect.size.height - Sizes.iconSize)/2,
                   width: Sizes.iconSize, height: Sizes.iconSize))
        self.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Set image for accessory view.
     */
    func set(image: UIImage?) {
        imageView?.image = image
    }
    
    // MARK: - Internal
    private func leftShift(for textFieldRect: CGRect) -> CGFloat {
        let minX = textFieldRect.minX
        let result = minX < Sizes.minShift ? Sizes.minShift : minX
        return result + Sizes.fontCorrection
    }
    
    private func viewWidth(for textFieldRect: CGRect) -> CGFloat {
        let minX = textFieldRect.minX
        if minX < Sizes.minShift {
            return Sizes.minShift + Sizes.iconSize + Sizes.minShift - minX
        } else {
            return minX + Sizes.iconSize
        }
    }
}
