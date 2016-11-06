//
//  MenuViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    let menuItems = [ "timeline", "mentions" ]
    
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var rootViewController: RootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.profileNavigationController = storyboard.instantiateViewController(withIdentifier:
            "ProfileNavigationController")
        self.timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        self.mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        
        let mentionsVC = (self.mentionsNavigationController as! UINavigationController).viewControllers[0] as! TimelineViewController
        mentionsVC.isMentionsTimeline = true
        
        self.viewControllers.append(profileNavigationController)
        self.viewControllers.append(timelineNavigationController)
        self.viewControllers.append(mentionsNavigationController)
        
        rootViewController?.contentViewController = timelineNavigationController
        
        self.menuTableView.estimatedRowHeight = 200
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuTableViewCell", for: indexPath) as! ProfileMenuTableViewCell
            cell.user = User.currentUser
            returnCell = cell
            break
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
            cell.textLabel?.text = self.menuItems[indexPath.row]
            returnCell = cell
            break
        default: break
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.menuItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) {
            rootViewController?.contentViewController = viewControllers[0]
        } else {
            rootViewController?.contentViewController = viewControllers[(indexPath as NSIndexPath).row+1]
        }
    }
}

