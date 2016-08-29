//
//  DSSDeliverRecordController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverRecordController: DSSBaseViewController, DSSDataCenterDelegate, UITableViewDelegate, UITableViewDataSource {
    private static let DELIVER_RECORD_LIST_REQUEST  : Int   = 0
    
    var shopId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "发货记录"
        
        self.requestList()
    }
    
    // MARK: - Request
    
    func requestList() -> Void {
        DSSDeliverService.requestRecordList(DSSDeliverRecordController.DELIVER_RECORD_LIST_REQUEST,
                                            delegate: self,
                                            startRow: "0")
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if header.code == DSSResponseCode.Normal {
            let items = DSSDeliverService.parseList(response)
            
            switch identify {
            case DSSDeliverRecordController.DELIVER_RECORD_LIST_REQUEST:
                self.viewModel.dataSource.removeAllObjects()
                self.viewModel.dataSource.addObjectsFromArray(items)
                break
            default: break
            }
            self.tableView.reloadData()
        } else {
            
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
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
            identify = String(DSSDeliverStatusCell)
        case .Product:
            identify = String(DSSDeliverProdCell)
        case .Action:
            identify = String(DSSDeliverActionCell)
        default:
            break
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(identify) {
            cell.fk_configWith(self.viewModel, indexPath: indexPath)
            if let statusCell = (cell as? DSSDeliverStatusCell) {
                statusCell.statusLabel.hidden = false
            }
            if let prodCell = (cell as? DSSDeliverProdCell) {
                prodCell.statusLabel.hidden = true
            }
            if let actionCell = (cell as? DSSDeliverActionCell) {
                actionCell.deliverButton.hidden = true
                actionCell.alignStatusCellRight()
            }
            
            return cell
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
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
        tableView.registerClass(DSSDeliverStatusCell.self,  forCellReuseIdentifier: String(DSSDeliverStatusCell))
        tableView.registerClass(DSSDeliverProdCell.self,    forCellReuseIdentifier: String(DSSDeliverProdCell))
        tableView.registerClass(DSSDeliverActionCell.self,  forCellReuseIdentifier: String(DSSDeliverActionCell))
        return tableView
    }()
    
    lazy var viewModel: DSSDeliverViewModel = {
        let viewModel = DSSDeliverViewModel.init()
        return viewModel
    }()
}
