
//
//  File.swift
//  iN
//
//  Created by Mark Manstof on 6/7/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import Firebase
import UIKit

func firebaseLogout() {
    
    let firebaseAuth = FIRAuth.auth()
    
    do {
        
        try firebaseAuth?.signOut()
        
    } catch let signOutError as NSError {
        
        print ("Error signing out: %@", signOutError)
        
    }
    
}

func firebaseLogin(email: String, password: String) {
    
    
}

func firebaseLoginIfUserPersists(viewController : UIViewController) {
    
    FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
        
        if user != nil {
            
            presentTabsView(viewController)
            
        } else {
            
            firebaseLogout()
            
        }
    }
}
