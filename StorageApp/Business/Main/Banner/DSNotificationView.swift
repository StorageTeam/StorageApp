//
//  DSNotificationView.swift
//  StorageApp
//
//  Created by ascii on 16/9/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSNotificationView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.imgView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(36)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSizeMake(32, 32))
        }
        
        self.addSubview(self.textLabel)
        self.textLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp_right).offset(15)
            make.right.equalTo(self).offset(-45)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "order_alert_icon")
        return imgView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 2
        return label
    }()
}
