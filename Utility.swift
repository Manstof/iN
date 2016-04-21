//
//  Utility.swift
//  iN
//
//  Created by Mark Manstof on 3/25/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import Parse

//Setting up colors
struct globalColor {
    
    static var inBlue = UIColor(red: 107.0/255.0, green: 196.0/255.0, blue: 235.0/255.0, alpha: 1.0)

}

// MARK: ToDo make theme http://sdbr.net/post/Themes-in-Swift/

//Event Details
class event {
    
    var name: String! = ""
    var locationName: String! = ""
    var locationAddress: String! = ""
    var startDate: NSDate!
    var endDate: NSDate!
    var open: Bool! = true
    var cost: String! = ""
    var additionalDetails: String! = "Enter Additional Event Details"
    var additionalDetailsPlaceholder: String! = "Enter Additional Event Details"
    
    class var info: event {

        struct Static {
        
            static let instance = event()
        
        }
        
        return Static.instance
    }
}

//Dismissing the keyboard
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
        
        print("dismissKeyboard")
        
    }
    
    //Hide the keyboard when the user taps off the keyboard
    func hideKeyboardWhenTappedAround() {
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        print("HideKeyboardWhenTappedAround")
    
    }
}

extension UITableViewController {
    
    // Lifting the view up
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

//Comparing dates
extension NSDate {
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