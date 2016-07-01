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

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.masksToBounds = false
        signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        signUpButton.clipsToBounds = true
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.masksToBounds = false
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject)
    {
        APIClient.sharedInstance.login({
            print("I've logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
            print("\(error.localizedDescription)")
        }
    }

    @IBAction func onSignUpButton(sender: AnyObject) {
        
        if let url = NSURL(string: "https://twitter.com/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
