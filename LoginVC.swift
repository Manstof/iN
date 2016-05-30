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
    @IBOutlet weak var emailField: UITextField!
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

        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "splashPage")
        backgroundImage.blurImage(backgroundImage)
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        //Set Delegates
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        //Hide keyboard from Functions.swift
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //White Border
        let border = CALayer()
        let width = CGFloat(4.0)
        
        border.borderColor = UIColor.whiteColor().CGColor
        
        border.frame = CGRect(x: 0, y: 0, width:  emailField.frame.size.width, height: emailField.frame.size.height)
        
        border.borderWidth = width
        
        emailField.layer.addSublayer(border)
        emailField.layer.masksToBounds = true
        
        passwordField.layer.addSublayer(border)
        passwordField.layer.masksToBounds = true
    
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        
        
        
        performSegueWithIdentifier("loginToEditProfile", sender: self)
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        //TODO make the username lookup the email so they could sign in with username too
       
        if emailField.text != nil || passwordField.text != nil {
            
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    print("\(user) Logged In")
                    
                }
                
            }
        } else {
            
            //TODO make alert so check if fields are nil
            print("email or password field is nil when logging in")
            
        }
        
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
    
    //TODO Add unwind segue from signup

    
}
