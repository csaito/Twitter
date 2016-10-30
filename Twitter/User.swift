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
    //var dictionary : NSDictionary?
    
    init(userDirectory: NSDictionary) {
        //self.dictionary = userDirectory
        self.profileImageUrl = userDirectory["profile_image_url"] as? String
        self.userName = userDirectory["name"] as? String
        self.screenName = userDirectory["screen_name"] as? String
        self.id = userDirectory["id"] as? Int
    }
    
    func getSubsetNSDictionary() -> NSDictionary {
        // the full NSDictionary from tweeter is in a format that is invalid
        // for serialization or for direct storage
        let dictionary: NSDictionary = [
            "profile_image_url" : self.profileImageUrl!,
            "name" : self.userName!,
            "screen_name" : self.screenName!,
            "id" : self.id!
        ]
        
        return dictionary
    }
    
    static var currentUser: User? {
        get {
            let userDictionary = UserDefaults.standard.object(forKey: "currentUser")
            if let userDictionary = userDictionary {
                return User(userDirectory: userDictionary as! NSDictionary)
            }
            return nil
        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                defaults.set(user.getSubsetNSDictionary(), forKey: "currentUser")
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
