//
//  Tweet.swift
//  Twitter
//

import Foundation

class Tweet : NSObject {
    //user profile picture, username, tweet text, and timestamp

    var tweetText: String?
    var timestamp: String?
    var displayUrl: String?
    var profileImageUrl: String?
    var userName: String?
    var screenName: String?
    var createdAt: NSDate
    var retweetCount: Int?
    var favoritesCount: Int?
    
    init(tweetDictionary: NSDictionary) {
        print("\(tweetDictionary)")
        if let user = tweetDictionary["user"] {
            self.profileImageUrl = (user as! NSDictionary)["profile_image_url"] as? String
            self.userName = (user as! NSDictionary)["name"] as? String
            self.screenName = (user as! NSDictionary)["screen_name"] as? String
        }
        self.tweetText = tweetDictionary["text"] as? String
        //self.timestamp = tweetDictionary["created_at"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.date(from: tweetDictionary["created_at"] as! String)! as NSDate
        
        self.retweetCount = tweetDictionary["retweet_count"] as? Int
        self.favoritesCount = tweetDictionary["favorite_count"] as? Int
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
    
    static let MINUTE = 60;
    static let HOUR = (MINUTE * 60);
    static let DAY = (HOUR * 24);
    static let WEEK = (DAY * 7);
    static let MONTH = (DAY * 31);
    static let YEAR = (DAY * 365);
    
    func getTimestampForDisplay() -> String {
        
        let now = NSDate()
        let secondsSinceNow = Int(now.timeIntervalSince(self.createdAt as Date))
        
        var prefix = 0
        var suffix = ""
        
        // Seconds
        if (secondsSinceNow < Tweet.MINUTE) {
            prefix = secondsSinceNow;
            suffix = "s";
        }
            // Minute
        else if (secondsSinceNow < Tweet.HOUR) {
            prefix = secondsSinceNow / Tweet.MINUTE;
            suffix = "m";
        }
            // Hour
        else if (secondsSinceNow < Tweet.DAY) {
            prefix = secondsSinceNow / Tweet.HOUR;
            suffix = "h";
        }
            // Day
        else if (secondsSinceNow < Tweet.WEEK) {
            prefix = secondsSinceNow / Tweet.DAY;
            suffix = "d";
        }
            // Week
        else if (secondsSinceNow < Tweet.MONTH) {
            prefix = secondsSinceNow / Tweet.WEEK;
            suffix = "w";
        }
            // Month
        else if (secondsSinceNow < Tweet.YEAR) {
            prefix = secondsSinceNow / Tweet.MONTH;
            suffix = "mo";
        }
            // Year
        else {
            prefix = secondsSinceNow / Tweet.YEAR;
            suffix = "y";
        }
        
        return "\(prefix) \(suffix)"
    }
}
