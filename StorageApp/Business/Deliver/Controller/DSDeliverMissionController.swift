//
//  FKBuyMissionController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class DSDeliverMissionController: DSBaseViewController, DSDataCenterDelegate, UITableViewDelegate, UITableViewDataSource {
    private static let DELIVER_MISSION_LIST_REQUEST         : Int   = 0
    private static let DELIVER_MISSION_REQUEST              : Int   = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "发货任务"
        
        self.requestList()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        weak var wkSelf = self;
        tableView.dg_addPullToRefreshWithActionHandler({ () -> Void in
            wkSelf!.requestList()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    // MARK: - Request
    
    func requestList() -> Void {
        self.showHUD()
        DSDeliverService.requestMissionList(DSDeliverMissionController.DELIVER_MISSION_LIST_REQUEST,
                                             delegate: self,
                                             startRow: "0")
    }
    
    func deliverWithID(itemID: String?) -> Void {
        DSDeliverService.deliverWithID(DSDeliverMissionController.DELIVER_MISSION_REQUEST, itemID: itemID, delegate: self)
    }
    
    // MARK: - DSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        self.hidHud(true)
        
        if header.code == DSResponseCode.Normal {
            let items = DSDeliverService.parseList(response)
            
            switch identify {
            case DSDeliverMissionController.DELIVER_MISSION_LIST_REQUEST:
                self.viewModel.dataSource.removeAllObjects()
                self.viewModel.dataSource.addObjectsFromArray(items)
                break
            case DSDeliverMissionController.DELIVER_MISSION_REQUEST:
                self.requestList()
                self.showText("发货成功")
                break;
            default: break
            }
            
            self.tableView.reloadData()
            
            let count = self.viewModel.dataSource.count
            if count == 0 {
                self.tableView.addSubview(self.emptyTipLabel)
                self.emptyTipLabel.hidden = false
                self.emptyTipLabel.snp_makeConstraints { (make) in
                    make.left.right.equalTo(self.tableView)
                    make.top.equalTo(self.tableView).offset(12)
                    make.centerX.equalTo(self.tableView)
                }
            } else {
                self.emptyTipLabel.removeFromSuperview()
            }
        } else {
            self.showText(header.msg)
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        self.hidHud(true)
        
        if let errorString = error {
            self.showText(errorString)
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.viewModel.heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identify : String = ""
        
        let cellType = self.viewModel.cellTypeAtIndexPath(indexPath)
        switch cellType {
        case .Status:
            identify = String(DSDeliverStatusCell)
        case .Product:
            identify = String(DSDeliverProdCell)
        case .Action:
            identify = String(DSDeliverActionCell)
        default:
            break
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(identify) {
            cell.fk_configWith(self.viewModel, indexPath: indexPath)
            
            if let actionCell = (cell as? DSDeliverActionCell) {
                actionCell.deliverButton.tag = indexPath.section
                actionCell.deliverButton.addTarget(self, action: #selector(self.clickDeliverButton(_:)), forControlEvents: .TouchUpInside)
            }
            
            return cell
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
    }
    
    //MARK: action
    
    func clickDeliverButton(sender: UIButton) -> Void {
        let alertController = UIAlertController(title: "发货确认", message: "是否确认发货", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel) { (action) in
        })
        
        weak var wkSelf = self
        alertController.addAction(UIAlertAction(title: "确定", style: .Default) { (action) in
            if let missionModel = wkSelf!.viewModel.missionModelAtIndexPath(NSIndexPath.init(forRow: 0, inSection: sender.tag)) {
                wkSelf!.deliverWithID(missionModel.itemID)
            }
        })
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: - Layout
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    // MARK: - property
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(DSDeliverStatusCell.self,  forCellReuseIdentifier: String(DSDeliverStatusCell))
        tableView.registerClass(DSDeliverProdCell.self,    forCellReuseIdentifier: String(DSDeliverProdCell))
        tableView.registerClass(DSDeliverActionCell.self,  forCellReuseIdentifier: String(DSDeliverActionCell))
        return tableView
    }()
    
    lazy var viewModel: DSDeliverViewModel = {
        let viewModel = DSDeliverViewModel.init()
        return viewModel
    }()
    
    lazy var emptyTipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = .Center
        label.text = "暂未查询到数据"
        label.hidden = true
        return label
    }()
}
