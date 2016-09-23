//
//  DSEmptyView.swift
//  StorageApp
//
//  Created by ascii on 16/9/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSEmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.buildingImgView)
        self.buildingImgView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(35)
            make.centerX.equalTo(self)
        }
        
        self.addSubview(self.tipLabel)
        self.tipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.buildingImgView.snp_bottom).offset(11)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var buildingImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "buy_mission_empty_icon")
        return imgView
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
    }()


}
