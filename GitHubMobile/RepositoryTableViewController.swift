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

fileprivate let firstPageSize = 50
fileprivate let nextPageSize = 20
fileprivate let pageLoadThreshold = 30

class RepositoryTableViewController: UITableViewController, HidingNavigationBarManagerDelegate {

    internal var github: GitHubClient!
    internal var user: GitHubUser!

    private var hidingNavBarManager: HidingNavigationBarManager?
    
    var pageInfo: GitHubPageInfo?
    var repositories = [GitHubRepository?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarTitle()
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.delegate = self
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(RepositoryTableViewController.refresh(sender:)), for: .valueChanged)
        
        repositories = [GitHubRepository?](repeating: nil, count: firstPageSize)
        loadRepositories(first: firstPageSize)
        tableView.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        loadRepositories(first: firstPageSize)
    }
    
    let downloader = ImageDownloader()
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
        
        let avatarSize = CGSize(width: 40.0, height: 40.0)
        let filter = AspectScaledToFillSizeCircleFilter(size: avatarSize)
        downloader.download(URLRequest(url: URL(string:user.avatarUrl)!), filter: filter) { response in
            if let image = response.result.value {
                let avatarButton = UIButton(frame: CGRect(origin: CGPoint(), size: avatarSize))
                avatarButton.setBackgroundImage(image, for: .normal)
//                avatarButton.addTarget(self, action: #selector(RepositoryTableViewController.handleMore), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarButton)
            }
        }
    }
    
    func loadRepositories(first: Int, after: GitHubPageInfo? = nil) {

        guard let github = github else {
            self.refreshControl?.endRefreshing()
            return
        }
        
        github.getRepositories(first: first, after: after)  { (pageInfo, repositories, error) in

            if let error = error {
                print("Error: \(error)");
                return
            }
            
            // ページ情報の更新
            self.pageInfo = pageInfo

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
                guard repositories[0]?.nameWithOwner == "Alamofire/Alamofire" else {
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
            loadRepositories(first: nextPageSize, after: pageInfo)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let _ = repositories[indexPath.row] {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = repositories[indexPath.row] {
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
            detailVC.url = URL(string: repository.url)!
        }
    }
}
