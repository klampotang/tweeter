//
//  TweetCell.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UITextView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    @IBOutlet weak var buttonRetweet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImage.layer.cornerRadius = 8.0
        profilePicImage.clipsToBounds = true
    }
    var tweety:Tweet?
    
    @IBAction func likeTapped(sender: AnyObject) {
        let idString = tweety!.id
        if(tweety?.favorited == false)
        {
            APIClient.sharedInstance.likeStatus(idString!, success: {
                self.likeCountLabel.text = "\((self.tweety?.likeCount)!+1)"
                self.buttonLike.imageView?.image = UIImage(named: "FillHeart")
                }, failure: { (error: NSError) -> () in
                    print("error:")
                    print(error.localizedDescription)
            })
        }
        else if(tweety?.favorited == true)
        {
            APIClient.sharedInstance.unlikeStatus(idString!, success: {
                self.likeCountLabel.text = "\((self.tweety?.likeCount)!-1)"
                self.buttonLike.imageView?.image = UIImage(named: "Heart")
                }, failure: { (error: NSError) -> () in
                    print("error:")
                    print(error.localizedDescription)
            })
        }

    }
    @IBAction func retweetTouched(sender: AnyObject)
    {
        
        let idInt = self.tweety!.id
        APIClient.sharedInstance.retweet(idInt!, success: { 
            self.retweetCountLabel.text = "\((self.tweety?.retweetCount)!+1)"
            self.buttonRetweet.imageView?.image = UIImage(named: "FillRetweet")
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
