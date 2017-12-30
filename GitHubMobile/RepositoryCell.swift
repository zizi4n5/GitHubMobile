//
//  RepositoryCell.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
