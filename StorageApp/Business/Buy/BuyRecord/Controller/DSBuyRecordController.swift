//
//  DSBuyRecordController.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class DSBuyRecordController: DSBaseViewController, UITableViewDelegate, UITableViewDataSource, DSDataCenterDelegate {

    var dataArray: [DSMissionItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.configNavItem()
        self.addRefresh()
        
        self.showHUD()
        self.reqDataList()
    }
    
    func addAllSubviews() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    func addRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pullRequestDataList(true)
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    //MARK: - Request
    func pullRequestDataList(up: Bool) {
        self.reqDataList()
    }
    
    func reqDataList() {
        DSBuyRecordServe.reqRecordList(1500, delegate: self)
    }
    
    //MARK: - Response
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
        self.hidHud(true)
        self.tableView.dg_stopLoading()
        
        if header.code == DSResponseCode.Normal {
            if identify == 1500 {
                self.dataArray = DSBuyRecordServe.parserRecordList(response)
                self.tableView.reloadData()
            }
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        
        self.hidHud(true)
        self.tableView.dg_stopLoading()
        
        if let errorString = error {
            self.showText(errorString)
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataArray != nil {
            return (self.dataArray?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let missionItem = self.missionItemAtIndex(indexPath.section)
        
        if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSRecordListCell)) as? DSRecordListCell
            if (cell != nil && missionItem != nil) {
                cell?.fk_configWith(missionItem!, indexPath: indexPath)
            }
            return cell!
        } else if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSRecordTimeCell)) as? DSRecordTimeCell
            if (cell != nil && missionItem != nil) {
                cell?.fk_configWith(missionItem!, indexPath: indexPath)
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
    
    //MARK: - method
    func configNavItem() {
        
        self.navigationItem.title = "采购记录"
//        
//        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickBack))
//        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func missionItemAtIndex(index: Int) -> DSMissionItem? {
        if index >= 0 && index < self.dataArray?.count {
            return self.dataArray![index]
        }
        return nil
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
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        table.registerClass(DSRecordListCell.self, forCellReuseIdentifier: String(DSRecordListCell))
        table.registerClass(DSRecordTimeCell.self, forCellReuseIdentifier: String(DSRecordTimeCell))
        return table
    }()}
