//
//  GenProfileViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/29/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class GenProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var genProfilePic: UIImageView!
    @IBOutlet weak var genUsernameLabel: UILabel!
    @IBOutlet weak var genTaglineLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var genAuthor : User?
    var tweets : [Tweet] = []
    let dict: NSMutableDictionary = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup tableview data/delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        //Get username
        genUsernameLabel.text = genAuthor?.screenname
        //get tagline
        genTaglineLabel.text = genAuthor?.tagline
        //get profile pic
        let userImageURL = genAuthor?.profileImage
        let data = NSData(contentsOfURL:userImageURL!)
        if data != nil {
            let genpic = UIImage(data:data!)
            self.genProfilePic.image = genpic
        }
        genProfilePic.layer.cornerRadius = 8.0
        genProfilePic.clipsToBounds = true
        //Get status count
        let statusCount = genAuthor?.statusCount
        statusCountLabel.text = "\(statusCount!)"
        //Get followers Count
        let followerCount = genAuthor?.followersCount
        followersCountLabel.text = "\(followerCount!)"
        //Get following count
        let followingCount = genAuthor?.followingCount
        followingCountLabel.text = "\(followingCount!)"
        
        dict["screen_name"] = genAuthor?.screenname
        
        let headerImageURL = genAuthor?.headerImage
        let data2 = NSData(contentsOfURL: headerImageURL!)
        if data2 != nil {
            let genheaderpic = UIImage(data:data2!)
            self.headerImage.image = genheaderpic
        }
        getUserTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenViewCell", forIndexPath: indexPath) as! GenViewCell
        let tweety = tweets[indexPath.row]
        //User
        let userParticular = tweety.author
        //Username
        cell.usernameLabel.text = userParticular?.screenname
        
        //tweet
        cell.tweetLabel.text = tweety.text
        
        //pic
        if let profilePicURL = userParticular!.profileImage
        {
            let data = NSData(contentsOfURL:profilePicURL)
            if data != nil {
                cell.profileImage.image = UIImage(data:data!)
            }
        }
        
        return cell
        

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
