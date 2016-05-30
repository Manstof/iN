//
//  EventsFeedCell.swift
//  iN
//
//  Created by Mark Manstof on 3/26/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit

class EventsFeedCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
