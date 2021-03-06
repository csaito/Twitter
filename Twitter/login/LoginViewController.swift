//
//  LoginViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/27/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance.login(login: "chihiro.saito@gmail.com", completion: {
            (status: TwitterClientStatus, error: Error?) -> Void in
            if (status == TwitterClientStatus.success) {
                print("successfully logged in")
                self.performSegue(withIdentifier: "DisplayTimelineSegue", sender: self)
            } else {
                var errorString = "Could not complete the login process."
                if let error = error {
                    errorString = error.localizedDescription
                }
                self.showAlert(errorTitle: "Login error", errorString: errorString)
            }
        })
    }
    
    func showAlert(errorTitle: String, errorString: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorString, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true) {}
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = segue.destination as! RootViewController
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.rootViewController = rootViewController
        rootViewController.menuViewController = menuViewController
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
