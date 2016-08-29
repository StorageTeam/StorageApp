//
//  FKBuyingProCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverProdCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = .None
        
        self.addAllSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let dViewModel = viewModel as? DSSDeliverViewModel {
            if let missionModel = dViewModel.missionModelAtIndexPath(indexPath) {
                if let prodModel = missionModel.productItemAtIndex(indexPath.row - 1) {
                    self.prodImgView.dss_setImage(prodModel.firstPic, placeholder: nil)
                    self.titleLabel.text              = prodModel.title
                    self.specLabel.text               = prodModel.specName
                    self.quantityLabel.attributedText = self.quantityString(prodModel.quantity)
                    self.statusLabel.text             = prodModel.statusDesc()
                }
            }
        }
    }
    
    // MARK: - Method
    
    func quantityString(quantity: String?) -> NSAttributedString? {
        let mutAttrString = NSMutableAttributedString.init(string: "数量：")
        if let qty = quantity {
            let attrQty = NSAttributedString.init(string: qty, attributes: [NSForegroundColorAttributeName : UIColor.init(rgb: 0x333333)])
            mutAttrString.appendAttributedString(attrQty)
        }
        return mutAttrString
    }
    
    // MARK: - Layout
    
    func addAllSubviews() {
        self.contentView.addSubview(self.prodImgView)
        self.prodImgView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.prodImgView)
            make.left.equalTo(self.prodImgView.snp_right).offset(6)
            make.right.equalTo(self.contentView).offset(-16)
        }
        
        self.contentView.addSubview(self.specLabel)
        self.specLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-16)
        }
        
        self.contentView.addSubview(self.quantityLabel)
        self.quantityLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.prodImgView)
        }
        
        self.contentView.addSubview(self.statusLabel)
        self.statusLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.centerY.equalTo(self.quantityLabel)
        }
        
        self.contentView.addSubview(self.grayLine)
        self.grayLine.snp_makeConstraints { (make) in
            make.left.equalTo(self.prodImgView)
            make.bottom.right.equalTo(self.contentView)
            make.height.equalTo(DSSConst.pixelHeight)
        }
    }
    
    // MARK: - Property
    
    lazy var prodImgView: UIImageView = {
        var imageView = UIImageView.init()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.layer.borderColor = UIColor.init(rgb: 0xcccccc).CGColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var specLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var quantityLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()

    lazy var grayLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        return line;
    }()
}
