//
//  ViewController.swift
//  StorageApp
//
//  Created by ascii on 16/6/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class DSSProductListController: DSSBaseViewController, DSSSegmentControlDelegate, DSSDataCenterDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    private static let PRODUCTLIST_ONSALE_REQUEST          : Int   = 0
    private static let PRODUCTLIST_ONSALE_NEXT_REQUEST     : Int   = 1
    private static let PRODUCTLIST_WAITSALE_REQUEST        : Int   = 2
    private static let PRODUCTLIST_WAITSALE_NEXT_REQUEST   : Int   = 3
    private static let PRODUCTLIST_DELETE_LIST_REQUEST     : Int   = 4
    
    private static let ALERT_VIEW_DELETE     : String   = "ALERT_VIEW_DELETE"
    private static let ALERT_VIEW_LOGOUT     : String   = "ALERT_VIEW_LOGOUT"
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Item Managerment"
        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem.init(image: UIImage.init(named: "LeftBarIcon"), style: .Done, target: self, action: #selector(clickLeftNaviBarButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "RightBarIcon"), style: .Done, target: self, action: #selector(clickRightNaviBarButton))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if DSSAccount.isLogin() {
            if self.viewModel.isEmpty() {
                DSSProductListService.requestList(DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST, delegate: self, status: "2", startRow: "0")
                DSSProductListService.requestList(DSSProductListController.PRODUCTLIST_ONSALE_REQUEST, delegate: self, status: "1", startRow: "0")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Request
    func pullRequestCurrentPage(isPullDown: Bool) -> Void {
        var status   = ""
        var identify = 0
        if self.viewModel.listType == DSSProductListType.OnSale {
            status      = "1"
            identify    = (isPullDown ? DSSProductListController.PRODUCTLIST_ONSALE_REQUEST : DSSProductListController.PRODUCTLIST_ONSALE_NEXT_REQUEST)
        } else {
            status      = "2"
            identify    = (isPullDown ? DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST : DSSProductListController.PRODUCTLIST_WAITSALE_NEXT_REQUEST)
        }
        
        DSSProductListService.requestList(identify,
                                          delegate: self,
                                          status: status,
                                          startRow: (isPullDown ? "0" : String(self.viewModel.numberOfRowsInSection)))
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if header.code == DSSResponseCode.Normal {
            let (total, items) = DSSProductListService.parseList(response)
            
            switch identify {
            case DSSProductListController.PRODUCTLIST_ONSALE_REQUEST:
                self.viewModel.removeAll(DSSProductListType.OnSale)
                self.viewModel.append(items, type: DSSProductListType.OnSale)
            case DSSProductListController.PRODUCTLIST_ONSALE_NEXT_REQUEST:
                self.viewModel.append(items, type: DSSProductListType.OnSale)
            case DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST:
                self.viewModel.removeAll(DSSProductListType.WaitSale)
                self.viewModel.append(items, type: DSSProductListType.WaitSale)
            case DSSProductListController.PRODUCTLIST_WAITSALE_NEXT_REQUEST:
                self.viewModel.append(items, type: DSSProductListType.WaitSale)
            case DSSProductListController.PRODUCTLIST_DELETE_LIST_REQUEST:
                if let dictType = userInfo?["type"] {
                    if let intType = dictType as? Int {
                        let type = DSSProductListType(rawValue: intType)
                        if let row = userInfo?["row"] as? Int {
                            let indexPath = NSIndexPath.init(forRow: row, inSection: 0)
                            self.viewModel.removeModel(indexPath, type: type!)
                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        }
                    }
                }
            default:
                print(total)
            }
            self.reloadData()
        } else {
            
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if let errorString = error {
            self.showHUD(errorString)
        }
    }
    
    // MARK: - DSSSegmentControlDelegate
    func segmentControlDidSelected(control: DSSSegmentControl, index: Int) {
        if let type = DSSProductListType(rawValue: index) {
            self.viewModel.listType = type
            self.reloadData()
        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if let name = alertView.describeName {
            switch name {
            case DSSProductListController.ALERT_VIEW_DELETE:
                if buttonIndex == 1 {
                    if let model = self.viewModel.itemAtIndexPath(NSIndexPath.init(forRow: alertView.tag, inSection: 0)) {
                        DSSProductListService.deleteList(DSSProductListController.PRODUCTLIST_DELETE_LIST_REQUEST,
                                                         delegate: self,
                                                         ids: [model.itemID],
                                                         userInfo: ["row"   : alertView.tag,
                                                                    "type"  : self.viewModel.listType.rawValue])
                    }
                }
            case DSSProductListController.ALERT_VIEW_LOGOUT:
                if buttonIndex == 1 {
                    DSSAccount.logout()
                    self.presentLoginController()
                }
            default:
                break
            }
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DSSProductListCell.height()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(DSSProductListCell)) {
            cell.fk_configWith(self.viewModel, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let model = viewModel.itemAtIndexPath(indexPath) {
            var editType = kEditType.kEditTypeCheck
            if self.viewModel.listType == DSSProductListType.WaitSale {
                editType = kEditType.kEditTypeEdit
            }
            
            let controller = EditViewController.init(editType: editType, productID: String(model.itemID))
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.viewModel.listType == DSSProductListType.WaitSale {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let alert = UIAlertView.init(title: "Confirm",
                                         message: "Delete?",
                                         delegate: self,
                                         cancelButtonTitle: "Cancel",
                                         otherButtonTitles: "Confirm")
            alert.describeName = DSSProductListController.ALERT_VIEW_DELETE
            alert.tag = indexPath.row
            alert.show()
        }
    }
    
    // MARK: - Action
    func clickLeftNaviBarButton(sender: UIButton) {
        if DSSAccount.isLogin() {
            let alert = UIAlertView.init(title: "Confirm",
                                         message: "Logout?",
                                         delegate: self,
                                         cancelButtonTitle: "Cancel",
                                         otherButtonTitles: "Confirm")
            alert.describeName = DSSProductListController.ALERT_VIEW_LOGOUT
            alert.show()
        } else {
            self.presentLoginController()
        }
    }
    
    func clickRightNaviBarButton(sender: UIButton) {
        let editController = EditViewController.init(editType: kEditType.kEditTypeAdd, productID: nil)
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    // MARK: - Method
    
    func reloadData() {
        self.tableView.reloadData()
        
        let count = self.viewModel.numberOfRowsInSection(0)
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
    }
    
    // MARK: - loadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.segmentControl)
        self.segmentControl.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(52)
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(rgb: 0xf5f5f5)
        self.view.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.segmentControl.snp_bottom)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRectMake(0, 53, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)-53)
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pullRequestCurrentPage(true)
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    // MARK: - Property
    lazy var segmentControl: DSSSegmentControl = {
        let control = DSSSegmentControl.init(imageNames: ["SegmentReserveNormal", "SegmentOnsaleNormal"], selectedImageNames: ["SegmentReserveSelected", "SegmentOnsaleSelected"], titles: ["Reserve", "On Sale"])
        control.backgroundColor = UIColor(white: 0.5, alpha: 1)
        control.delegate = self
        return control
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = UIColor.init(rgb: 0xffffff)
        tableView.registerClass(DSSProductListCell.self, forCellReuseIdentifier: String(DSSProductListCell))
        return tableView
    }()
    
    lazy var emptyTipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x999999)
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = .Center
        label.text = "No Data"
        label.hidden = true
        return label
    }()
    
    lazy var viewModel: DSSProductListViewModel = {
        let viewModel = DSSProductListViewModel.init()
        viewModel.listType = DSSProductListType.WaitSale
        return viewModel
    }()
}

