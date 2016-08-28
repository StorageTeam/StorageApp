//
//  DSSBuyLocationCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyLocationCell: UITableViewCell {

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
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.iconImgView)
        
        self.iconImgView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.iconImgView.snp_right).offset(5)
            make.centerY.equalTo(self.iconImgView)
            make.right.equalTo(self.contentView).offset(-15)
        }

    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        return label
    }()
    
    lazy var iconImgView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "location_icon"))
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return imageView
    }()


}
