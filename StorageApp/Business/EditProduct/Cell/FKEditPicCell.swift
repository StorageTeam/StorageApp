//
//  FKEditPicCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditPicCell: UITableViewCell {
    
    var imagBgView  : UIImageView!
    var titleLabel   : UILabel!

    // 为什么重载实例化方法，不能写 override func init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.initializeSub()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSub(){
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "Main\nPicture"
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imagBgView = UIImageView.init()
        imagBgView.backgroundColor = UIColor.redColor()
        imagBgView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.imagBgView)
        self.contentView.addSubview(self.titleLabel)
        
        self.imagBgView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.titleLabel)
            make.size.equalTo(CGSizeMake(90, 90))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }

    }


}
