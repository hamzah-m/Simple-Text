//
//  DetailViewController.swift
//  Simple Text
//
//  Created by Hamzah Mugharbil on 8/21/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var text: String = ""
    var masterView: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        textView.text = text
    }
    
   
    
    func setText(t: String) {
        text = t
        if isViewLoaded {
            textView.text = t
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
