//
//  APIClient.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class APIClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = APIClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "k6S9N2BDBSqUkDMXUqs6XI1LZ", consumerSecret: "ghsFwdk1cbWyNGYZINJ5HUV9ZIRPWXqMOWIyIgRyCFo5WH2q2Q")
    
    var loginSuccess : (() -> ())?
    var loginFailure : (NSError -> ())?
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ())
    {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currUser(success: (User) -> (), failure: (NSError)-> ())
    {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
                success(user)
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                
        })
        
    }
    
    func login(success: () -> (), failure: (NSError)-> ())
    {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success:
            {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("I got a token")
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
                
        }) { (error: NSError!) -> Void in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }

    }
    func logOut()
    {
        deauthorize()
        User.currentUser = nil
    }
    func handleOpenUrl(url: NSURL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currUser({ (currUser: User) in
                User.currentUser = currUser //calls the setter and saves it
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            
        }) {(error: NSError!) -> Void in
            self.loginFailure?(error)
        }

    }

}
