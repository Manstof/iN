//
//  Variables.swift
//  iN
//
//  Created by Mark Manstof on 5/23/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit
import Contacts



//Event Details
class event {
    
    var hostUID: String! = ""
    var name: String! = ""
    var locationName: String! = ""
    var locationAddress: String! = ""
    var startDateString: String! = ""
    var endDateString: String! = ""
    var open: Bool! = true
    var guests = [CNContact]()
    var cost: String! = ""
    var additionalDetails: String! = ""
    
    class var info: event {
        
        struct Static {
            
            static let instance = event()
            
        }
        
        return Static.instance
    }
}

//Timestamp
var timestamp: String {
    
    let timestamp = NSDate().timeIntervalSince1970
    
    var timeString = "\(timestamp)"
    
    timeString = timeString.stringByReplacingOccurrencesOfString(".", withString: "")
    
    return timeString
    
}