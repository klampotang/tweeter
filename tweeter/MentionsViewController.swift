//
//  MentionsViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/30/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getMentions()
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionsViewCell", forIndexPath: indexPath) as! MentionsViewCell
        let tweety = tweets[indexPath.row]
        //User
        let userParticular = tweety.author
        //Username
        cell.usernameLabel.text = userParticular?.screenname
        
        //tweet
        cell.tweetLabel.text = tweety.text
        
        //Profile picture
        if let profilePicURL = userParticular!.profileImage
        {
            let data = NSData(contentsOfURL:profilePicURL)
            if data != nil {
                cell.profileImageView.image = UIImage(data:data!)
            }
        }
        return cell
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMentions()
    {
        APIClient.sharedInstance.mentions({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error)
        }
    }
}
