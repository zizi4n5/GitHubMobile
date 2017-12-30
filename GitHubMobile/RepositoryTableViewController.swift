//
//  RepositoryTableViewController.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import AlamofireImage

class RepositoryTableViewController: UITableViewController {

    var numberOfRowsInSection = 0;
    var repositories = [GitHubRepository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(RepositoryTableViewController.refresh(sender:)), for: .valueChanged)
        
        reloadRepositories()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        reloadRepositories()
    }
    
    func reloadRepositories() {
        GitHubClient.default.getRepositories(first: 50)  { (repositories, error) in
            self.repositories.removeAll()
            self.repositories.append(contentsOf: repositories)
            self.numberOfRowsInSection = self.repositories.count
        GitHubClient.default.getRepositories(first: 10)  { (repositories, error) in
            
            // スターでのsortを指定しているにも関わらず、稀に正しくソートされていない結果が返却されてくる場合がある。
            // 本現象はGitHubが提供しているGraphQL Explorer(https://developer.github.com/v4/explorer/)でも再現確認できたため、
            // GitHubのgraphQL API のバグの可能性あり。
            // このため、暫定的に以下の対応を実施。
            //  1. 取得した値の1番目がダントツ１位のAlamofireかチェックして異なる場合はリトライを行う
            //  2. GitHubClient.getRepositoriesでCacheを利用しないように設定を変更
            guard repositories[0].nameWithOwner == "Alamofire/Alamofire" else {
                self.reloadRepositories()
                return
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
        return numberOfRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryCell
        cell.avatarImage.image = nil
        cell.avatarImage.af_setImage(withURL: repositories[indexPath.row].owner.avatarUrl)
        cell.nameWithOwner.text = repositories[indexPath.row].nameWithOwner
        cell.shortDescriptionHTML.attributedText = repositories[indexPath.row].shortDescriptionHTML
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
