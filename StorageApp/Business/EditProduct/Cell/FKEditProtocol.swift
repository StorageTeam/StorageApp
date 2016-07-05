//
//  FKEditBaseCell.swift
//  StorageApp
//
//  Created by jack on 16/6/29.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

@objc protocol FKEditInputProtocol: NSObjectProtocol{

    func finishInput(cell:UITableViewCell, text: String?)
    func shouldBeginEditing(view: UIView)
}

@objc protocol FKEditCellProtocol: NSObjectProtocol {
    weak var delegate : FKEditInputProtocol? { get set }
}

