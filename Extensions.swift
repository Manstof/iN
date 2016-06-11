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


extension UIScrollView {
    //ScrollView extension used to with the UIViewController extensions to scroll with the keyboard
    func setContentInsetAndScrollIndicatorInsets(edgeInsets: UIEdgeInsets) {
    
        self.contentInset = edgeInsets
        
        self.scrollIndicatorInsets = edgeInsets
    
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