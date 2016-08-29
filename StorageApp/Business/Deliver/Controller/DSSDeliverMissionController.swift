//
//  FKBuyMissionController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSDeliverMissionController: DSSBaseViewController, DSSDataCenterDelegate, UITableViewDelegate, UITableViewDataSource {
    private static let DELIVER_MISSION_REQUEST              : Int   = 0
    private static let PRODUCTLIST_ONSALE_NEXT_REQUEST      : Int   = 1
    
    var shopId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.requestList()
    }
    
    // MARK: - Request
    
    func requestList() -> Void {
        DSSDeliverService.requestMissionList(DSSDeliverMissionController.DELIVER_MISSION_REQUEST,
                                             delegate: self,
                                             startRow: "0")
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if header.code == DSSResponseCode.Normal {
            let items = DSSDeliverService.parseList(response)
            
            switch identify {
            case DSSDeliverMissionController.DELIVER_MISSION_REQUEST:
//                self.viewModel.dataSource.removeAllObjects()
//                self.viewModel.dataSource.addObjectsFromArray(items)
//            case DSSProductListController.PRODUCTLIST_WAITSALE_NEXT_REQUEST:
//                self.viewModel.append(waitSaleItems, type: DSSProductListType.WaitSale)
                break;
            default: break
            }
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if (indexPath.row == 1) {
//            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyMissionCell)) as? DSSBuyMissionCell
//            if (cell != nil) {
//                cell?.proImgView.image = UIImage.init(named: "LeftBarIcon")
//                cell?.titleLabel.text = "hsdhfhsdhfa水电费火花塞地方速度发货水电费是东方红水电费"
//                cell?.priceLabel.text = "$100"
//                cell?.specLabel.text = "specs sddsfsfsdfhhgfudfhgdfgdfgdfg"
//                cell?.numberLabel.text = "20000"
//                cell?.buyButton.addTarget(self, action: #selector(self.clickBuy(_:)), forControlEvents: .TouchUpInside)
//            }
//            return cell!
//        } else if (indexPath.row == 0){
//            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyLocationCell)) as? DSSBuyLocationCell
//            if (cell != nil) {
//                cell?.titleLabel.text = "美国四点后覅是旗舰店"
//            }
//            return cell!
//        }
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
    
    //MARK: action
    
    func clickBuy(sender: UIButton) -> Void {
        
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
        tableView.registerClass(DSSDeliverTitleCell.self, forCellReuseIdentifier: String(DSSDeliverTitleCell))
//        tableView.registerClass(DSSBuyLocationCell.self, forCellReuseIdentifier: String(DSSBuyLocationCell))
        return tableView
    }()
    
    lazy var viewModel: DSSDeliverViewModel = {
        let viewModel = DSSDeliverViewModel.init()
        return viewModel
    }()
}
