//
//  FKBuyingBtnCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverActionCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .None
        self.backgroundColor = UIColor.whiteColor()
        
        self.addAllSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let dViewModel = viewModel as? DSSDeliverViewModel {
            if let missionModel = dViewModel.missionModelAtIndexPath(indexPath) {
                if let expressNO = missionModel.expressNO {
                    self.titleLabel.text = "运单号：" + expressNO
                    self.titleLabel.hidden = false
                    
                    let attr = [NSFontAttributeName: self.titleLabel.font]
                    let size = (self.titleLabel.text! as NSString).sizeWithAttributes(attr)
                    
                    self.titleLabel.snp_remakeConstraints{ (make) in
                        make.right.equalTo(self.contentView).offset(-16)
                        make.centerY.equalTo(self.contentView)
                        make.width.equalTo((size.width + 14))
                        make.height.equalTo(22)
                    }
                } else {
                    self.titleLabel.hidden = true
                }
            }
        }
    }
    
    // MARK: - Layout
    
    func addAllSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
        }
        
        self.contentView.addSubview(self.deliverButton)
        self.deliverButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSizeMake(100, 25))
        }
    }
    
    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x666666)
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 2
        label.textAlignment = .Center
        label.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        label.textColor = UIColor.init(rgb: 0x999999)
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.hidden = true
        return label
    }()

    lazy var deliverButton: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("确认发货", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(13)
        button.backgroundColor = UIColor.init(rgb: 0x1fbad6)
        button.layer.cornerRadius = 3.0
        return button
    }()
}
