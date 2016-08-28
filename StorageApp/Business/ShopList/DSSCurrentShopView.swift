//
//  DSSCurrentShopView.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//


import UIKit

protocol CurrentShopDelegate : NSObjectProtocol {
    func didClickChangeShop(curShop: String?) -> Void
}

class DSSCurrentShopView: UIView {
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
        self.addSubview(self.shopBgView)
        self.shopBgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(self.greenLine)
        self.greenLine.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(DSSConst.pixelHeight)
            make.center.equalTo(self)
        }
        
        self.addSubview(self.shopLabel)
        self.shopLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(self.greenLine.snp_top).offset(-5)
        }
        
        self.addSubview(self.changeShopLabel)
        self.changeShopLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-10)
            make.top.equalTo(self.greenLine.snp_bottom).offset(5)
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
    
    lazy var shopBgView: UIImageView = {
        var view = UIImageView.init()
        view.image = UIImage.init(named: "locationBgView")
        return view
    }()
    
    lazy var greenLine: UIView = {
        var view = UIView.init()
        view.backgroundColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 1)
        return view
    }()
    
    lazy var shopLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 1)
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
        button.addTarget(self, action: #selector(clickButtonAction), forControlEvents: .TouchUpInside)
        return button
    }()
}
