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
        APIClient.sharedInstance.retweet(idInt!)
        //Update the retweet count
        rtCountLabel.text = "Retweeted" //Fix this later
    }
    
    func like()
    {
        let idInt = particularTweet!.id
        APIClient.sharedInstance.likeStatus(idInt!)
        //Update like thing
        likeCountLabel.text = "hi" //Fix this later
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

}
