//
//  Design.swift
//  iN
//
//  Created by Mark Manstof on 6/7/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation
import UIKit


//Theme
struct globalColor {
    
    static var inBlue = UIColor(red: 87.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1.0) //HEX: 6bc4eb //HSL: hsl(198, 76%, 67%)
    
}

//TODO make themes? http://sdbr.net/post/Themes-in-Swift/


extension UIViewController {
    
    //Blurred variation of the splashpage image
    func setBackgroundImage() {
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "splashPage")
        backgroundImage.blurImage(backgroundImage)
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
    }
}

extension UITextField{
    
    //XIB Placeholder Text Color
    @IBInspectable var placeHolderColor: UIColor? {
        
        get {
            
            return self.placeHolderColor
            
        } set {
            
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
            
        }
    }
    
    //textField Border Color
    func setTextFieldBorderColor(borderColor: UIColor) {
        
        let border = CALayer()
        
        let width = CGFloat(3.0)
        
        border.borderColor = borderColor.CGColor
        
        border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        
        self.layer.masksToBounds = true
    }
    
}

extension UIButton {
    
    //Button Border Color
    func setButtonBorderColor(borderColor: UIColor) {
        
        let border = CALayer()
        
        let width = CGFloat(5.0)
        
        border.borderColor = borderColor.CGColor
        
        border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        
        self.layer.masksToBounds = true
    }
}

extension UIImageView {
    
    //Blur Images
    func blurImage(targetImageView:UIImageView?) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        
        targetImageView?.addSubview(blurEffectView)
    }
    
}
