//
//  DSSBuySelectShopView.swift
//  StorageApp
//
//  Created by jack on 16/8/25.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuySelectShopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addAllSubviews()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.actionBtn)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-5)
        }
        
        self.arrowImgView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.titleLabel.snp_right).offset(5)
        }
        
        self.actionBtn.snp_makeConstraints { (make) in
            make.top.bottom.centerX.equalTo(self)
            make.width.equalTo(140)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(15)
        label.text = "全部"
        return label
    }()
    
    lazy var arrowImgView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "vert_arrow"))
        return imageView
    }()
    
    lazy var actionBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        return button
    }()

}
