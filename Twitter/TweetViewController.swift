//
//  TweetViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/30/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetAndLikeView: UIView!
    @IBOutlet weak var retweetAndLikeLabel: UILabel!
    @IBOutlet weak var iconsView: UIView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet {
            self.nameLabel.text = tweet.userName
            self.screenNameLabel.text = tweet.screenName
            if let imageUrl = tweet.profileImageUrl {
                self.profileImageView.setImageWith(URL(string: imageUrl)!)
            } else {
                self.profileImageView.image = nil
            }
            self.tweetTextView.text = tweet.tweetText
            self.createdAtLabel.text = getFormattedDateString(tweet.createdAt as Date)
            self.setRetweetAndLikes(retweetCount: tweet.retweetCount!, favoritesCount: tweet.favoritesCount!)
        }
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true;
        self.resizeTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFormattedDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma  MMM dd yyyy"
        return formatter.string(from: date)
    }
    
    func setRetweetAndLikes(retweetCount: Int, favoritesCount: Int) {
        let retweetAndLikeString = NSMutableAttributedString(string: "\(retweetCount) RETWEETS \(favoritesCount) LIKES")
        print("retweetAndLikeString \(retweetAndLikeString)")
        let rwCharCount = "\(retweetCount)".characters.count
        let favCharCount = "\(favoritesCount)".characters.count
        
        let index = " RETWEETS ".characters.count + rwCharCount
        
        let desc = self.retweetAndLikeLabel.font.fontDescriptor.withSymbolicTraits(.traitBold)
        retweetAndLikeString.addAttribute(NSFontAttributeName,
                                   value: UIFont(descriptor: desc!, size: 0.0),
                                   range: NSRange(location: 0, length: rwCharCount))
        retweetAndLikeString.addAttribute(NSFontAttributeName,
                                          value: UIFont(descriptor: desc!, size: 0.0),
                                          range: NSRange(location: index, length: favCharCount))
        self.retweetAndLikeLabel.attributedText = retweetAndLikeString
    }
    
    func resizeTextView() {
        let textView = self.tweetTextView!
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
