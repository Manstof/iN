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

//Setting up colors
struct globalColor {
    
    static var inBlue = UIColor(red: 107.0/255.0, green: 196.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    //HEX: 6bc4eb
    //HSL: hsl(198, 76%, 67%)
    
}

// MARK: TODO make theme http://sdbr.net/post/Themes-in-Swift/

//Firebase

struct firebaseInformation {
    
    static var firebaseURLString = "https://in-events.firebaseio.com/"
    
}

//Event Details class to store data of events
class event {
    
    var host: String! = "Manstof"
    var name: String! = ""
    var locationName: String! = ""
    var locationAddress: String! = ""
    var startDateString: String! = ""
    var endDateString: String! = ""
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
