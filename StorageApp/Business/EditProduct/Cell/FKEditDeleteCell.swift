//
//  FKEditDeleteCell.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditDeleteCell: UITableViewCell {

//    var deleteBtn: UIButton = UIButton.init(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
    
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.deleteBtn)
        self.deleteBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.center.equalTo(self.contentView)
            make.height.equalTo(46.0)
        }
    }
    
    //MARK: Property
    lazy var deleteBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("Delete", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.backgroundColor = UIColor.init(rgb: 0xfe3b31)
        button.layer.cornerRadius = 5.0
        return button
    }()

}
