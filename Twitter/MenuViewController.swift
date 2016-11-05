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
    
    private var timelineNativationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var rootViewController: RootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.timelineNativationController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        self.mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        
        let mentionsVC = (self.mentionsNavigationController as! UINavigationController).viewControllers[0] as! TimelineViewController
        mentionsVC.isMentionsTimeline = true
        
        self.viewControllers.append(timelineNativationController)
        self.viewControllers.append(mentionsNavigationController)
        
        rootViewController?.contentViewController = timelineNativationController
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)
        cell.textLabel?.text = self.menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rootViewController?.contentViewController = viewControllers[(indexPath as NSIndexPath).row]
    }
}

