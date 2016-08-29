//
//  FKBuyingHeaderView.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverStatusCell: UITableViewCell {

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
            self.titleLabel.text = dViewModel.missionModelAtIndexPath(indexPath)?.createTime?.stringByReplacingOccurrencesOfString("T", withString: " ")
        }
    }
    
    // MARK: - Layout
    
    func addAllSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
        }
        
        self.contentView.addSubview(self.statusLabel)
        self.statusLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.centerY.equalTo(self.contentView)
        }
        
        self.contentView.addSubview(self.grayLine)
        self.grayLine.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.right.equalTo(self.contentView)
            make.height.equalTo(DSSConst.pixelHeight)
        }
    }
    
    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x333333)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        label.font = UIFont.systemFontOfSize(14)
        label.hidden = true
        label.text = "已发货"
        return label
    }()

    lazy var grayLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        return line;
    }()
}
