//
//  Utility.swift
//  iN
//
//  Created by Mark Manstof on 3/25/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import Contacts
import Parse

//Setting up colors
struct globalColor {
    
    static var inBlue = UIColor(red: 107.0/255.0, green: 196.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    //HEX: 6bc4eb
    //HSL: hsl(198, 76%, 67%)

}

// MARK: TODO make theme http://sdbr.net/post/Themes-in-Swift/

//Event Details class to store data of events
class event {
    
    var name: String! = ""
    var locationName: String! = ""
    var locationAddress: String! = ""
    var startDate: NSDate!
    var endDate: NSDate!
    var open: Bool! = true
    var guests = [CNContact]()
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

//extension working with the keyboard
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

class spinner: NSObject {
    
    //Call With
    //let indicator = spinner().startActivityIndicator(self)
    //spinner().stopActivityIndicator(self,indicator: indicator)
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    func startActivityIndicator(obj:UIViewController) -> UIActivityIndicatorView {
        
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        self.myActivityIndicator.backgroundColor = globalColor.inBlue
        
        self.myActivityIndicator.center = obj.view.center
        
        obj.view.addSubview(myActivityIndicator)
        
        self.myActivityIndicator.startAnimating()
        
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        return self.myActivityIndicator
    }
    
    func stopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void {
        
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        indicator.removeFromSuperview()
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


func phoneFormatter(phoneString: String) -> String {
    
    var unformattedNumber = phoneString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("+", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("-", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("(", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(")", withString: "")
    
    if unformattedNumber[unformattedNumber.startIndex] == "1" {
        
        unformattedNumber.removeAtIndex(unformattedNumber.startIndex)
        
    }
    
    unformattedNumber.characters.count
    
    if unformattedNumber.characters.count > 10 {
        
        let rangeStart = unformattedNumber.startIndex.advancedBy(10)
        
        let rangeEnd = unformattedNumber.endIndex
        
        let range = rangeStart..<rangeEnd
        
        unformattedNumber.removeRange(range)
        
    }
    
    unformattedNumber.insert("(", atIndex: unformattedNumber.startIndex)
    
    unformattedNumber.insert(")", atIndex: unformattedNumber.startIndex.advancedBy(4))
    
    unformattedNumber.insert(" ", atIndex: unformattedNumber.startIndex.advancedBy(5))
    
    unformattedNumber.insert("-", atIndex: unformattedNumber.startIndex.advancedBy(9))
    
    let formattedNumber = unformattedNumber
    
    formattedNumber
    
    return formattedNumber
    
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