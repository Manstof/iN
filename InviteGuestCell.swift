//
//  InviteGuestCell.swift
//  iN
//
//  Created by Mark Manstof on 4/26/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit

class InviteGuestCell: UITableViewCell {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactNumberLabel: UILabel!
    
    @IBOutlet weak var contactImageButton: UIButton! {
        didSet {
            
            contactImageButton.backgroundColor = UIColor.whiteColor()
            
            contactImageButton.contentMode = .ScaleAspectFit
            
            contactImageButton.layer.masksToBounds = false
            
            contactImageButton.layer.borderWidth = 1
            
            contactImageButton.layer.borderColor = globalColor.inBlue.CGColor
            
            contactImageButton.layer.cornerRadius = contactImageButton.frame.height/2
            
            contactImageButton.clipsToBounds = true
        
        }
    }

    override func prepareForReuse() {
    
        contactImageButton.setTitle("", forState: .Normal)
        contactImageButton.setImage(nil, forState: .Normal)
    
    }
    
    func setNewImage(image: UIImage) {
        
        contactImageButton.setImage(image, forState: .Normal)

    }
    
    func setNewText(text: String) {
    
        contactImageButton.setTitle(text, forState: .Normal)
    }
    
    func setInitials(firstName: String, secondName: String) {
        
        var firstInitial = ""
        var lastInitial = ""
        
        if firstName.isEmpty == false {
            
            firstInitial = firstName.substringToIndex(firstName.startIndex.advancedBy(1))
        
        }
        
        if secondName.isEmpty == false {
        
            lastInitial = secondName.substringToIndex(secondName.startIndex.advancedBy(1))
        
        }
        
        let guestInitials = firstInitial + lastInitial
        
        setNewText(guestInitials)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }

}
