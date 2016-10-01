//
//  TopTextFieldDelegate.swift
//  MyMemeMe1.0
//
//  Created by Jason Crawford on 9/22/16.
//  Copyright © 2016 Jason Crawford. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> NSString {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        func setupTextField(string: String, textField: UITextField) {
            let memeTextAttributes = [
                NSStrokeColorAttributeName : UIColor.black,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSStrokeWidthAttributeName : -3
            ] as [String : Any]
            
            let attributedString = NSAttributedString(string: string, attributes: memeTextAttributes)
            textField.attributedText = attributedString
            textField.defaultTextAttributes = memeTextAttributes
            // Text should be center-aligned
            textField.textAlignment = .center
            textField.delegate = self
        }
        
//        let topTextField.defaultTextAttributes = memeTextAttributes
        
        return newText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
