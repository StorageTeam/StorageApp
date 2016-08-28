//
//  DSSRecordTimeCell.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSRecordTimeCell: UITableViewCell {

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
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.typeLabel)
        
        self.timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
        self.typeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.init(rgb: 0x333333)
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        return label
    }()

}
