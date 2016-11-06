//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Chihiro Saito on 10/29/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var charRemainingLabel: UILabel!
    
    let maxCharCount = 140
    
    var postedTweet: Tweet?
    
    var remainingCharCount = 0 {
        didSet {
            self.charRemainingLabel.text = String(remainingCharCount)
        }
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweetPressed(_ sender: AnyObject) {
        let tweetToPost = statusTextView.text
        
        TwitterClient.sharedInstance.updateStatus(tweetToPost!) { (tweet: Tweet?, error: Error?) in
            if let tweet = tweet {
                print("tweet posted \(tweet)")
                self.postedTweet = tweet
                self.performSegue(withIdentifier: "ComposeUnwindSegue", sender: self)
            }
            if let error = error {
                print("tweet post error \(error)")
                self.showAlert(errorTitle: "Error", errorString: error.localizedDescription)
            }
        }
    
    }
    
    func showAlert(errorTitle: String, errorString: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorString, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil)
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = User.currentUser
        if let imageUrl = currentUser?.profileImageUrl {
            self.profileImageView.setImageWith(URL(string: imageUrl)!)
        } else {
            self.profileImageView.image = nil
        }
        self.screenNameLabel.text = currentUser?.userName
        self.nameLabel.text = currentUser?.screenName
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true;
        
        statusTextView.text = ""
        self.remainingCharCount = maxCharCount
        self.statusTextView.delegate = self
        statusTextView.becomeFirstResponder()
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

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.remainingCharCount = self.maxCharCount - textView.text.characters.count
    }
}
