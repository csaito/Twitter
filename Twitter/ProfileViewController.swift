//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 11/5/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let menuItems = ["One", "Two", "Three"]
    var user : User?
    @IBOutlet weak var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User.currentUser
        print("current user: \(self.user)")
        self.profileTableView.estimatedRowHeight = 200
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath)
            //cell.textLabel?.text = self.menuItems[indexPath.row]
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
        return 1
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
