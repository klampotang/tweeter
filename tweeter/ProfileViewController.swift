//
//  ProfileViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/29/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet] = []
    let dict: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //other setup
        tableView.dataSource = self
        tableView.delegate = self
        
        _ = APIClient.sharedInstance.currUser({ (user: User) in
            let userImageURL = user.profileImage
            let data = NSData(contentsOfURL:userImageURL!)
            if data != nil {
                let picImage = UIImage(data:data!)
                self.profileImageView.image = picImage
                self.usernameLabel.text = user.screenname
                self.taglineLabel.text = user.tagline
                let followersCount = user.followersCount
                self.followersCountLabel.text = "\(followersCount!) followers"
                
                let followingCount = user.followingCount
                self.followingCountLabel.text = "\(followingCount!) following"
                
                let statusCount = user.statusCount
                self.statusCountLabel.text = "\(statusCount!) statuses"
                
                self.dict["screen_name"] = user.screenname
            }

        }) { (error: NSError) in
                print("error in displaying ur pic")
        }
        getUserTimeline()
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileViewCell", forIndexPath: indexPath) as! ProfileViewCell
        let tweety = tweets[indexPath.row]
        //User
        let userParticular = tweety.author
        //Username
        cell.usernameLabel.text = userParticular?.screenname
        
        //tweet
        cell.tweetLabel.text = tweety.text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }

    func getUserTimeline()
    {
        APIClient.sharedInstance.getUserTimeline(dict, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            
        }
    }

}
