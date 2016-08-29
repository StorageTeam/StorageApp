//
//  DSSRecordListCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSRecordListCell: UITableViewCell {

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
        
        self.contentView.addSubview(self.locationLabel)
        self.contentView.addSubview(self.locationIcon)
        self.contentView.addSubview(self.proImgView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.specLabel)
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.numberHeadLabel)
        self.contentView.addSubview(self.topLine)
        
        self.locationIcon.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView.snp_top).offset(22.5)
        }
        
        self.locationLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.locationIcon.snp_right).offset(5)
            make.centerY.equalTo(self.locationIcon)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        self.proImgView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(45)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.proImgView)
            make.left.equalTo(self.proImgView.snp_right).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        self.specLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        self.priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.proImgView)
        }
        
        self.numberLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.proImgView)
        }
        
        self.numberHeadLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.numberLabel.snp_left)
            make.bottom.equalTo(self.numberLabel)
        }
        
        self.topLine.snp_makeConstraints { (make) in
            make.left.equalTo(self.proImgView)
            make.top.right.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }

    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let model = viewModel as? DSSMissionItem {
            self.proImgView.dss_setImageFromURLString(model.firstPic!, cdnWidth: 160)
            self.titleLabel.text = model.title
            self.priceLabel.text = String.init(format: "$%@", (model.price?.dss_fen2Yuan())!)
            self.specLabel.text = model.specNam
            self.numberLabel.text = String.init(format: "%@", model.quantity!)
            self.locationLabel.text = model.shopName
        }
    }

    // MARK: - PROPERTY
    
    lazy var locationLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        return label
    }()
    
    lazy var locationIcon: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "location_icon"))
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return imageView
    }()

    
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
    
    lazy var priceLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.boldSystemFontOfSize(13)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.boldSystemFontOfSize(13)
        return label
    }()
    
    lazy var numberHeadLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(13)
        label.text = "采购数量："
        return label
    }()
    
    lazy var topLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        return line;
    }()


}
