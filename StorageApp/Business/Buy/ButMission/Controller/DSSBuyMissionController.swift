//
//  FKBuyMissionController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyMissionController: DSSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var shopId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.configNavItem()
    }

    func addAllSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.shopListView)
        
        self.shopListView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(45)
        }
        
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.shopListView.snp_bottom)
            make.left.right.bottom.equalTo(self.view)
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
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyMissionCell)) as? DSSBuyMissionCell
            if (cell != nil) {
                cell?.proImgView.image = UIImage.init(named: "LeftBarIcon")
                cell?.titleLabel.text = "hsdhfhsdhfa水电费火花塞地方速度发货水电费是东方红水电费"
                cell?.priceLabel.text = "$100"
                cell?.specLabel.text = "specs sddsfsfsdfhhgfudfhgdfgdfgdfg"
                cell?.numberLabel.text = "20000"
                cell?.buyButton.addTarget(self, action: #selector(self.clickBuy(_:)), forControlEvents: .TouchUpInside)
            }
            return cell!
        } else if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyLocationCell)) as? DSSBuyLocationCell
            if (cell != nil) {
                cell?.titleLabel.text = "美国四点后覅是旗舰店"
            }
            return cell!
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 44.0
        } else if (indexPath.row == 1) {
            return 110.0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView
        : UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func configNavItem() {
        
        self.navigationItem.title = "采购任务"
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBack))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    //MARK: action
    
    func clickBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickBuy(sender: UIButton) -> Void {
        
    }
    
    func clickSelectShop() {
        
    }
    
    //MARK: - property
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        table.delegate = self
        table.dataSource = self
        table.registerClass(DSSBuyMissionCell.self, forCellReuseIdentifier: String(DSSBuyMissionCell))
        table.registerClass(DSSBuyLocationCell.self, forCellReuseIdentifier: String(DSSBuyLocationCell))
        return table
    }()
    
    lazy var shopListView: DSSBuySelectShopView = {
        let view = DSSBuySelectShopView()
        view.actionBtn.addTarget(self,
                                 action: #selector(self.clickSelectShop),
                                 forControlEvents: .TouchUpInside)
        return view
    }()
}
