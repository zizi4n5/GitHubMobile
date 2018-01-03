//
//  LoginViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2018/01/03.
//  Copyright © 2018年 zizi4n5. All rights reserved.
//

import UIKit
import GitHubClient
import KeychainAccess

class LoginViewController: UIViewController {

    let keychain = Keychain()
    
    @IBOutlet weak var signIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = keychain["github.token"] {
            self.performSegue(withIdentifier: "OpenRepositoryList", sender: token)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.signIn.alpha = 1.0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: Any) {
        
        GitHubClient.login() { (token, error) in
            guard let token = token else {
                // TODO Error Message
                print(error!)
                return
            }

            let github = GitHubClient(token: token)
            github.getLoginUser { (user, error) in
                guard let user = user else {
                    // TODO Error Message
                    print(error!)
                    return
                }
                
                self.keychain["github.token"] = token
                self.performSegue(withIdentifier: "OpenRepositoryList", sender: (github, user))
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination.childViewControllers.first as? RepositoryTableViewController, let (github, user) = sender as? (GitHubClient, GitHubUser) {
            detailVC.github = github
            detailVC.user = user
        }
    }
}
