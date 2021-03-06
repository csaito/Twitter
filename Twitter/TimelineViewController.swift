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
    
    var isMentionsTimeline = false
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.isMentionsTimeline ? "Mentions" : "Home"
        self.tweetTableView.dataSource = self
        //self.tweetTableView.delegate = self
        self.tweetTableView.estimatedRowHeight = 100
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "TimelineItemTableViewCell", bundle: nil)
        self.tweetTableView.register(nib, forCellReuseIdentifier: "TimelineItemTableViewCell")
        
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
    
    func getTimelineFunc() -> (NSDictionary, @escaping ([Tweet], Error?) -> Void) -> Void {
        if (self.isMentionsTimeline) {
            return TwitterClient.sharedInstance.getMentionsTimeline
        } else {
            return TwitterClient.sharedInstance.getTimeline
        }
    }
    
    func retrieveTimeline() {
        let param: NSMutableDictionary = [
            "count" : 50
        ]
        if (self.tweets.count > 0) {
            let sinceId = self.tweets[0].id
            param["sinceId"] = sinceId
        }
        self.getTimelineFunc()(param, {
            (tweets: [Tweet], error: Error?) -> Void in
            if tweets.count > 0 {
                self.tweets = tweets + self.tweets
            }
            self.refreshControl.endRefreshing()
            self.tweetTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTweetSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetViewController = navigationController.viewControllers[0] as! TweetViewController
            tweetViewController.tweet = (sender as! TimelineItemTableViewCell).tweet
        } else if segue.identifier == "ViewProfileSegue" {
            let navigationController = segue.destination as! UINavigationController
            let profileViewController = navigationController.viewControllers[0] as! ProfileViewController
            profileViewController.user = (sender as! TimelineItemTableViewCell).tweet?.user
        }
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.retrieveTimeline()
    }
    
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
        if (segue.identifier == "ComposeUnwindSegue") {
            if let tweet = (segue.source as! ComposeViewController).postedTweet {
                self.tweets.insert(tweet, at: 0)
                self.tweetTableView.reloadData()
            }
        }
    }
    
    func requestMoreTweets() {
        let maxId = self.tweets[self.tweets.count-1].id
        let param: NSDictionary = [
            "count" : 50,
            "maxId" : maxId!
        ]
        self.getTimelineFunc()(param, {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineItemTableViewCell", for: indexPath) as! TimelineItemTableViewCell
        cell.selectionDelegate = self
        cell.tweet = self.tweets[indexPath.row]
        if (indexPath.row == self.tweets.count-1 && !self.isMentionsTimeline) {
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

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ViewTweetSegue", sender: tableView.cellForRow(at: indexPath))
    }
}

extension TimelineViewController: TimelineItemSelected {
    
    func tweetSelected(selected: TimelineItemTableViewCell) {
        self.performSegue(withIdentifier: "ViewTweetSegue", sender: selected)
    }
    
    func profileSelected(selected: TimelineItemTableViewCell) {
        self.performSegue(withIdentifier: "ViewProfileSegue", sender: selected)
    }
}
