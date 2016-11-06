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
    
    var selectionDelegate: TimelineItemSelected?
    
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: (#selector(TimelineItemTableViewCell.onCellTapped(_:))))
        tapRecognizer.delegate = self;
        tapRecognizer.numberOfTapsRequired = 1
        self.contentView.addGestureRecognizer(tapRecognizer)
    }
    
    func onCellTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let point = tapGestureRecognizer.location(in: self.contentView)
        if tapGestureRecognizer.state == .began {
        } else if tapGestureRecognizer.state == .changed {
        } else if tapGestureRecognizer.state == .ended {
            if (point.x < 45) {
                if let delegate = self.selectionDelegate {
                    delegate.profileSelected(selected: self)
                }
            } else {
                if let delegate = self.selectionDelegate {
                    delegate.tweetSelected(selected: self)
                }
            }
        }
    }
}

protocol TimelineItemSelected {
    func tweetSelected(selected: TimelineItemTableViewCell)
    func profileSelected(selected: TimelineItemTableViewCell)
}
