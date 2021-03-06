//
//  MentionsViewCell.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/30/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class MentionsViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
