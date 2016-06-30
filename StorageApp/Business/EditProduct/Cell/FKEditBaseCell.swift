//
//  FKEditBaseCell.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

@objc protocol FKEditBaseCellDelegate: NSObjectProtocol{
    
    func finishInput(cell:FKEditBaseCell, text: String?)
}

class FKEditBaseCell: UITableViewCell {

    weak var delegate : FKEditBaseCellDelegate?
//    var textField : UITextField!
    
    

}
