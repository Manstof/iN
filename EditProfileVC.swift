//
//  EditProfileVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //Utility
    var activeField: UITextField?
    
    //Firebase
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set text field delegates
        self.phoneNumberField.delegate = self
        self.usernameField.delegate = self
        self.emailField.delegate = self
        self.confirmEmailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillLayoutSubviews() {
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "splashPage")
        backgroundImage.blurImage(backgroundImage)
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        //Borders
        phoneNumberField.setTextFieldBorderColor(UIColor.whiteColor())
        passwordField.setTextFieldBorderColor(UIColor.whiteColor())
        confirmEmailField.setTextFieldBorderColor(UIColor.whiteColor())
        confirmPasswordField.setTextFieldBorderColor(UIColor.whiteColor())
        emailField.setTextFieldBorderColor(UIColor.whiteColor())
        usernameField.setTextFieldBorderColor(UIColor.whiteColor())
        
        
//TODO Get Padding to work
//        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.myTextField.frame.height))
//        myTextField.leftView = paddingView
//        myTextField.leftViewMode = UITextFieldViewMode.Always
//        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch UITextField() {
            
        case phoneNumberField:
            
            print("switch Working")
            
            break
            
        default:
            
            print("Maybe")
            
            break
            
        }
        
        return false
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        //Get this to actually validate from the validation file
        
        verifyUserInput()
                
        if verifyUserInput() == true {
            
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if user != nil {
                        
                        //TODO add photo to save
                        //TODO check if username is taken
                        let userProfile = ["phoneNumber": self.phoneNumberField.text!, "username": self.usernameField.text!, "emailAddress": self.emailField.text!]
                        
                        self.ref.child("users").child(user!.uid).setValue(userProfile)
                        
                        let userID = user?.uid
                        
                        print("Successfully created user account with uid: \(userID)")
                        
                        self.performSegueWithIdentifier("editProfileToTabs", sender: self)
                        
                    } else {
                        
                        print("Failed Creating User Entry for Database on Auth in EditProfieVC.swift")
                    }
                }
            })
        
        } else {
         
            alert("Something went wrong", message: "Please check all fields and try again")
            
        }
    }
            
    func verifyUserInput() -> Bool {
        
        let alertTitle = "Failed Signup"
        
        if usernameField.text?.isValidUsername != true {
            
            alert(alertTitle, message: "Username can only contain alphanumeric characters, '-' '.' and '_'")
            
        } else if usernameField.text?.isUsernameTaken == true {
            
            alert(alertTitle, message: "Username is taken, please try another one")
        
        } else if phoneNumberField.text?.isValidPhoneNumber != true {
            
            //TODO Format the phone number input field
            alert(alertTitle, message: "Please enter a valid phone number")
            
        } else if emailField.text?.isValidEmail != true {
        
            alert(alertTitle, message: "Please enter a valid email address")
            
        } else if emailField.text != confirmEmailField.text {
        
            alert(alertTitle, message: "Email addresses fields do not match" )
            
        } else if passwordField.text?.isValidPassword != true {
            
            alert(alertTitle, message: "Please enter a valid password.  Passwords must be alphanumeric and at least 7 characters in legnth")
            
        } else if passwordField.text != confirmPasswordField.text {
        
            alert(alertTitle, message: "Password fields do not match")
            
        } else {
        
        return true
        
        }
        
        return false
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Keyboard ═══╬
    
    func keyboardWasShown(notification: NSNotification) {
        
        //TODO Move View
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        //TODO Move View
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeField = textField //Passes to keyboardWasShown to identify textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeField = nil //Passes to keyboardWasShown to deselect textField
        
    }
    
    //Dismiss the keyboard on return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
        
    }
}
