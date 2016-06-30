//
//  FKEditInputCell.swift
//  JackSwift
//
//  Created by jack on 16/6/24.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class FKEditInputCell: FKEditBaseCell, UITextFieldDelegate {
    var titleLabel: UILabel! = nil
    var textField : UITextField!
    let bottomLine = UIView.init()  // 两种实例化方式
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.contentView.backgroundColor = UIColor.whiteColor()

        self.initializeSub()
        self.addAllSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func initializeSub(){
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.init(rgb: 0x4a4a4a)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField = UITextField.init()
        textField.textColor = UIColor.init(rgb: 0xcccccc)
        textField.font = UIFont.systemFontOfSize(14)
        textField.returnKeyType = .Done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLine.backgroundColor = UIColor.init(rgb: 0xcccccc)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
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
            make.centerY.equalTo(self.titleLabel)
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
                self.textField.placeholder = "Original"
                self.textField.text = editModel.dataItem?.infoItem?.name
            case .kEditCellTypeName:
                self.titleLabel.text = "产品名称"
                self.textField.placeholder = "Original"
                self.textField.text = editModel.dataItem?.infoItem?.chinaName
            case .kEditCellTypeBrand:
                self.titleLabel.text = "Brand"
                self.textField.placeholder = "optional"
                self.textField.text = editModel.dataItem?.infoItem?.brand
            case .kEditCellTypePrice:
                self.titleLabel.text = "Price"
                self.textField.placeholder = nil
                keyboardType = .DecimalPad
                self.textField.text = String(editModel.dataItem?.infoItem?.price)
            case .kEditCellTypeStock:
                self.titleLabel.text = "Stock"
                self.textField.placeholder = nil
                keyboardType = .NumberPad
                self.textField.text = editModel.dataItem?.specItem?.stock
            case .kEditCellTypeWeight:
                self.titleLabel.text = "Weight(g)"
                self.textField.placeholder = nil
                self.textField.text = editModel.dataItem?.specItem?.weight
            case .kEditCellTypeItemNo:
                self.titleLabel.text = "Item No."
                self.textField.placeholder = nil
                self.textField.text = editModel.dataItem?.specItem?.siteSku
            default:
                self.titleLabel.text = nil
                self.textField.placeholder = nil
                break
            }
            self.textField.keyboardType = keyboardType
            
//            if editModel.dataItem != nil {
//                
//                switch cellType {
//                case .kEditCellTypeTitle:
//                    self.textField.text = editModel.dataItem?.infoItem?.name
//                case .kEditCellTypeName:
//                    self.textField.text = editModel.dataItem?.infoItem?.chinaName
//                case .kEditCellTypeBrand:
//                    self.textField.text = editModel.dataItem?.infoItem?.brand
//                case .kEditCellTypePrice:
//                    self.textField.text = editModel.dataItem?.infoItem?.price?.dss_fen2Yuan(2)
//                case .kEditCellTypeStock:
//                    self.textField.text = editModel.dataItem?.specItem?.stock
//                case .kEditCellTypeWeight:
//                    self.textField.text = editModel.dataItem?.specItem?.weight
//                case .kEditCellTypeItemNo:
//                    self.textField.text = editModel.dataItem?.specItem?.siteSku
//                default:
//                    self.titleLabel.text = nil
//                    self.textField.placeholder = nil
//                    break
//                }
//
//            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(FKEditBaseCellDelegate.finishInput(_:text:))){
            self.delegate?.finishInput(self, text: textField.text)
        }
    }
}
