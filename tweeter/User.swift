//
//  User.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var profileImage: NSURL?
    var tagline: String?
    var dictionary : NSDictionary?
    var statusCount : Int?
    var followingCount : Int?
    var followersCount : Int?
    
    init(dictionary: NSDictionary)
    {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profilePicURL = dictionary["profile_image_url_https"] as? String
        if let profilePicURL = profilePicURL
        {
            profileImage = NSURL(string: profilePicURL)
        }
        
        tagline = dictionary["description"] as? String
        
        followingCount = dictionary["friends_count"] as? Int
        statusCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
    }
    static var _currentUser: User?
    
    class var currentUser:User?
    {
        get {
            if(_currentUser == nil)
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData
                {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
                

            }
            
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user
            {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else
            {
                defaults.setObject(nil, forKey: "currentUserData")

            }
            defaults.synchronize() //saves it (have to do every time u write to)
        }
        
    }

}
