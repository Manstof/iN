//
//  Keyboard.swift
//  iN
//
//  Created by Mark Manstof on 6/7/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit

//Used with the nextField extension
private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    
    //Extension to set the next text field
    var nextField: UITextField? {
        
        get {
            
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
            
        } set(newField) {
            
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
            
        }
    }
}

//Keyboard
extension UIViewController {
    
    //Scroll the view inside of the scroll view when the keyboard is shown
    func registerForKeyboardDidShowNotification(scrollView: UIScrollView, usingBlock block: (CGSize? -> Void)? = nil) {
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil, usingBlock: { (notification) -> Void in
            
            let userInfo = notification.userInfo!
            
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
            
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, keyboardSize!.height + 70, scrollView.contentInset.right)
            
            //Call UIScrollView extension
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            
            block?(keyboardSize)
        
        })
    }
    
    //Scroll the view inside of the scroll view when the keyboard is hidden
    func registerForKeyboardWillHideNotification(scrollView: UIScrollView, usingBlock block: (Void -> Void)? = nil) {
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil, usingBlock: { (notification) -> Void in
            
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, 0, scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            
            block?()
            
        })
    }
    
    //With table views scroll the view when keyboard appears
    func registerForKeyboardNotifications() {
        
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventVC.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventVC.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    //Deregister the keyboard for notification in viewWillDisapper
    func deregisterFromKeyboardNotifications() {
        
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    //Dismissing the keyboard for hideKeyboardWhenTappedAround
    func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    //Hide the keyboard when the user taps off the keyboard
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    //Adding a toolbar to the number keyboard
    //TODO: Move to a different file
    func addDoneButtonOnKeyboard(view: UIView?) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 50))
        
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: view, action: #selector(UIResponder.resignFirstResponder))
        
        var items = [UIBarButtonItem]()
        
        items.append(flexSpace)
        
        items.append(done)
        
        doneToolbar.items = items
        
        doneToolbar.sizeToFit()
        
        if let accessorizedView = view as? UITextField {
            
            accessorizedView.inputAccessoryView = doneToolbar
            
            accessorizedView.inputAccessoryView = doneToolbar
            
        }
    }
    
}