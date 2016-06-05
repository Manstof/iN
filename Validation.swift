//
//  Validation.swift
//  iN
//
//  Created by Mark Manstof on 6/1/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    //Validate Email
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(self)
        
        return result
    }
    
    //Validate Password
    var isValidPassword: Bool {
        
        if self.characters.count < 8 {
            
            return false
            
        } else {
            
            return true
            
        }
    }
    
    //Validate Phone Number
    var isValidPhoneNumber: Bool {
        
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        let result =  phoneTest.evaluateWithObject(self)
        
        return result
    }

    //Validate Username
    var isValidUsername: Bool {
        
        let usernameRegEx = "^[a-zA-Z0-9_]+$"
        
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        
        let result = usernameTest.evaluateWithObject(self)
        
        print(result)
        
        return result
        
    }
    
    var isUsernameTaken: Bool {
        
        //TODO search and verify username isnt taken
        
        return false
    }
    
}

class validateUserInput: UIViewController {
//Verification Functions
    func validateUserProfileInput(username: String, phoneNumber: String, emailAddress: String, confirmEmailAddress: String, password: String, confirmPassword: String) -> Bool {
        
        let alertTitle = "Failed Signup"
        
        if username.isValidUsername != true {
            
            alert(alertTitle, message: "Username can only contain alphanumeric characters, '-' '.' and '_'")
            
        } else if username.isUsernameTaken == true {
            
            alert(alertTitle, message: "Username is taken, please try another one")
            
        } else if phoneNumber.isValidPhoneNumber != true {
            
            //TODO Format the phone number input field
            alert(alertTitle, message: "Please enter a valid phone number")
            
        } else if emailAddress.isValidEmail != true {
            
            alert(alertTitle, message: "Please enter a valid email address")
            
        } else if emailAddress != confirmEmailAddress {
            
            alert(alertTitle, message: "Email addresses fields do not match" )
            
        } else if password.isValidPassword != true {
            
            alert(alertTitle, message: "Please enter a valid password.  Passwords must be alphanumeric and at least 7 characters in legnth")
            
        } else if password != confirmPassword {
            
            alert(alertTitle, message: "Password fields do not match")
            
        } else {
            
            return true
            
        }
        
        return false
    }
}
