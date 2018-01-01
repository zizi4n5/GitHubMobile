//
//  RepositoryDetailViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import SkeletonView
import HidingNavigationBar

class RepositoryDetailViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate, HidingNavigationBarManagerDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var skeletonView: UIView!
    
    private var hidingNavBarManager: HidingNavigationBarManager?
    internal var repositoryName: String!
    internal var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = repositoryName
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: webview.scrollView)
        hidingNavBarManager?.delegate = self
        
        skeletonView.setSkeletonable(skeletonable: true)
        skeletonView.showAnimatedGradientSkeleton()
        
        let request = URLRequest(url: url)
        webview.delegate = self
        webview.scrollView.delegate = self
        webview.loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidingNavBarManager?.viewWillDisappear(animated)
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
    
    
    // MARK: UITableViewDelegate
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    
    // MARK: - HidingNavigationBarManagerDelegate
    
    func hidingNavigationBarManagerDidChangeState(_ manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        
    }
    
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(_ manager: HidingNavigationBarManager) {
        
    }
    
    func hidingNavigationBarManagerShouldUpdateScrollViewInsets(_ manager: HidingNavigationBarManager, insets: UIEdgeInsets) -> Bool {
        return false
    }
}
