//
//  TweetsViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets : [Tweet] = []
    var isMoreDataLoading = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getTimeline()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        let tweety = tweets[indexPath.row]
        
        //Tweet text
        cell.tweetTextLabel.text = tweety.text
        
        //Date
        let datey = tweety.createdAt! as NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //let dateyString = dateFormatter.stringFromDate(datey)
        let dateyRelative = datey.dateTimeAgo()
        cell.timeLabel.text = dateyRelative
        
        //User
        let userParticular = tweety.author
        //Profile picture
        if let profilePicURL = userParticular!.profileImage
        {
            let data = NSData(contentsOfURL:profilePicURL)
            if data != nil {
                cell.profilePicImage.image = UIImage(data:data!)
            }
        }
        else
        {
            //Do nothing
        }
        
        //Username
        cell.usernameLabel.text = userParticular?.screenname
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutClicked(sender: AnyObject) {
        APIClient.sharedInstance.logOut()
    }
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        getTimeline()
        refreshControl.endRefreshing()
    }
    func getTimeline()
    {
        APIClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            // Tell the refreshControl to stop spinning
            }, failure: { (error: NSError) -> () in
                //print("error: \(error.localizedDesciption)")
        })
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                getTimeline()
            }
        }
    }

}
