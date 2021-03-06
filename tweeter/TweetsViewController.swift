//
//  TweetsViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }
}
class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets : [Tweet] = []
    var maxID : String?
    
    //Infinite scroll stuff
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getTimeline()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //// Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        let tweety = tweets[indexPath.row]
        
        //Tweet text
        cell.tweetTextLabel.text = tweety.text
        cell.tweety = tweety
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
        
        //If statement for retweet/like
        
        if(cell.tweety?.favorited == true)
        {
            cell.buttonLike.imageView?.image = UIImage(named: "FillHeart")
        }
        if(cell.tweety?.retweeted == true)
        {
            cell.buttonRetweet.imageView?.image = UIImage(named: "FillRetweet")
        }
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
    func getMoreTimeline()
    {
        self.updateMaxID()
        APIClient.sharedInstance.homeTimeLineMore(maxID!, success: { (tweets: [Tweet]) -> Void in
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            self.tweets.appendContentsOf(tweets)
            
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            // Tell the refreshControl to stop spinning
            }, failure: { (error: NSError) -> () in
                //print("error: \(error.localizedDesciption)")
        })
    }
    func updateMaxID()
    {
        maxID = tweets.last!.id

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
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                
                getMoreTimeline()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.restorationIdentifier == "DetailViewController"
        {
            let vc = segue.destinationViewController as! DetailViewController
            let indexPath1 = tableView.indexPathForCell(sender as! TweetCell)
            let tweety = self.tweets[indexPath1!.row]
            
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
            
            //Send tweet
            vc.particularTweet = tweety
        }
        if segue.destinationViewController.restorationIdentifier == "GenProfileViewController"
        {
            let vc = segue.destinationViewController as! GenProfileViewController
            var indexPath: NSIndexPath!
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? TweetCell {
                        indexPath = (tableView.indexPathForCell(cell))
                    }
                }
            }
            let tweet = self.tweets[indexPath.row]
            
            vc.genAuthor = tweet.author
        }
    }
}
