//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/27/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetTableView.dataSource = self
        self.tweetTableView.estimatedRowHeight = 100
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        self.retrieveTimeline();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveTimeline() {
        TwitterClient.sharedInstance.getTimeline(completion: {
            (tweets: [Tweet], error: Error?) -> Void in
                self.tweets = tweets
                self.tweetTableView.reloadData()
            });
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

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
}
