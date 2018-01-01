//
//  UIView+Extension.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2018/01/01.
//  Copyright © 2018年 zizi4n5. All rights reserved.
//

import UIKit

extension UIView {

    internal func setSkeletonable(skeletonable: Bool) {
        subviews.forEach {
            if $0 is UILabel || $0 is UIImageView {
                $0.isSkeletonable = skeletonable
            } else {
                $0.setSkeletonable(skeletonable: skeletonable)
            }
        }
    }
}
