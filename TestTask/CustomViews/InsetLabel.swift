//
//  InsetLabel.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 18.12.2022.
//

import Foundation
import UIKit

@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = .zero
    @IBInspectable var bottomInset: CGFloat = .zero
    @IBInspectable var leftInset: CGFloat = 16
    @IBInspectable var rightInset: CGFloat = 16
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }
    
    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
