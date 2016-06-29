//
//  ComposeViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/28/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetEnterField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ComposeViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
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
}
