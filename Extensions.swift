//
//  Extensions.swift
//  iN
//
//  Created by Mark Manstof on 5/26/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Alerts
    func alert(title: String, message: String = "") {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UITableViewController {
    
    //Scrolling the tableView
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        let movementDuration:NSTimeInterval = 0.3
        
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations( "animateView", context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(movementDuration )
        
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        
        UIView.commitAnimations()
        
    }
}


extension UITextField{
    
    //XIB Placeholder Text Color
    @IBInspectable var placeHolderColor: UIColor? {
    
        get {
            
            return self.placeHolderColor
        
        }
        
        set {
        
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        
        }
    }
    
    //textField Border Color
    func setTextFieldBorderColor(borderColor: UIColor) {
        
        let border = CALayer()
        
        let width = CGFloat(5.0)
        
        border.borderColor = borderColor.CGColor
        
        border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        
        self.layer.masksToBounds = true
    }
    
}

extension UIButton {
    
    //Button Border Color
    func setButtonBorderColor(borderColor: UIColor) {
        
        let border = CALayer()
        
        let width = CGFloat(5.0)
        
        border.borderColor = borderColor.CGColor
        
        border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        
        self.layer.masksToBounds = true
    }
}

extension UIImageView{
    
    //Blur Images
    func blurImage(targetImageView:UIImageView?) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        
        targetImageView?.addSubview(blurEffectView)
    }
    
}

//Keyboard
extension UIViewController {
    //Register the keyboard for notifications in  viewDidLoad
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
}

//Remove duplicatees from arrays
extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        
        if let index = self.indexOf(object) {
            
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        
        for object in array {
            
            self.removeObject(object)
            
        }
    }
}


extension NSDate {
    
    //Comparing dates
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}