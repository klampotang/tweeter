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
        return tweets.count ?? 0
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
        
        //Retweet Count
        cell.retweetCountLabel.text = "\(tweety.retweetCount)"
        
        //Likes
        cell.likeCountLabel.text = "\(tweety.likeCount)"
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
    @IBAction func likeTouched(sender: AnyObject) {
        
       var indexPath: NSIndexPath!
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TweetCell {
                    indexPath = (tableView.indexPathForCell(cell))
                }
            }
        }
        let tweety = tweets[indexPath.row]
        let idInt = tweety.id
        APIClient.sharedInstance.likeStatus(idInt!)
        let cell1 = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        //let likesCountNum = tweety.likeCount
        cell1.likeCountLabel.text = "Liked" // WHY NOT WORKING
        self.tableView.reloadData()
    }
    @IBAction func retweetTouched(sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TweetCell {
                    indexPath = (tableView.indexPathForCell(cell))
                }
            }
        }
        let tweety = tweets[indexPath.row]
        let idInt = tweety.id
        APIClient.sharedInstance.retweet(idInt!)
        let cell1 = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        cell1.retweetCountLabel.text = "Retweeted" // WHY NOT WORKING
        self.tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath1 = tableView.indexPathForCell(sender as! TweetCell)
        let tweety = self.tweets[indexPath1!.section]
        
        //Send tweet
        vc.textFromSegue = tweety.text
        //Send likes count
        vc.likeCountFromSegue = tweety.likeCount
        //Send rt count
        vc.rtCountFromSegue = tweety.retweetCount
        //Send pic
        let user = tweety.author
        let picURL = user?.profileImage
        let data = NSData(contentsOfURL:picURL!)
        if data != nil {
            let picImage = UIImage(data:data!)
            vc.profilePicFromSegue = picImage
        }
        //Send username
        vc.usernameFromSegue = user?.name
        
        
    }
    
    

}
