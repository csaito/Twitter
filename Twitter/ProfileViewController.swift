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
        
        self.user = User.currentUser
        self.profileTableView.estimatedRowHeight = 200
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    }
}
