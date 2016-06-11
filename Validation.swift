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

func FBaseEmailTakenVerification() {
   
    print("run")
    
    let ref: FIRDatabaseReference!
    
    ref = FIRDatabase.database().reference()
    //Firebase
    FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
        
        print(user)
        
        if let user = user {
            
            print(ref)
            
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                //Nothing inside of this closuer will run?
                if snapshot.exists() {
                    
                    print("snapshot exists")
                    
                } else {
                        
                   print("Snapshot does not exist")
                   
                }
            })
        }
    }
}

extension String {
    //Validate Email input
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(self)
        
        return result
    }
    
    //Validate Email not in use
    var isEmailTaken: Bool {
        
        FBaseEmailTakenVerification()
        
        return true
        
    }
    
    //Validate Password input
    var isValidPassword: Bool {
        
        if self.characters.count < 8 {
            
            return false
            
        } else {
            
            return true
            
        }
    }
    
    //Validate Phone Number input
    var isValidPhoneNumber: Bool {
        
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        let result =  phoneTest.evaluateWithObject(self)
        
        return result
    }

    //Validate Username input
    var isValidUsername: Bool {
        
        let usernameRegEx = "^[a-zA-Z0-9_]+$"
        
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        
        let result = usernameTest.evaluateWithObject(self)
        
        print(result)
        
        return result
        
    }
    
    //Search to see if username in use
    var isUsernameTaken: Bool {
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                
                print(snapshot)
                
            }
        })
    
        return false
    }
}

func validateUserProfileInput(username: String, phoneNumber: String, emailAddress: String, confirmEmailAddress: String, password: String, confirmPassword: String) -> String {
    
    if username.isValidUsername != true {
        
        return "Username can only contain alphanumeric characters, '-' '.' and '_'"
        
    } else if username.isUsernameTaken == true {
        
        return "Username is taken, please try another one"
        
    } else if phoneNumber.isValidPhoneNumber != true {
        
        //TODO Format the phone number input field
        return "Please enter a valid phone number"
        
    } else if emailAddress.isValidEmail != true {
        
        return "Please enter a valid email address"
        
    } else if emailAddress != confirmEmailAddress {
        
        return "Email address fields do not match"
        
    } else if password.isValidPassword != true {
        
       return "Please enter a valid password.  Passwords must be alphanumeric and at least 7 characters in length"
        
    } else if password != confirmPassword {
        
        return "Password fields do not match"
        
    } else {
        
        return "Sign up successful"
        
    }
    
    return "Sign up failed"

}


//class validateUserInput: UIViewController {
////Verification Functions
//    func validateUserProfileInput(username: String, phoneNumber: String, emailAddress: String, confirmEmailAddress: String, password: String, confirmPassword: String) -> Bool {
//        
//        let alertTitle = "Failed Signup"
//        
//        if username.isValidUsername != true {
//            
//            alert(alertTitle, message: "Username can only contain alphanumeric characters, '-' '.' and '_'")
//            
//        } else if username.isUsernameTaken == true {
//            
//            alert(alertTitle, message: "Username is taken, please try another one")
//            
//        } else if phoneNumber.isValidPhoneNumber != true {
//            
//            //TODO Format the phone number input field
//            alert(alertTitle, message: "Please enter a valid phone number")
//            
//        } else if emailAddress.isValidEmail != true {
//            
//            alert(alertTitle, message: "Please enter a valid email address")
//            
//        } else if emailAddress != confirmEmailAddress {
//            
//            alert(alertTitle, message: "Email address fields do not match" )
//            
//        } else if password.isValidPassword != true {
//            
//            alert(alertTitle, message: "Please enter a valid password.  Passwords must be alphanumeric and at least 7 characters in length")
//            
//        } else if password != confirmPassword {
//            
//            alert(alertTitle, message: "Password fields do not match")
//            
//        } else {
//            
//            return true
//            
//        }
//        
//        return false
//    }
//}
