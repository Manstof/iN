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

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //Utility
    var activeField: UITextField?
    
    //Firebase
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set text field delegates
        self.nameField.delegate = self
        self.phoneNumberField.delegate = self
        self.usernameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        verifyUserInput()
        
        if verifyUserInput() == true {
            
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if user != nil {
                        
                        //TODO add photo to save
                        //TODO check if username is taken
                        let userProfile = ["name": self.nameField.text!, "phoneNumber": self.phoneNumberField.text!, "username": self.usernameField.text!, "emailAddress": self.emailField.text!]
                        
                        self.ref.child("users").child(user!.uid).setValue(userProfile)
                        
                        let userID = user?.uid
                        
                        print("Successfully created user account with uid: \(userID)")
                        
                        self.performSegueWithIdentifier("editProfileToTabs", sender: self)
                        
                    } else {
                        
                        print("Failed Creating User Database on Auth in EditProfieVC.swift")
                    }
                }
            })
        
        } else {
         
            print("User input not working")
            
        }
    }
    
            
    func verifyUserInput() -> Bool {
        
        if nameField.text?.isEmpty == true {
            
            let alert = UIAlertController(title: "Signup Failed", message: "Please enter your name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if phoneNumberField.text?.isEmpty == true || phoneNumberField.text?.characters.count != 10 {
            
            let alert = UIAlertController(title: "Signup Failed", message: "Please enter a valid phone number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if usernameField.text?.isEmpty == true /*TODO check if username exists*/ {
            
            let alert = UIAlertController(title: "Signup Failed", message: "Please enter a valid username", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if emailField.text?.isEmpty == true || emailField.text?.containsString("@") != true || emailField.text?.containsString(".") != true {
        
            let alert = UIAlertController(title: "Signup Failed", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if passwordField.text?.isEmpty == true {
            
            let alert = UIAlertController(title: "Signup Failed", message: "Please enter your password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if passwordField.text != confirmPasswordField.text {
        
            let alert = UIAlertController(title: "Signup Failed", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
        
        return true
        
        }
        
        return false
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Keyboard ═══╬
    
    func keyboardWasShown(notification: NSNotification) {
        
        //Calculate the keyboard size and adjust the tableView
        let info : NSDictionary = notification.userInfo!
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        //Scroll if the firstResponder is behind the keyboard
        var viewRect : CGRect = self.view.frame
        
        viewRect.size.height -= keyboardSize!.height
        
        if (!CGRectContainsPoint(viewRect, activeField!.frame.origin)) {
            
            //Move the view
            
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        //Once keyboard disappears, restore original positions of the view
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        
        let navigationBarHeight = navigationController!.navigationBar.frame.size.height
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(navigationBarHeight, 0.0, tabBarHeight, 0.0)
        
        //Move the view back down
        
        self.view.endEditing(true)
        
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
