//
//  PresentViews.swift
//  iN
//
//  Created by Mark Manstof on 6/10/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit

func presentTabsView (viewController: UIViewController) {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    let presentedViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabsView") as UIViewController
    
    viewController.presentViewController(presentedViewController, animated: true, completion: nil)
    
}