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

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    //Utility
//    var activeField: UITextField?
    
    //Firebase
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set nextField
        self.usernameField.nextField = self.emailField
        self.emailField.nextField = self.confirmEmailField
        self.confirmEmailField.nextField = self.passwordField
        self.passwordField.nextField = self.confirmPasswordField
        self.confirmPasswordField.nextField = self.phoneNumberField
        
        //Hide keyboard from Functions.swift
        self.hideKeyboardWhenTappedAround()
        
        //Adding the done button to the number keyboard
        self.addDoneButtonOnKeyboard(phoneNumberField)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        registerForKeyboardDidShowNotification(scrollView)
        registerForKeyboardWillHideNotification(scrollView)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        deregisterFromKeyboardNotifications()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        //Set navigation bar
        self.navigationController?.navigationBarHidden = false
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "splashPage")
        backgroundImage.blurImage(backgroundImage)
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        //Borders
        usernameField.setTextFieldBorderColor(UIColor.whiteColor())
        emailField.setTextFieldBorderColor(UIColor.whiteColor())
        confirmEmailField.setTextFieldBorderColor(UIColor.whiteColor())
        passwordField.setTextFieldBorderColor(UIColor.whiteColor())
        confirmPasswordField.setTextFieldBorderColor(UIColor.whiteColor())
        phoneNumberField.setTextFieldBorderColor(UIColor.whiteColor())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //TODO get text field to edit for phone number
    
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
    
    //Dismiss the keyboard on return button or move to next field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.nextField == nil {
            
            self.view.endEditing(true)
            
            if textField == phoneNumberField {
                
                signupButtonPressed(self)
                
            }
            
            return false
            
        } else {
            
            textField.nextField?.becomeFirstResponder()
            
            return true
            
        }
    }
}