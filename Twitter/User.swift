//
//  User.swift
//  Twitter
//


import Foundation
class User : NSObject {
    var profileImageUrl: String?
    var userName: String?
    var screenName: String?
    var id : Int?
    var following: Int?
    var followers: Int?
    var backgroundImageUrl: String?
    var dictionary : NSDictionary?
    
    init(userDirectory: NSDictionary) {
        self.dictionary = userDirectory
        self.profileImageUrl = userDirectory["profile_image_url"] as? String
        self.userName = userDirectory["name"] as? String
        self.screenName = userDirectory["screen_name"] as? String
        self.id = userDirectory["id"] as? Int
        self.following = userDirectory["friends_count"] as? Int
        self.followers = userDirectory["followers_count"] as? Int
        self.backgroundImageUrl = userDirectory["profile_background_image_url"] as? String
    }

    static var currentUser: User? {
        get {
            let data = UserDefaults.standard.data(forKey: "currentUser")
            if let data = data {
                let userDictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let userDictionary = userDictionary as? NSDictionary {
                    return User(userDirectory: userDictionary)
                }
            }
            return nil
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: []) as NSData
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
            
            if (user == nil) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: self)
            }
        }
    }
}
