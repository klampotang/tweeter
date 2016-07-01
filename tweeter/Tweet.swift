//
//  Tweet.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/27/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var likeCount: Int = 0
    var author: User?
    var id : String?
    var favorited : Bool = false
    var retweeted : Bool = false

    init(dictionary: NSDictionary)
    {
        text = dictionary["text"] as? String
        let timestampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        if let timestampString = timestampString
        {
            createdAt = formatter.dateFromString(timestampString)
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        likeCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let userDict = dictionary["user"] as? NSDictionary
        author = User(dictionary: userDict!)
        
        //ID
        id = dictionary["id_str"] as? String
        
        //Favorited?
        favorited = dictionary["favorited"] as! Bool
        
        //Retweeted
        retweeted = dictionary["retweeted"] as! Bool
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
