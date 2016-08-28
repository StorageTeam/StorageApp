//
//  DSSBuildingImgView.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuildingImgView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.buildingImgView)
        self.buildingImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(35)
            make.centerX.equalTo(self)
        }
        
        self.addSubview(self.tipLabel)
        self.tipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.buildingImgView.snp_bottom).offset(25)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var buildingImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "building_img_icon")
        return imgView
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x444444)
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.text = "功能正在建设中\n敬请期待~"
        return label
    }()
}
