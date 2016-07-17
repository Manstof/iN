//
//  LoginVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

//TODO Make XIB Pretty

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    //UI Elements
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //firebase Auth
    var authHandle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Next Text Fields on keyboard return
        self.emailField.nextField = self.passwordField
        
        //Hide keyboard
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Keyboard functions
        registerForKeyboardDidShowNotification(scrollView)
        registerForKeyboardWillHideNotification(scrollView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Auth firebase user
        //firebaseLoginIfUserPersists(self)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //Hide nav bar
        self.navigationController?.navigationBarHidden = true
        
        //Set Background Image
        setBackgroundImage()
        
        //Set Border Colors
        passwordField.setTextFieldBorderColor(UIColor.whiteColor())
        emailField.setTextFieldBorderColor(UIColor.whiteColor())
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //Firebase remove user auth listener
        //FIRAuth.auth()?.removeAuthStateDidChangeListener(authHandle!)
        
        //Keyboard
        deregisterFromKeyboardNotifications()
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        //TODO Send content from text fields with segue
        
        performSegueWithIdentifier("loginToEditProfile", sender: self)
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        //TODO make the username lookup the email so they could sign in with username too
        
        if emailField.text?.isValidEmail == false {
            
            alert("Failed Log iN", message: "Please provide a valid email address")
            
        } else if passwordField.text == "" {
            
            alert("Failed Log iN", message:  "Please enter a password")
        
        } else if passwordField.text?.isValidPassword == false {
            
            alert("Failed Log iN", message:  "Password Incorrect")
            
        } else {
            
            //TODO Move this to FBase.swift
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    
                    let errorCode = error!.code
                    
                    //TODO Check all other cases
                    switch errorCode {
                        
                    case 17011:
                        
                        self.alert("Failed Log iN", message: "User account doesn't exist, please create one")
                        
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
    
    //Dismiss the keyboard on return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.nextField == nil {
        
            self.view.endEditing(true)
            
            if textField == passwordField {
                
                loginButtonPressed(self)
                
            }
            
            return false
            
        } else {
        
            textField.nextField?.becomeFirstResponder()
            
            return true
            
        }
    }
}
