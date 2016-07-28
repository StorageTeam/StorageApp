//
//  FKTakePhotoTopView.swift
//  StorageApp
//
//  Created by jack on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKTakePhotoTopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.addAllSubviews()
    }
    
    private func addAllSubviews() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
       let label = UILabel.init()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        return label
    }()
}
