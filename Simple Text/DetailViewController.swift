//
//  DetailViewController.swift
//  Simple Text
//
//  Created by Hamzah Mugharbil on 8/21/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    var text: String = ""
    var masterView: ViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dismiss-keyboard-black"), style: .plain, target: self, action: #selector(self.doneClicked))
//        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        textView.inputAccessoryView = toolBar
        
        if text == "" {
            textView.becomeFirstResponder()
        }
        
        
        textView.text = text
        
        
        
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    func setText(t: String) {
        text = t
        if isViewLoaded {
            textView.text = t
        }
        
    }

    func adjustTextView(notification: Notification) {
        let userIno = notification.userInfo!
        
        let keyboardEndCoor = (userIno[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndCoor, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text
    }
    

    
}
