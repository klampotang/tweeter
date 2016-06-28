//
//  TweetsViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

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
        cell.tweetTextLabel.text = (tweets[indexPath.row]).text
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
            for tweet in tweets
            {
                print(tweet.text)
            }
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
