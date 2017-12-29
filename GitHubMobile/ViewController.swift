//
//  ViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/27.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        GitHubClient.default.getRepositories(first: 10, after: "Y3Vyc29yOjEw")
        GitHubClient.default.getRepositories(first: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

