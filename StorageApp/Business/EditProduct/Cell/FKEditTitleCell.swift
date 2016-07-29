//
//  FKEditTitleCell.swift
//  StorageApp
//
//  Created by jack on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditTitleCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
    }

    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.init(rgb: 0x444444)
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            let cellType = editModel.cellTypeForIndexPath(indexPath)
            if cellType == kEditCellType.kEditCellTypeAddress {
                self.titleLabel.text = editModel.sourceItem.address
            } else if cellType == kEditCellType.kEditCellTypeUPC {
                self.titleLabel.text = editModel.sourceItem.upc
            }
        }
    }

}
