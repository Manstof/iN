//
//  iN
//
//  Created by Mark Manstof on 3/25/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import Contacts
import UIKit

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

func phoneInputFormatter(phoneNumberString: String) -> String {
    
    //Move from edit profile into this function
    return "String"
}

//Format Phone Numbers
func phoneFormatter(phoneString: String) -> String {
    
    var unformattedNumber = phoneString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("+", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("-", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString("(", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(")", withString: "")
    
    unformattedNumber = unformattedNumber.stringByReplacingOccurrencesOfString(".", withString: "")
    
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
    
    return formattedNumber
    
}

