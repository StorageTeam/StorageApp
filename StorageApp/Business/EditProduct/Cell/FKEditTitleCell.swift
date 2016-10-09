//
//  FKEditTitleCell.swift
//  StorageApp
//
//  Created by jack on 16/7/28.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class FKEditTitleCell: UITableViewCell, UITextFieldDelegate {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.addAllSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    // MARK: - Layout
    
    private func addAllSubviews() -> Void {
        self.contentView.addSubview(self.textField)
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.bottom.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
        }
    }

    // MARK: - Property
    
    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.init(rgb: 0x444444)
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFontOfSize(14)
        textField.textColor = UIColor.init(rgb: 0x444444)
        textField.returnKeyType = UIReturnKeyType.Done
        textField.keyboardType = .NumbersAndPunctuation
        textField.delegate = self
        return textField
    }()
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            let cellType = editModel.cellTypeForIndexPath(indexPath)
            if cellType == kEditCellType.kEditCellTypeAddress {
                self.textField.text = editModel.sourceItem.address
                self.textField.placeholder = nil
            } else if cellType == kEditCellType.kEditCellTypeUPC {
                self.textField.text = editModel.sourceItem.upc
                self.textField.placeholder = "请输入UPC"
            }
        }
    }

}
