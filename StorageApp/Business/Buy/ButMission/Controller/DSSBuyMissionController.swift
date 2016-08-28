//
//  FKBuyMissionController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyMissionController: DSSBaseViewController, UITableViewDelegate, UITableViewDataSource, DSSDataCenterDelegate {
    
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
    
    //MARK: - Request
    func reqDataList() {
        DSSMissionServe.reqMissionList(2000, delegate: self)
    }
    
    //MARK: - Response
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            if identify == 2000 {
                self.viewModel.orginDataArray = DSSMissionServe.parserMissionList(response)
                self.viewModel.shopArray = DSSMissionServe.filterShopListWith(self.viewModel.orginDataArray!)
                self.tableView.reloadData()
            }
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        if let errorString = error {
            self.showText(errorString)
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.viewModel.dataArray != nil) {
            return (self.viewModel.dataArray?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let missionItem = self.viewModel.missionItemAtIndex(indexPath.row)
        
        if (indexPath.row == 1) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyMissionCell)) as? DSSBuyMissionCell
            
            if (cell != nil) {
                cell?.fk_configWith(missionItem!, indexPath: indexPath)
                cell?.buyButton.addTarget(self, action: #selector(self.clickBuy(_:)), forControlEvents: .TouchUpInside)
            }
            return cell!
        } else if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyLocationCell)) as? DSSBuyLocationCell
            if (cell != nil) {
                cell?.titleLabel.text = missionItem?.shopName
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
        
        if (self.viewModel.shopArray != nil) {
            self.shopListView.setDataSource(self.viewModel.shopArray!)
            self.showshopListView()
        }
    }
    
    func clickHideShopListButton(sender: UIButton) -> Void {
        let shopName = self.viewModel.checkSelectedShop()
        
        self.tableView.reloadData()
        
        self.choseShopView.titleLabel.text = shopName
        self.hideshopListView(nil)
    }
    
    //MARK: - method
    func hideshopListView(completion: ((Bool) -> Void)?) -> Void {
        let bounds = self.view.bounds
        let frame = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds))
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.shopListView.frame = frame
        }) { (isFinish) in
            completion?(isFinish)
        }
    }
    
    func showshopListView() -> Void {
        UIView.animateWithDuration(0.5) {
            self.shopListView.frame = self.view.bounds
        }
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
    
    lazy var choseShopView: DSSBuySelectShopView = {
        let view = DSSBuySelectShopView()
        view.actionBtn.addTarget(self,
                                 action: #selector(self.clickSelectShop),
                                 forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var shopListView: DSSShopListView = {
        let view = DSSShopListView.init(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.listHeaderView.actionButton.addTarget(self, action: #selector(clickHideShopListButton), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var viewModel: DSSMissionViewModel = {
        let viewModel = DSSMissionViewModel()
        return viewModel
    }()
}
