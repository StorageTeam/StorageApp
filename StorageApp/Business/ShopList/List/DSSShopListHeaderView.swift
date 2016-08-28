//
//  DSSShopListHeaderView.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSShopListHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.leftImgIcon)
        self.leftImgIcon.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(self.tipLabel)
        self.tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.leftImgIcon.snp_right).offset(6)
            make.centerY.equalTo(self.leftImgIcon)
        }
        
        self.addSubview(self.actionButton)
        self.actionButton.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Property
    
    lazy var leftImgIcon: UIImageView = {
        var view = UIImageView.init()
        view.image = UIImage.init(named: "tip_location_icon")
        return view
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0xffffff)
        label.font = UIFont.systemFontOfSize(14)
        label.text = "选择商品收集地点"
        return label
    }()
    
    lazy var actionButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.setImage(UIImage.init(named: "close_location_icon"), forState: .Normal)
        return button
    }()
}
