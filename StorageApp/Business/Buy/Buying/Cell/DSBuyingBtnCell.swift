//
//  FKBuyingBtnCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSBuyingBtnCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.addAllSubviews();
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() {
        
        self.contentView.addSubview(self.buyButton)
        self.contentView.addSubview(self.failBtn)
        
        let btnW = (DSConst.UISCREENWIDTH - 20 * 3) / 2.0
        self.failBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(btnW, 44))
        }
        
        self.buyButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(btnW, 44))
        }
    }

    lazy var buyButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("采购成功", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var failBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("采购失败", forState: .Normal)
        button.setTitleColor(UIColor.init(rgb: 0x1fbad6), forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.layer.borderColor = UIColor.init(rgb: 0xcccccc).CGColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        return button
    }()
    
}
