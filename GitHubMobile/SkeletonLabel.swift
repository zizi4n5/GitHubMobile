//
//  SkeletonLabel.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/31.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import SkeletonView

fileprivate let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)

class SkeletonLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSkeletonable = true
        
        showAnimatedGradientSkeleton(animation: animation)
    }
}
