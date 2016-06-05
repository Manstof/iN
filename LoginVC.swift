//
//  LoginVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    //UI Elements
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //Utility
    var activeField: UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//
//                print("\(user) is logged in")
//
//                self.performSegueWithIdentifier("loginToTabs", sender: self)
//
//            } else {
//                
//            }
//        }
        
        //Register Keyboard
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)

        //Set Delegates
        self.emailAddressField.delegate = self
        self.passwordField.delegate = self
        
        //Hide keyboard from Functions.swift
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "splashPage")
        backgroundImage.blurImage(backgroundImage)
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        //Set Border Colors
        passwordField.setTextFieldBorderColor(UIColor.whiteColor())
        emailAddressField.setTextFieldBorderColor(UIColor.whiteColor())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        deregisterFromKeyboardNotifications()
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("loginToEditProfile", sender: self)
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        //TODO make the username lookup the email so they could sign in with username too
        if emailAddressField.text?.isValidEmail == false {
            
            alert("Failed Log iN", message: "Please provide a valid email address")

        } else if passwordField.text?.isValidPassword == false {
            
            alert("Failed Log iN", message:  "Password Incorrect")
            
        } else {
            
            FIRAuth.auth()?.signInWithEmail(emailAddressField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    
                    let errorCode = error!.code
                    
                    //TODO Check other cases
                    switch errorCode {
                        
                    case 17011:
                        
                        self.alert("Failed Log iN", message: "User account doesn't exist, please create one")
                        
                        break
                        
                    case 17999:
                        
                        print("17999")
                        
                        break
                        
                    default:
                        
                        self.alert("Failed Log iN", message: "An unknown error occured")
                        
                        print(error!.localizedDescription)
                        
                        break
                        
                    }
                    
                    self.alert("Failed Signup", message: "\(error)")
                    
                    print(error?.code)
                    
                } else {
                    
                    //TODO Add Spinner
                    
                    self.performSegueWithIdentifier("loginToTabs", sender: self)
                    
                }
            }
        }
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Keyboard ═══╬
    
    func keyboardWasShown(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
         
            self.view.frame.origin.y -= keyboardSize.height
        
        }

    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
         
            self.view.frame.origin.y += keyboardSize.height
        
        }
        
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

//TODO Add prepare for segue to pass username and pass if typed to the signup viewController
