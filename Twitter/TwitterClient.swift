//
//  TwitterClient.swift
//  Twitter
//

import Foundation
import BDBOAuth1Manager

let baseUrlString = "https://api.twitter.com"
let consumerKey = "c5NUWp3Mc4ixfqtqneEcHNs9Q"
let consumerSecret = "8qjdoXPxS8yLnLO8px0FpIVk42MsskYgFvtv8F9saA2kGiCICO"

enum TwitterClientStatus: Int {
    case success = 0, failure
}


class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletionHandler: ((TwitterClientStatus, Error?) -> Void)?
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: baseUrlString)!, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    override init(baseURL: URL, consumerKey key: String!, consumerSecret secret: String!) {
        super.init(baseURL: baseURL, consumerKey: key, consumerSecret: secret);
        //self.deauthorize()
    }
    
    func login(login: String, completion: @escaping (TwitterClientStatus, Error?) -> Void) -> Void {
        
        //completion(TwitterLoginStatus.success, nil)
        self.fetchRequestToken(withPath: "oauth/request_token", method: "GET",
                                         callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success:{ (credential: BDBOAuth1Credential?) -> Void in                                            if let credential = credential {
                                                if let token = credential.token {
                                                    let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)&screen_name=\(login)")!
                                                    self.loginCompletionHandler = completion
                                                    UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
                                                }
                                            }
            }, failure: { (error: Error? ) -> Void in
                print("error \(error)")
                completion(TwitterClientStatus.failure, error)
        })
 
    }
    
    func loginCallback(query: String) {
        let requestToken = BDBOAuth1Credential(queryString: query)
        let storedCompletionHandler = self.loginCompletionHandler
        self.loginCompletionHandler = nil
        
        self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (token: BDBOAuth1Credential?) -> Void  in
                print("Got access token!")
                if let token = token {
                    let status = self.requestSerializer.saveAccessToken(token)
                    print("keyChain storage status \(status)")
                }
                storedCompletionHandler?(TwitterClientStatus.success, nil)
                self.verifyUser()
            }, failure:{ (error: Error?) in
                print("error: \(error!.localizedDescription)")
                storedCompletionHandler?(TwitterClientStatus.failure, error)
        })
    }
    
    func verifyUser() {
        self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
                 success:
            { (task:URLSessionDataTask, response:Any?) -> Void in
                let user = User(userDirectory: response as! NSDictionary)
                User.currentUser = user
                print("currentUser \(User.currentUser)")
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    
    func getTimeline(completion: @escaping ([Tweet], Error?) -> Void) -> Void {
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
                 success:
            { (task:URLSessionDataTask, response:Any?) -> Void in
                let tweets = response as! [NSDictionary]
                var tweetArray = [Tweet]()
                for tweet in tweets {
                    tweetArray.append(Tweet(tweetDictionary: tweet))
                }
                completion(tweetArray, nil)
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
                completion([Tweet](), error)
        })
    }
    
    func updateStatus(_ tweet : String, completion: @escaping (Tweet?, Error?) -> Void) -> Void {
        let param: NSDictionary = [
            "status" : tweet
        ]
        self.post("1.1/statuses/update.json", parameters: param, success:
            {(task:URLSessionDataTask, response:Any?) -> Void in
                let tweet = response as! NSDictionary
                print("post success \(tweet)")
                completion(Tweet(tweetDictionary: tweet), nil)
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
                completion(nil, error)
        });
    }
    
    func likeStatus(_ tweetId : Int, completion: @escaping (Tweet?, Error?) -> Void) -> Void {
        let param: NSDictionary = [
            "id" : tweetId
        ]
        self.post("1.1/favorites/create.json", parameters: param, success:
            {(task:URLSessionDataTask, response:Any?) -> Void in
                let tweet = response as! NSDictionary
                print("post success \(tweet)")
                completion(Tweet(tweetDictionary: tweet), nil)
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
                completion(nil, error)
        });
    }
    
    func retweetStatus(_ tweetId : Int, completion: @escaping (Tweet?, Error?) -> Void) -> Void {
        let param: NSDictionary = [
            "id" : tweetId
        ]
        self.post("1.1/statuses/retweet/\(tweetId).json", parameters: param, success:
            {(task:URLSessionDataTask, response:Any?) -> Void in
                let tweet = response as! NSDictionary
                print("post success \(tweet)")
                completion(Tweet(tweetDictionary: tweet), nil)
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
                completion(nil, error)
        });
    }
    
    func replyToStatus(_ tweet : String, tweetId: Int, completion: @escaping (Tweet?, Error?) -> Void) -> Void {
        let param: NSDictionary = [
            "status" : tweet,
            "in_reply_to_status_id": tweetId
        ]
        self.post("1.1/statuses/update.json", parameters: param, success:
            {(task:URLSessionDataTask, response:Any?) -> Void in
                let tweet = response as! NSDictionary
                print("post success \(tweet)")
                completion(Tweet(tweetDictionary: tweet), nil)
            }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
                print("error: \(error.localizedDescription)")
                completion(nil, error)
        });
    }
}
