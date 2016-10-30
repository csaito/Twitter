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
        TwitterClient.sharedInstance.getTimeline(completion: {
            (tweets: [Tweet], error: Error?) -> Void in
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tweetTableView.reloadData()
        });
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTweetSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetViewController = navigationController.viewControllers[0] as! TweetViewController
            tweetViewController.tweet = (sender as! TweetTableViewCell).tweet
        }
        /**
        if segue.identifier == "ComposeUpdateSegue" {
            let navigationController = segue.destination as! UINavigationController
            let composeViewController = navigationController.viewControllers[0] as! ComposeViewController
            self.tweetVc = composeViewController as TweetProtocol
            // Don't really have to do anything...
        } else {
            if let tweet = self.tweetVc?.getTweet() {
                self.tweets.insert(tweet, at: 0)
                self.tweetTableView.reloadData()
            }
        }
 **/
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

}

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets[indexPath.row]
        print("tweet \(cell.tweet)");
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
