//
//  Extensions.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 10/07/1442 AH.
//

import UIKit
import CoreGraphics
extension UIImage {
    func resize(size: CGFloat) -> UIImage {
        if self.size.width < size || self.size.height < size {
            return self
        }
        let scale = size / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: size, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0,width: size, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

enum Score : String {
    case Excellent = "Excellent"
    case VeryGood = "Very Good"
    case Good = "Good"
    case Poor = "Poor"
    case VeryPoor = "Very Poor"
}


extension UIViewController : UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let trimmed = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = trimmed
    }
}

extension UITextField {
    func placeholderColor(text : String) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
}
