//
//  BottumTextFieldDelegate.swift
//  MyMemeMe1.0
//
//  Created by Jason Crawford on 9/22/16.
//  Copyright © 2016 Jason Crawford. All rights reserved.
//

import Foundation
import UIKit

class BottumTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string)
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)!,
            NSStrokeWidthAttributeName : NSNumber(value: 3.0)//TODO: Fill in appropriate Float
        ]
        
        let bottumTextField.defaultTextAttributes = memeTextAttributes
        
        return newText
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
