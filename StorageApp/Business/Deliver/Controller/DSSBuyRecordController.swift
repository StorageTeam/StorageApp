//
//  DSSBuyRecordController.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyRecordController: DSSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.configNavItem()
    }
    
    func addAllSubviews() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSRecordListCell)) as? DSSRecordListCell
            if (cell != nil) {
                cell?.proImgView.image = UIImage.init(named: "LeftBarIcon")
                cell?.titleLabel.text = "hsdhfhsdhfa水电费火花塞地方速度发货水电费是东方红水电费"
                cell?.priceLabel.text = "$100"
                cell?.specLabel.text = "specs sddsfsfsdfhhgfudfhgdfgdfgdfg"
                cell?.numberLabel.text = "20000"
                cell?.locationLabel.text = "会死恢复到收到货粉红色的f"
            }
            return cell!
        } else if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSRecordTimeCell)) as? DSSRecordTimeCell
            if (cell != nil) {
                cell?.timeLabel.text = "2016-83-22 14:00:99"
                cell?.typeLabel.text = "采购成功"
            }
            return cell!
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 44.0
        } else if (indexPath.row == 1) {
            return 140.0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func configNavItem() {
        
        self.navigationItem.title = "采购记录"
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBack))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    //MARK: action
    
    func clickBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - property
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        table.delegate = self
        table.dataSource = self
        table.registerClass(DSSRecordListCell.self, forCellReuseIdentifier: String(DSSRecordListCell))
        table.registerClass(DSSRecordTimeCell.self, forCellReuseIdentifier: String(DSSRecordTimeCell))
        return table
    }()}
