//
//  FKBuyingProCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSBuyingProCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.addAllSubviews();
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() {
        
        self.contentView.addSubview(self.proImgView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.specLabel)
        
        self.proImgView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
//            make.top.equalTo(self.proImgView)
            make.centerY.equalTo(self.proImgView)
            make.left.equalTo(self.proImgView.snp_right).offset(15)
            make.right.equalTo(self.contentView).offset(-20)
        }
    
        self.specLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(15)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }
    
    class func imgCdnWidth() -> Int {
        return 160
    }
    
    //MARK: property
    lazy var proImgView: UIImageView = {
        var imageView = UIImageView.init()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.layer.borderColor = UIColor.init(rgb: 0xcccccc).CGColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    lazy var specLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 2
        return label
    }()


}
