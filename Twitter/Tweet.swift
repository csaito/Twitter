//
//  Tweet.swift
//  Twitter
//

import Foundation

class Tweet : NSObject {
    //user profile picture, username, tweet text, and timestamp
    var profileImageUrl: String?
    var userName: String?
    var screenName: String?
    var tweetText: String?
    var timestamp: String?
    var displayUrl: String?
    
    init(tweetDictionary: NSDictionary) {
        print("\(tweetDictionary)")
        if let user = tweetDictionary["user"] {
            self.profileImageUrl = (user as! NSDictionary)["profile_image_url"] as? String
            self.userName = (user as! NSDictionary)["name"] as? String
            self.screenName = (user as! NSDictionary)["screen_name"] as? String
        }
        self.tweetText = tweetDictionary["text"] as? String
        self.timestamp = tweetDictionary["created_at"] as? String
        
        print("profileImageUrl \(self.profileImageUrl)")
        print("userName \(self.userName)");
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
    
    func getTimestampForDisplay() -> String {
        // Diff the current time with tweet created time.
        // 1. If diff is less than a minute - return seconds
        // 2. If diff is less than an hour - return minutes
        // 3. If diff is less than a day - return hours
        // 4. If diff is less than 3 days - return date
        // Otherwise retun dd mm
        
        return "14h" // FIXME
    }
}
