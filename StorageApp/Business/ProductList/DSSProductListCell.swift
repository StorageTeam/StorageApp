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

class DSSProductListCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.phototView)
        self.phototView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.phototView.snp_right).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
            make.top.equalTo(self.contentView).offset(16)
        }
        
        self.contentView.addSubview(self.stockLabel)
        self.stockLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.contentView).offset(-16)
        }
        
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.stockLabel.snp_right).offset(26)
            make.centerY.equalTo(self.stockLabel)
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xf5f5f5)
        self.contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(DSSConst.pixelHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let viewModel = viewModel as? DSSProductListViewModel {
            if let model = viewModel.itemAtIndexPath(indexPath) {
                self.phototView.dss_setImageFromURLString(model.photoURL, cdnWidth: 60)
                self.titleLabel.text = model.name
                self.priceLabel.text = "$" + model.price.dss_fen2Yuan()
                self.stockLabel.text = String.init(format: "stocks: %d", model.stock)
//                self.saleLabel.text = model.te
            }
        }
    }
    
    //MARK: - Method
    
    class func height() -> CGFloat {
        return 78
    }
    
    //MARK: - Property
    lazy var phototView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.backgroundColor = UIColor.init(rgb: 0xcccccc)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x262626)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0xe8611f)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    lazy var stockLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x9b9b9b)
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()
    
    lazy var saleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x9b9b9b)
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()
}
