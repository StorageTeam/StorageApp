//
//  DSSSlideHeaderView.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSSlideHeaderView: UIView {
    static let HEADER_LENGTH: CGFloat = 45.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.headerView)
        self.headerView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-15)
            make.size.equalTo(CGSizeMake(DSSSlideHeaderView.HEADER_LENGTH, DSSSlideHeaderView.HEADER_LENGTH))
        }
        
        self.addSubview(self.nicknameLabel)
        self.nicknameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.headerView.snp_right).offset(12)
            make.centerY.equalTo(self.headerView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Property
    
    lazy var headerView: UIImageView = {
        var view = UIImageView.init()
        view.layer.cornerRadius = DSSSlideHeaderView.HEADER_LENGTH/2.0
        view.backgroundColor = UIColor.grayColor()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0xffffff)
        label.font = UIFont.systemFontOfSize(16)
        label.text = "test"
        return label
    }()
}
