//
//  TimelineItemTableViewCell.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class TimelineItemTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                self.userNameLabel.text = tweet.userName
                self.tweetLabel.text = tweet.tweetText
                if let screenName = tweet.screenName {
                    self.displayNameLabel.text = "@ \(screenName)"
                }
                self.tweetTimeLabel.text = tweet.getTimestampForDisplay()
                if let imageUrl = tweet.profileImageUrl {
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
