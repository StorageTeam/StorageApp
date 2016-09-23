//
//  DSCurrentShopView.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//


import UIKit

protocol CurrentShopDelegate : NSObjectProtocol {
    func didClickChangeShop(curShop: String?) -> Void
}

class DSCurrentShopView: UIView {
    weak internal var delegate: CurrentShopDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShopName(name: String?) -> Void {
        if let shopName = name {
            self.shopLabel.text = shopName
        } else {
            self.shopLabel.text = "未查询到店铺"
        }
    }
    
    // MARK: - Layout
    
    func addAllSubviews() -> Void {
        self.addSubview(self.locationIcon)
        self.locationIcon.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp_centerY).offset(-27)
            make.size.equalTo(CGSizeMake(32, 46))
        }
        
        self.addSubview(self.seperatorLine)
        self.seperatorLine.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(DSConst.pixelHeight)
            make.center.equalTo(self)
        }
        
        self.addSubview(self.shopLabel)
        self.shopLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(self.seperatorLine.snp_top).offset(-5)
        }
        
        self.addSubview(self.changeShopLabel)
        self.changeShopLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-10)
            make.top.equalTo(self.seperatorLine.snp_bottom).offset(5)
        }
        
        self.addSubview(self.downArrowView)
        self.downArrowView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.changeShopLabel)
            make.left.equalTo(self.changeShopLabel.snp_right).offset(5)
        }
        
        self.addSubview(self.actionButton)
        self.actionButton.snp_makeConstraints { (make) in
            make.center.equalTo(self.downArrowView)
            make.size.equalTo(CGSizeMake(100, 100))
        }
    }
    
    // MARK: - Action
    
    func clickButtonAction(sender: UIButton) -> Void {
        self.delegate?.didClickChangeShop(self.shopLabel.text)
    }
    
    // MARK: - Property
    
    lazy var locationIcon: UIImageView = {
        var view = UIImageView.init()
        view.image = UIImage.init(named: "main_location_icon")
        return view
    }()
    
    lazy var seperatorLine: UIView = {
        var view = UIView.init()
        view.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        return view
    }()
    
    lazy var shopLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        label.font = UIFont.systemFontOfSize(15)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var changeShopLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(15)
        label.text = "选择商品采购店铺"
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var downArrowView: UIImageView = {
        var view = UIImageView.init()
        view.image = UIImage.init(named: "down_arrow_icon")
        return view
    }()
    
    lazy var actionButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.addTarget(self, action: #selector(self.clickButtonAction), forControlEvents: .TouchUpInside)
        return button
    }()
}
