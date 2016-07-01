//
//  DetailViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/28/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var rtCountLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var likeCountFromSegue : Int?
    var textFromSegue : String?
    var profilePicFromSegue:UIImage?
    var rtCountFromSegue:Int?
    var usernameFromSegue : String?
    var particularTweet : Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeCountLabel.text = "\(likeCountFromSegue!)"
        rtCountLabel.text = "\(rtCountFromSegue!)"
        tweetTextLabel.text = textFromSegue
        profilePicImage.image = profilePicFromSegue
        usernameLabel.text = usernameFromSegue
        profilePicImage.layer.cornerRadius = 8.0
        profilePicImage.clipsToBounds = true
        let dateformat = NSDateFormatter()
        dateformat.dateStyle = NSDateFormatterStyle.LongStyle
        dateLabel.text = dateformat.stringFromDate((particularTweet?.createdAt)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rtAction(sender: AnyObject) {
        retweet()
    }
    
    @IBAction func likeAction(sender: AnyObject) {
        like()
    }
    
    func retweet()
    {
        let idInt = particularTweet!.id
        APIClient.sharedInstance.retweet(idInt!, success: {
            dispatch_async(dispatch_get_main_queue()) {
                //Update the retweet count
                let oldRTCount = self.particularTweet?.retweetCount
                self.rtCountLabel.text = "\(oldRTCount! + 1)"
            }
            },
        failure: { (error: NSError) -> () in
        //print("error: \(error.localizedDesciption)")
        })
    }
    
    func like()
    {
        let idInt = particularTweet!.id
        APIClient.sharedInstance.likeStatus(idInt!, success: {
            dispatch_async(dispatch_get_main_queue()) {
                //Update the like count
                let oldLikeCount = self.particularTweet?.likeCount
                self.likeCountLabel.text = "\(oldLikeCount!+1)"
            }
            },
            failure: { (error: NSError) -> () in
            //print("error: \(error.localizedDesciption)")
        })

    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let likeAction = UIPreviewAction(title: "Like", style: .Default) { (action, viewController) -> Void in
            self.like()
            print("You liked the photo")
        }
        
        let retweetAction = UIPreviewAction(title: "Retweet", style: .Default) { (action, viewController) -> Void in
            self.retweet()
            print("You retweeted")
            
        }
        
        let deleteAction = UIPreviewAction(title: "Cancel", style: .Destructive) { (action, viewController) -> Void in
            print("Cancelled")
        }
        
        return [likeAction, retweetAction, deleteAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let vc = segue.destinationViewController as! ReplyViewController
        vc.tweetBeingRepliedTo = particularTweet
    }

}
