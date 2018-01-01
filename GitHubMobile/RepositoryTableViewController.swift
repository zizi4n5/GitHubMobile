//
//  RepositoryTableViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import GitHubClient
import AlamofireImage
import FDFullscreenPopGesture
import HidingNavigationBar
import KeychainAccess
import OAuthSwift

fileprivate let firstPageSize = 50
fileprivate let nextPageSize = 20
fileprivate let pageLoadThreshold = 30

class RepositoryTableViewController: UITableViewController, HidingNavigationBarManagerDelegate {

    private let github = GitHubClient(token: "f8cf3573a35ce4807a525348215c72d3a29e3bbe") // 今回はプライベートアクセストークンを利用してGitHubにアクセスする

    let oauthswift = OAuth2Swift(
        consumerKey:    "4dd6e2ec2e03119aa7bd",
        consumerSecret: "6e1847dac03635fa3d0e9de2c28c86f57f4d38b0",
        authorizeUrl:   "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType:   "token"
    )
    
    private var hidingNavBarManager: HidingNavigationBarManager?
    var repositories: [GitHubRepository]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarTitle()
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.delegate = self
        
        repositories = [GitHubRepository](repeating: GitHubRepository(), count: firstPageSize)
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(RepositoryTableViewController.refresh(sender:)), for: .valueChanged)
        
        loadRepositories(first: firstPageSize)
    }
    
    @IBAction func login(_ sender: Any) {
        
        let state = generateState(withLength: 20)
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "zizi4n5githubmobile://oauth-callback")!, scope: "repo", state: state,
            success: { credential, response, parameters in
                self.github = GitHubClient(token: credential.oauthToken)
                self.loadRepositories(first: firstPageSize)
        },
            failure: { error in
                // TODO エラーメッセージ
        }
        )
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        loadRepositories(first: firstPageSize)
    }
    
    func setNavigationBarTitle() {

        let naviLabel = UILabel()
        let naviTitle = NSMutableAttributedString(string: "", attributes: [.foregroundColor: UIColor.black,
                                                                                        .font: UIFont(name: "devicon", size: 30)!])
        naviTitle.append(NSMutableAttributedString(string: " ★ ", attributes: [.foregroundColor: UIColor.darkGray,
                                                                               .font: UIFont(name: "devicon", size: 20)!]))
        naviTitle.append(NSMutableAttributedString(string: "", attributes: [.foregroundColor: UIColor(hexString: "#FE542B")!,
                                                                                         .font: UIFont(name: "devicon", size: 30)!]))
        naviLabel.attributedText = naviTitle
        naviLabel.textAlignment = .justified
        navigationItem.titleView = naviLabel
        navigationItem.titleView?.sizeToFit()
    }
    
    func loadRepositories(first: Int, after: GitHubRepository? = nil) {

        github.getRepositories(first: first, after: after)  { (totalCount, repositories, error) in

            if let error = error {
                print("Error: \(error)");
                return
            }

            // 追加データ読込の場合
            if let _ = after {
                // 追加データが存在しない場合は何もしない
                if repositories.count == 0 {
                    return
                }
                
                self.repositories.append(contentsOf: repositories)
                
            }
            // refreshまたは初回読込の場合
            else {
                // スターでのsortを指定しているにも関わらず、稀に正しくソートされていない結果が返却されてくる場合がある。
                // 本現象はGitHubが提供しているGraphQL Explorer(https://developer.github.com/v4/explorer/)でも再現確認できたため、
                // GitHubのgraphQL API のバグの可能性あり。
                // このため、暫定的に以下の対応を実施。
                //  1. 取得した値の1番目がダントツ１位のAlamofireかチェックして異なる場合はリトライを行う
                //  2. GitHubClient.getRepositoriesでCacheを利用しないように設定を変更
                guard repositories[0].nameWithOwner == "Alamofire/Alamofire" else {
                    self.loadRepositories(first: first)
                    return
                }
                
                self.repositories = repositories
                self.refreshControl?.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)

        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }

        tableView.flashScrollIndicators()
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryCell
        cell.initialize(repository: repositories[indexPath.row])

        // 下部までスクロールした場合、前もって次のデータを読み込む
        if !github.isLoading && indexPath.row > repositories.count - pageLoadThreshold {
            loadRepositories(first: nextPageSize, after: repositories.last)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let _ = repositories[indexPath.row].url {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = repositories[indexPath.row].url {
            performSegue(withIdentifier: "OpenRepositoryDetail", sender: repositories[indexPath.row])
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
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
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? RepositoryDetailViewController, let repository = sender as? GitHubRepository {
            detailVC.repositoryName = repository.name
            detailVC.url = repository.url
        }
    }
}
