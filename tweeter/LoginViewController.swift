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

}
