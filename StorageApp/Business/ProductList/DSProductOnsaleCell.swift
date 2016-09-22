//
//  DSSProductListCell.swift
//  StorageApp
//
//  Created by ascii on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import Foundation
import Haneke

class DSProductOnsaleCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.init(rgb: 0xffffff)
        
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(12)
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        self.contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp_bottom).offset(12)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView)
            make.height.equalTo(DSConst.pixelHeight)
        }
        
        self.contentView.addSubview(self.phototView)
        self.phototView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(line.snp_bottom).offset(14)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.phototView.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-12)
            make.top.equalTo(self.phototView)
        }
        
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.phototView)
        }
        
        self.contentView.addSubview(self.stockLabel)
        self.stockLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-12)
            make.bottom.equalTo(self.phototView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let viewModel = viewModel as? DSProductListViewModel {
            if let model = (viewModel.itemAtIndexPath(indexPath) as? DSProductOnsaleModel) {
                self.timeLabel.text   = nil
                self.phototView.image = nil
                self.titleLabel.text  = nil
                self.priceLabel.text  = nil
                self.stockLabel.text  = nil
                
                
                if let time = model.createTime?.stringByReplacingOccurrencesOfString("T", withString: " ") {
                    self.timeLabel.text = "创建时间：" + time
                }
                if let url = model.photoURL {
                    self.phototView.dss_setImageFromURLString(url, cdnWidth: 80)
                }
                if let name = model.name {
                    self.titleLabel.text = name
                }
                if let price = model.price {
                    self.priceLabel.text = "$" + price.dss_fen2Yuan()
                }
                if let stock = model.stock {
                    self.stockLabel.text = String.init(format: "销量:%d", stock)
                }
            }
        }
    }
    
    //MARK: - Method
    
//    class func height() -> CGFloat {
//        return 78
//    }
    
    //MARK: - Property
    lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x262626)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    lazy var phototView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(rgb: 0xf4f4f4).CGColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x262626)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    lazy var stockLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Right
        return label
    }()
}
