//
//  AddDetailsVC.swift
//  iN
//
//  Created by Mark Manstof on 4/15/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit

class AddDetailsVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    let placeholderText = "Enter event additional details"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event.info.additionalDetails == "" {
        
            textView.textColor = UIColor.lightGrayColor()
            
            textView.text = placeholderText
        
        } else {
            
            textView.textColor = UIColor.blackColor()
            
            textView.text = event.info.additionalDetails
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        textView.delegate = self
        
        textView.becomeFirstResponder()
        
        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        
        //Set cursor position
        if event.info.additionalDetails != "" {
        
            let newPosition = textView.endOfDocument
        
            textView.selectedTextRange = textView.textRangeFromPosition(newPosition, toPosition: newPosition)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddDetailsVC.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        textView.resignFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Working with the keyboard
    func keyboardShown(keyboardNotification:NSNotification) {
        
        let keyboardInformation = keyboardNotification.userInfo!
        
        var keyboardFrame = (keyboardInformation[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        keyboardFrame = self.textView.convertRect(keyboardFrame, fromView:nil)
        
        self.textView.contentInset.bottom = keyboardFrame.size.height
     
        self.textView.scrollIndicatorInsets.bottom = keyboardFrame.size.height
    
    }
    
    func textFieldShouldReturn(textView: UITextView!) -> Bool {

        doneButtonPressed(self)
        
        return true
    }
    
    
    //Working with the textView
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text
        
        if currentText == placeholderText {
            
            textView.text = nil
            
            textView.textColor = UIColor.blackColor()
            
        }
        
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = placeholderText
            
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
        
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
        
            textView.text = nil
            
            textView.textColor = UIColor.blackColor()
        
        }
        
        //Trigger segue on done button being pressed
        if text == "\n" {
        
            doneButtonPressed(self)
        
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        if self.view.window != nil {
        
            if textView.textColor == UIColor.lightGrayColor() {
            
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
         
            }
        }
    }
    
    //Working with Segues
    @IBAction func doneButtonPressed(sender: AnyObject) {
    
        event.info.additionalDetails = textView.text
        
        performSegueWithIdentifier("unwindAddDetailToCreateEvent", sender: self)
    
    }

}
