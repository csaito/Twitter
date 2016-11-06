//
//  ProfileMenuTableViewCell.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class ProfileMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true;
    }

}
