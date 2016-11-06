//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var tweets = [Tweet]()
    var user : User?
    @IBOutlet weak var profileTableView: UITableView!
    var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.user == nil) {
            self.user = User.currentUser
        }
        self.profileTableView.estimatedRowHeight = 200
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.dataSource = self
        //self.profileTableView.delegate = self
        
        self.title = "Profile"
        
        let nib = UINib(nibName: "TimelineItemTableViewCell", bundle: nil)
        self.profileTableView.register(nib, forCellReuseIdentifier: "TimelineItemTableViewCell")
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.profileTableView.insertSubview(refreshControl, at: 0)
        
        retrieveTimelineForUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveTimelineForUser() {
        if let user = self.user {
            if let userId = user.id {
                TwitterClient.sharedInstance.getUserTimeline(userId: userId, completion: { (tweets: [Tweet], error: Error?) in
                    if tweets.count > 0 {
                        self.tweets = tweets + self.tweets
                    }
                    self.refreshControl.endRefreshing()
                    self.profileTableView.reloadData()
                })
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.retrieveTimelineForUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTweetFromProfileSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetViewController = navigationController.viewControllers[0] as! TweetViewController
            tweetViewController.tweet = (sender as! TimelineItemTableViewCell).tweet
        }
    }
    
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
        //self.dismiss(animated: true, completion: nil)
    }

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.user = self.user
            returnCell = cell
            break
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineItemTableViewCell", for: indexPath) as! TimelineItemTableViewCell
            cell.tweet = self.tweets[indexPath.row]
            cell.selectionDelegate = self
            returnCell = cell
            break
        default: break
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.tweets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            self.performSegue(withIdentifier: "ViewTweetFromProfileSegue", sender: tableView.cellForRow(at: indexPath))
        }
    }
}

extension ProfileViewController: TimelineItemSelected {
    
    func tweetSelected(selected: TimelineItemTableViewCell) {
        self.performSegue(withIdentifier: "ViewTweetFromProfileSegue", sender: selected)
    }
    
    func profileSelected(selected: TimelineItemTableViewCell) {
    }
}
