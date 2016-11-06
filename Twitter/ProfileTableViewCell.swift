//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroudImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                self.userNameLabel.text = user.userName
                if let screenName = user.screenName {
                    self.screenNameLabel.text = "@ \(screenName)"
                }
                if let imageUrl = user.profileImageUrl {
                    self.profileImageView.setImageWith(URL(string: imageUrl)!)
                } else {
                    self.profileImageView.image = UIImage(named: "DefaultProfile")
                }
                self.followingNumLabel.text = String(user.following!)
                self.followersNumLabel.text = String(user.followers!)
                if let backgroundImageUrl = user.backgroundImageUrl {
                    self.backgroudImageView.setImageWith(URL(string: backgroundImageUrl)!)
                } else {
                    self.backgroudImageView.image = nil
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
