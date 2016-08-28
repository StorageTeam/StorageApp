//
//  DSSLocationListCell.swift
//  StorageApp
//
//  Created by ascii on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSSupplierListCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.init(rgb: 0xffffff)
        
        self.contentView.addSubview(self.statusImgIcon)
        self.statusImgIcon.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.centerY.equalTo(self.contentView)
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        self.contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(DSSConst.pixelHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.textLabel?.textColor = UIColor.init(rgb: 0x1fbad6)
            self.statusImgIcon.image = UIImage.init(named: "location_icon_selected")
        } else {
            self.textLabel?.textColor = UIColor.init(rgb: 0x444444)
            self.statusImgIcon.image = UIImage.init(named: "location_icon_normal")
        }
    }
    
    // MARK: - Property
    
    lazy var statusImgIcon: UIImageView = {
        var view = UIImageView.init()
        return view
    }()
}





