//
//  RepositoryDetailViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: url)
        webview.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
