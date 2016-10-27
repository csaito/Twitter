//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/27/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            print("setting tweet \(tweet!)")
            if let tweetText = tweet!.tweetText {
                self.tweetLabel.text = tweetText
            } else {
                self.tweetLabel.text = "Tweet Tweet"
            }
            if let imageUrl = tweet!.profileImageUrl {
                self.profileImageView.setImageWith(URL(fileURLWithPath: imageUrl))
            } else {
                self.profileImageView.image = nil
            }
            if let name = tweet!.userName {
                self.nameLabel.text = name
            } else {
                self.nameLabel.text = "Name"
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
