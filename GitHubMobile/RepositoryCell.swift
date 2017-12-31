//
//  RepositoryCell.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import SkeletonView

fileprivate let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameWithOwner: UILabel!
    @IBOutlet weak var shortDescriptionHTML: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage.isSkeletonable = true
        nameWithOwner.isSkeletonable = true
        shortDescriptionHTML.isSkeletonable = true
        stars.isSkeletonable = true
        showAnimatedGradientSkeleton(animation: animation)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(repository: GitHubRepository) {
        if let _ = repository.url {
            avatarImage.image = nil
            avatarImage.af_setImage(withURL: repository.owner.avatarUrl)
            nameWithOwner.text = repository.nameWithOwner
            shortDescriptionHTML.attributedText = repository.shortDescriptionHTML
            stars.text = repository.stargazersTotalCount < 1000 ? "★ \(repository.stargazersTotalCount)" :
            "★ \(String(format: "%.1f", Float(repository.stargazersTotalCount) / 1000))k"
            hideSkeleton()
        } else {
            showAnimatedGradientSkeleton(animation: animation)
        }
    }
}
