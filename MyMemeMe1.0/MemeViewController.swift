//
//  MemeViewController.swift
//  MyMemeMe1.0
//
//  Created by Jason Crawford on 9/21/16.
//  Copyright © 2016 Jason Crawford. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImage: UIImageView!    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        reset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // will disable camera button if not available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true  
    }
    
    func reset(){
        memeImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    
    func setupTextField(_ textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ] as [String : Any]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        resetViewFrame()
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            resetViewFrame()
        }
    }
    
    func resetViewFrame(){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // default text is cleared when user taps on textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func hideToolbar(_ visible: Bool) {
        toolBar.isHidden = visible
        navigationBar.isHidden = visible
    }
    
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activity.completionWithItemsHandler =  { activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activity, animated: true, completion: nil)
        
    }
    
    func save() {
        _ = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: memeImage.image, memeImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbar(true)
        
        // render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbar(false)
        
        return memedImage
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        reset()
    }
    
//: MARK: Pick an image from photo library or camera
    enum sourceType : Int {
        case photoLibrary = 0, camera
    }
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        memeImage.image = nil
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch (sourceType(rawValue: sender.tag)!) {
        case .photoLibrary:
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        case .camera:
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
}
    
    



