//
//  FollowerViewCell.swift
//  tweeter
//
//  Created by Kelly Lampotang on 7/1/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class FollowerViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
