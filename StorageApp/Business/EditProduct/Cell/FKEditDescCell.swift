//
//  FKEditDescCell.swift
//  JackSwift
//
//  Created by jack on 16/6/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditDescCell: UITableViewCell {

    var titleLabel: UILabel!
    var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

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
        titleLabel.textColor = UIColor.colorFromHexStr("4a4a4a")
        titleLabel.text = "Description"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField = UITextField.init()
        textField.textColor = UIColor.colorFromHexStr("cccccc")
        textField.placeholder = "optional"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textField)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.left.equalTo(self.contentView).offset(10)
        }
        
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(titleLabel);
        }
    }

}
