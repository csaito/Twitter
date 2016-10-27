//
//  Tweet.swift
//  Twitter
//

import Foundation

class Tweet : NSObject {
    //user profile picture, username, tweet text, and timestamp
    var profileImageUrl: String?
    var userName: String?
    var tweetText: String?
    var timestamp: String?
    
    init(tweetDictionary: NSDictionary) {
        if let user = tweetDictionary["user"] {
            self.profileImageUrl = (user as! NSDictionary)["profile_image_url"] as? String
        }
        self.userName = tweetDictionary["screen_name"] as? String
        self.tweetText = tweetDictionary["text"] as? String
        self.timestamp = tweetDictionary["created_at"] as? String
    }
    
    // Creates a text representation of a tweet    
    override var description: String {
        return "[Name: \(self.unwrapOrDefault(self.userName))]" +
            "\n\t[tweetText: \(self.unwrapOrDefault(self.tweetText))]" +
            "\n\t[timestamp: \(self.unwrapOrDefault(self.timestamp))]" +
            "\n\t[profileImageUrl: \(self.unwrapOrDefault(self.profileImageUrl))]"
    }
    
    func unwrapOrDefault(_ optionalStr: String?) -> String {
        return (optionalStr ?? "").isEmpty ? "" : optionalStr!
    }
}
