//
//  FKBuyingController.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyingController: DSSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.navigationItem.title = "采购任务"
    }
    
    func addAllSubviews() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            if let proCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingProCell)) as? DSSBuyingProCell {
                proCell.proImgView.image = UIImage.init(named: "product_list_icon")
                proCell.titleLabel.text = "啥地方和斯蒂芬和水电费四点后覅和史蒂夫水电费好说的分"
                return proCell
            }
            
        } else if (indexPath.section == 1){
            if let countCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingCountCell)) as? DSSBuyingCountCell {
                countCell.buyCountField.text = "20"
                countCell.waitCountLabel.text = "待采购数20"
                return countCell
            }
  
        } else if (indexPath.section == 2) {
            if let confirmCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingBtnCell)) as? DSSBuyingBtnCell {
                confirmCell.buyButton.addTarget(self,
                                                action: #selector(self.clickConfirmBtn),
                                                forControlEvents: .TouchUpInside)
                
                confirmCell.cancelBtn.addTarget(self,
                                                action: #selector(self.clickCancelBtn),
                                                forControlEvents: .TouchUpInside)
                return confirmCell
            }
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 100.0
        } else if (indexPath.section == 1) {
            return 60
        } else if (indexPath.section == 2) {
            return 45;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(DSSBuyingHeaderView)) as? DSSBuyingHeaderView{
                header.titleLabel.text = "UPC"
                return header
            }
        } else if (section == 1) {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(DSSBuyingHeaderView)) as? DSSBuyingHeaderView{
                header.titleLabel.text = "采购统计"
                return header
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    //MARK: action
    func clickConfirmBtn() {
        
    }
    
    func clickCancelBtn() {
        
    }

    
    //MARK: - property
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        
        table.registerClass(DSSBuyingProCell.self, forCellReuseIdentifier: String(DSSBuyingProCell))
        table.registerClass(DSSBuyingCountCell.self, forCellReuseIdentifier: String(DSSBuyingCountCell))
        table.registerClass(DSSBuyingBtnCell.self, forCellReuseIdentifier: String(DSSBuyingBtnCell))
        table.registerClass(DSSBuyingHeaderView.self, forHeaderFooterViewReuseIdentifier: String(DSSBuyingHeaderView))
        return table
    }()

}
