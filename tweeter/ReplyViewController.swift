//
//  ReplyViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/29/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    var tweetBeingRepliedTo: Tweet?

    @IBOutlet weak var replyTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyClicked(sender: AnyObject) {
        let dict: NSMutableDictionary = [:]
        
        let authorOfTweet = tweetBeingRepliedTo?.author
        let statusID = (tweetBeingRepliedTo?.id)! as String 
        //let inReplyTo = "?in_reply_to_status_id_str=\(statusID)"
        let atUsername = "@" + authorOfTweet!.screenname! + ": "
        let replyTextAdded = atUsername + replyTextField.text
        //let replyTextEncoded = replyTextAdded.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        dict["status"] = replyTextAdded
        //let finalString = replyTextEncoded! + inReplyTo
        dict["in_reply_to_status_id_str"] = statusID
        //print(finalString)
        APIClient.sharedInstance.replyStatus(dict)
        dismissViewControllerAnimated(true, completion: nil)
    }

}
