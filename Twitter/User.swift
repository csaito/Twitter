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
    var dictionary : NSDictionary?
    
    init(userDirectory: NSDictionary) {
        self.dictionary = userDirectory
        self.profileImageUrl = userDirectory["profile_image_url"] as? String
        self.userName = userDirectory["name"] as? String
        self.screenName = userDirectory["screen_name"] as? String
        self.id = userDirectory["id"] as? Int
    }
    
    static var currentUser: User? {
        get {
            let id = UserDefaults.standard.integer(forKey: "currentUserId")
            print("got userId \(id)")
            if id > 0 {
                return User(userDirectory: NSDictionary())
            }
            return nil
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                print("storing userId \(user.id!)")
                let id = user.id!
                defaults.set(id, forKey: "currentUserId")
            } else {
                defaults.set(0, forKey: "currentUserId")
            }
            defaults.synchronize()
            
            if (user == nil) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: self)
            }
        }
    }
}
