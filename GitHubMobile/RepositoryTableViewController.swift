//
//  RepositoryTableViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import AlamofireImage
import SkeletonView

class RepositoryTableViewController: UITableViewController {

    private let firstPageSize = 50
    private let nextPageSize = 20
    private let pageLoadThreshold = 30
    var repositories: [GitHubRepository]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositories = [GitHubRepository](repeating: GitHubRepository(), count: firstPageSize)

        refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(RepositoryTableViewController.refresh(sender:)), for: .valueChanged)
        
        loadRepositories(first: firstPageSize)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        loadRepositories(first: firstPageSize)
    }
    
    func loadRepositories(first: Int, after: GitHubRepository? = nil) {

        GitHubClient.default.getRepositories(first: first, after: after)  { (totalCount, repositories, error) in

            if let error = error {
                print("Error: \(error)");
                return
            }
            
            if let _ = after {
                self.repositories.append(contentsOf: repositories)
            } else {
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
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }

        tableView.flashScrollIndicators()
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
        
        // 下部までスクロールした場合、前もって次のデータを読み込む
        if !GitHubClient.default.isLoading && indexPath.row > repositories.count - pageLoadThreshold {
            loadRepositories(first: nextPageSize, after: repositories.last)
        }
        
        if let _ = repositories[indexPath.row].url {
            cell.hideSkeleton()
            UIView.animate(withDuration: 3.0) {
                cell.avatarImage.image = nil
                cell.avatarImage.af_setImage(withURL: self.repositories[indexPath.row].owner.avatarUrl)
                cell.nameWithOwner.text = self.repositories[indexPath.row].nameWithOwner
                cell.shortDescriptionHTML.attributedText = self.repositories[indexPath.row].shortDescriptionHTML
            }
        } else {
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)
            cell.showAnimatedGradientSkeleton(animation: animation)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenRepositoryDetail", sender: repositories[indexPath.row].url)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? RepositoryDetailViewController, let url = sender as? URL {
            detailVC.url = url
        }
    }

}
