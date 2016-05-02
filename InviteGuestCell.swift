//
//  InviteGuestCell.swift
//  iN
//
//  Created by Mark Manstof on 4/26/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit

class InviteGuestCell: UITableViewCell {
    
    
    @IBOutlet weak var contactImageButton: UIButton!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
