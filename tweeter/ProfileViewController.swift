//
//  ProfileViewController.swift
//  tweeter
//
//  Created by Kelly Lampotang on 6/29/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currUser = APIClient.sharedInstance.currUser({ (user: User) in
            let userImageURL = user.profileImage
            let data = NSData(contentsOfURL:userImageURL!)
            if data != nil {
                let picImage = UIImage(data:data!)
                self.profileImageView.image = picImage
            }

        }) { (error: NSError) in
                print("error in displaying ur pic")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
