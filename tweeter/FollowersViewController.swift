//
//  FollowersViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 7/1/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit


class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userParticular : User?
    @IBOutlet weak var tableView: UITableView!
    var followers : [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getFollowers()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowersViewCell", forIndexPath: indexPath) as! FollowerViewCell
        let dict = followers[indexPath.row] as NSDictionary
        cell.usernameLabel.text = dict.valueForKey("screen_name") as? String
        
        let profilePicString = dict.valueForKey("profile_image_url_https") as! String
        let modifiedProfileUrlString = profilePicString.stringByReplacingOccurrencesOfString("_normal", withString: "")
        let profileImage = NSURL(string: modifiedProfileUrlString)
        let data = NSData(contentsOfURL:profileImage!)
        if data != nil {
            cell.profileImage.image = UIImage(data:data!)
        }
        
        return cell
        
    }
    func getFollowers()
    {
        let userScreenName = userParticular?.screenname
        APIClient.sharedInstance.getFollowers(userScreenName!, success: { (followers: [NSDictionary]) in
            self.followers = followers
            print(self.followers)
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print(error)
        }
    }

}
