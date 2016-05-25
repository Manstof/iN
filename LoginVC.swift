//
//  LoginVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {

    //UI Elements
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //Utility
    var activeField: UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user is logged in then segue
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        //Hide keyboard from Functions.swift
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
    
        let ref = Firebase(url: firebaseInformation.firebaseURLString)
        
        ref.createUser(emailField.text,
                       password: passwordField.text,
                       withValueCompletionBlock: { error, result in
                       
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                        
                            let userID = result["uid"] as? String
                            
                            print("Successfully created user account with uid: \(userID)")
                        
                        }
        })
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let ref = Firebase(url: firebaseInformation.firebaseURLString)
        
        ref.authUser(emailField.text,
                     password: passwordField.text,
                     withCompletionBlock: { error, authData in
                        
                        if error != nil {
                     
                            print(error)
                        
                        } else {
                        
                            print("User Logged In")
                            
                            self.performSegueWithIdentifier("loginToTabs", sender: self)
                            
                        }
        })
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
