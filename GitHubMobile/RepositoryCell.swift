//
//  RepositoryCell.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import GitHubClient
import SkeletonView

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameWithOwner: UILabel!
    @IBOutlet weak var shortDescriptionHTML: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setSkeletonable(skeletonable: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(repository: GitHubRepository?) {
        if let repository = repository {
            avatarImage.image = nil
            avatarImage.af_setImage(withURL: URL(string: repository.owner.avatarUrl)!)
            nameWithOwner.text = repository.nameWithOwner
            shortDescriptionHTML.attributedText = repository.shortDescriptionHtml.convertHtml()
            stars.text = repository.stargazers.totalCount < 1000 ? "★ \(repository.stargazers.totalCount)" :
            "★ \(String(format: "%.1f", Float(repository.stargazers.totalCount) / 1000))k"
            hideSkeleton()
        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
