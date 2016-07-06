//
//  FKEditInputCell.swift
//  JackSwift
//
//  Created by jack on 16/6/24.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditInputCell: UITableViewCell, UITextFieldDelegate, FKEditCellProtocol{
    
    weak var delegate : FKEditInputProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.addAllSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() -> Void {
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textField)
        self.contentView.addSubview(self.bottomLine)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
        }
        
        self.textField.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_right).offset(10)
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(self.titleLabel)
            make.height.equalTo(self.contentView)
        }
        
        self.bottomLine.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
        
    }
    
    override func fk_configWith(viewModel: AnyObject, indexPath: NSIndexPath) {
        if let editModel = viewModel as? EditViewModel {
            
            let cellType = editModel.cellTypeForIndexPath(indexPath)
            
            var canEdit = true
            if editModel.editType == kEditType.kEditTypeCheck {
                canEdit = false
            }
            self.textField.userInteractionEnabled = canEdit
            
            var keyboardType = UIKeyboardType.Default
            
            switch cellType {
            case .kEditCellTypeTitle:
                self.titleLabel.text = "Product Title"
                self.textField.placeholder = nil
                self.textField.text = editModel.dataItem.infoItem.name
            case .kEditCellTypeName:
                self.titleLabel.text = "产品名称"
                self.textField.placeholder = "optional"
                self.textField.text = editModel.dataItem.infoItem.chinaName
            case .kEditCellTypeBrand:
                self.titleLabel.text = "Brand"
                self.textField.placeholder = "optional"
                self.textField.text = editModel.dataItem.infoItem.brand
            case .kEditCellTypePrice:
                self.titleLabel.text = "Price($)"
                self.textField.placeholder = nil
                keyboardType = .DecimalPad
                if (editModel.dataItem.infoItem.price != nil) {
                    let priceFloat = Float(editModel.dataItem.infoItem.price!) / 100.0
                    self.textField.text = String.init(format: "%.2f", priceFloat)
                }

            case .kEditCellTypeStock:
                self.titleLabel.text = "Stock"
                self.textField.placeholder = nil
                keyboardType = .NumberPad
                self.textField.text = editModel.dataItem.specItem.stock
            case .kEditCellTypeWeight:
                self.titleLabel.text = "Weight(g)"
                self.textField.placeholder = nil
                keyboardType = .NumberPad
                self.textField.text = editModel.dataItem.specItem.weight
            case .kEditCellTypeItemNo:
                self.titleLabel.text = "Item No."
                self.textField.placeholder = nil
                self.textField.text = editModel.dataItem.specItem.siteSku
            default:
                self.titleLabel.text = nil
                self.textField.placeholder = nil
                break
            }
            self.textField.keyboardType = keyboardType
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditInputProtocol.shouldBeginEditing(_:))){
            self.delegate?.shouldBeginEditing(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditInputProtocol.finishInput(_:text:))){
            self.delegate?.finishInput(self, text: textField.text)
        }
    }
    
    lazy var titleLabel: UILabel = {
        var label = UILabel.init()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.init(rgb: 0x4a4a4a)
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField.init()
        field.textColor = UIColor.init(rgb: 0xcccccc)
        field.font = UIFont.systemFontOfSize(14)
        field.returnKeyType = .Done
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(rgb: 0xcccccc)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
