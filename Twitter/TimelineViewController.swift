//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/27/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit
import AVFoundation

class TimelineViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.tweetTableView.dataSource = self
        self.tweetTableView.estimatedRowHeight = 100
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        self.retrieveTimeline();
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.tweetTableView.insertSubview(refreshControl, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutClicked(_ sender: AnyObject) {
        User.currentUser = nil
    }
    
    func retrieveTimeline() {
        if (self.tweets.count > 0) {
            let sinceId = self.tweets[0].id
            TwitterClient.sharedInstance.getTimeline(sinceId: sinceId!, completion: {
                (tweets: [Tweet], error: Error?) -> Void in
                if tweets.count > 0 {
                    self.tweets = tweets + self.tweets
                }
                self.refreshControl.endRefreshing()
                self.tweetTableView.reloadData()
            });
        } else {
            TwitterClient.sharedInstance.getTimeline(completion: {
                (tweets: [Tweet], error: Error?) -> Void in
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tweetTableView.reloadData()
            });
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTweetSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetViewController = navigationController.viewControllers[0] as! TweetViewController
            tweetViewController.tweet = (sender as! TweetTableViewCell).tweet
        }
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.retrieveTimeline()
    }
    
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
        if let tweet = (segue.source as! ComposeViewController).postedTweet {
            self.tweets.insert(tweet, at: 0)
            self.tweetTableView.reloadData()
        }
    }
    
    func requestMoreTweets() {
        let maxId = self.tweets[self.tweets.count-1].id
        TwitterClient.sharedInstance.getTimeline(maxId: maxId!, completion: {
            (tweets: [Tweet], error: Error?) -> Void in
            if (tweets.count > 0) {
                if (tweets[0].id != maxId) {
                    print("Wrong ID!!!!  received \(tweets[0].id), expected \(maxId)")
                }
                self.tweets.popLast()
                self.tweets.append(contentsOf: tweets)
                self.tweetTableView.reloadData()
            }
        });
    }

}

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets[indexPath.row]
        if (indexPath.row == self.tweets.count-1) {
            self.requestMoreTweets()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

protocol TweetProtocol {
    func getTweet() -> Tweet?
}
