//
//  DetailViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/28/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var rtCountLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var likeCountFromSegue : Int?
    var textFromSegue : String?
    var profilePicFromSegue:UIImage?
    var rtCountFromSegue:Int?
    var usernameFromSegue : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeCountLabel.text = "\(likeCountFromSegue!)"
        rtCountLabel.text = "\(rtCountFromSegue!)"
        tweetTextLabel.text = textFromSegue
        profilePicImage.image = profilePicFromSegue
        usernameLabel.text = usernameFromSegue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rtAction(sender: AnyObject) {
        
    }
    
    @IBAction func likeAction(sender: AnyObject) {
        
    }

}
