//
//  DSSCurrentLocationView.swift
//  StorageApp
//
//  Created by ascii on 16/7/27.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

protocol CurrentLocationDelegate : NSObjectProtocol {
    func didClickChangeLocation(curLocation: String?) -> Void
}

class DSSCurrentLocationView: UIView {
    weak internal var delegate: CurrentLocationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func addAllSubviews() -> Void {
        self.addSubview(self.locationBgView)
        self.locationBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.right.equalTo(self).offset(-4)
        }
        
        self.addSubview(self.greenLine)
        self.greenLine.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(DSSConst.pixelHeight)
            make.center.equalTo(self)
        }
        
        self.addSubview(self.locationLabel)
        self.locationLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(self.greenLine.snp_top).offset(-5)
        }
        
        self.addSubview(self.changeLocationLabel)
        self.changeLocationLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-10)
            make.top.equalTo(self.greenLine.snp_bottom).offset(5)
        }
        
        self.addSubview(self.downArrowView)
        self.downArrowView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.changeLocationLabel)
            make.left.equalTo(self.changeLocationLabel.snp_right).offset(5)
        }
        
        self.addSubview(self.actionButton)
        self.actionButton.snp_makeConstraints { (make) in
            make.center.equalTo(self.downArrowView)
            make.size.equalTo(CGSizeMake(100, 100))
        }
    }
    
    // MARK: - Action
    
    func clickButtonAction(sender: UIButton) -> Void {
        self.delegate?.didClickChangeLocation(self.locationLabel.text)
    }
    
    // MARK: - Property
    
    lazy var locationBgView: UIImageView = {
        var view = UIImageView.init()
        view.image = UIImage.init(named: "locationBgView")
        return view
    }()
    
    lazy var greenLine: UIView = {
        var view = UIView.init()
        view.backgroundColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 1)
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 31.0/255.0, green: 186.0/255.0, blue: 214.0/255.0, alpha: 1)
        label.font = UIFont.systemFontOfSize(15)
        label.numberOfLines = 0
        label.text = "点击更改商品手机地点"
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var changeLocationLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(15)
        label.text = "点击更改商品手机地点"
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
