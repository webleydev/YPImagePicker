//
//  YPBottomPagerView.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 24/01/2018.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import UIKit
import Stevia

final class YPBottomPagerView: UIView {
    
    var header = YPPagerMenu()
    var scrollView = UIScrollView()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = UIColor(red: 239/255, green: 238/255, blue: 237/255, alpha: 1)
        
        sv(
            scrollView,
            header
        )
        
        layout(
            0,
            |scrollView|,
            0,
            |header|,
            0
        )
        
        let heightConstant: CGFloat = YPConfig.hidesBottomBar ? 0 : 100
        header.heightAnchor.constraint(lessThanOrEqualToConstant: heightConstant).isActive = true
        
        clipsToBounds = false
        setupScrollView()
    }

    private func setupScrollView() {
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
    }
}
