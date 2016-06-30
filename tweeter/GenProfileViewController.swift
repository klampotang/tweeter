//
//  GenProfileViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/29/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class GenProfileViewController: UIViewController {

    @IBOutlet weak var genProfilePic: UIImageView!
    @IBOutlet weak var genUsernameLabel: UILabel!
    @IBOutlet weak var genTaglineLabel: UILabel!
    
    var genAuthor : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get username
        genUsernameLabel.text = genAuthor?.screenname
        //get tagline
        genTaglineLabel.text = genAuthor?.tagline
        //get profile pic
        let userImageURL = genAuthor?.profileImage
        let data = NSData(contentsOfURL:userImageURL!)
        if data != nil {
            let genpic = UIImage(data:data!)
            self.genProfilePic.image = genpic
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
