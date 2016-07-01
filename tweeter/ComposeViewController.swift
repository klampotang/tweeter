//
//  ComposeViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/28/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var tweetEnterField: UITextView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetEnterField.layer.borderWidth = 1
        let myColor = UIColor.blackColor()
        self.tweetEnterField.layer.borderColor = myColor.CGColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ComposeViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        textView.delegate = self
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        tweetEnterField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tweetTapped(sender: AnyObject) {
        if tweetEnterField.text != nil
        {
            let tweetText = tweetEnterField.text
            APIClient.sharedInstance.postStatus(tweetText!)
            tweetEnterField.text = "" //Clear the thing
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text.utf16).count + (text.utf16).count - range.length
        if(newLength <= 140){
            self.countdownLabel.text = "\(140 - newLength)"
            return true
        }else{
            return false
        }
        
    }
}
