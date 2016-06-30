//
//  TweetCell.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var tweety:Tweet?
    
    @IBAction func likeTapped(sender: AnyObject) {
        let idString = tweety!.id
        APIClient.sharedInstance.likeStatus(idString!, success: {
            self.likeCountLabel.text = "\((self.tweety?.likeCount)!+1)"
            }, failure: { (error: NSError) -> () in
                print("error:")
                print(error.localizedDescription)
        })
    }
    @IBAction func retweetTouched(sender: AnyObject) {
        
        let idInt = self.tweety!.id
        APIClient.sharedInstance.retweet(idInt!, success: { 
            self.retweetCountLabel.text = "\((self.tweety?.retweetCount)!+1)"
        }, failure: { (error: NSError) -> () in
            print("error:")
            print(error.localizedDescription)
        })
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
