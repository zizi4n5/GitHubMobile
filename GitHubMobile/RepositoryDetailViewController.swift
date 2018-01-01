//
//  RepositoryDetailViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import SkeletonView
import AMScrollingNavbar

class RepositoryDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var skeletonView: UIView!
    
    var repositoryName: String!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonView.setSkeletonable(skeletonable: true)
        skeletonView.showAnimatedGradientSkeleton()
        navigationItem.title = repositoryName

        let request = URLRequest(url: url)
        webview.delegate = self
        webview.loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(webview)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView(showingNavbar: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let str = webView.request?.url?.absoluteString ?? ""
        print(#function + " URL:" + str)
        
        let animations = {
            self.skeletonView.alpha = 0
        }
        
        let completion = { (finished: Bool) in
            self.skeletonView.hideSkeleton()
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: animations,
                       completion: completion)
    }
}
