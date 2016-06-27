//
//  User.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileImage: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profilePicURL = dictionary["profileImage"] as? String
        if let profilePicURL = profilePicURL
        {
            profileImage = NSURL(string: profilePicURL)
        }
        
        tagline = dictionary["profile_image_url_https"] as? String
    }
    

}
