//
//  User.swift
//  Twitter
//


import Foundation
class User : NSObject {
    var profileImageUrl: String?
    var userName: String?
    var screenName: String?
    var dictionary : NSDictionary?
    
    init(userDirectory: NSDictionary) {
        self.dictionary = userDirectory
        self.profileImageUrl = userDirectory["profile_image_url"] as? String
        self.userName = userDirectory["name"] as? String
        self.screenName = userDirectory["screen_name"] as? String
    }
    
    static var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userData = userData {
                let dictonary = try!
                    JSONSerialization.jsonObject(with: userData, options: [])
                return User(userDirectory: dictonary as! NSDictionary)
            } else {
                return nil
            }
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: []);
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
            
            if (user == nil) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: self)
            }
        }
    }
}
