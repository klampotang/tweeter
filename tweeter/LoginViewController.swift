//
//  LoginViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject)
    {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "k6S9N2BDBSqUkDMXUqs6XI1LZ", consumerSecret: "ghsFwdk1cbWyNGYZINJ5HUV9ZIRPWXqMOWIyIgRyCFo5WH2q2Q")
        twitterClient.deauthorize()
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success:
        {
                (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
                
        }) { (error: NSError!) -> Void in
                print(error.localizedDescription)
        }
        
    }

}
