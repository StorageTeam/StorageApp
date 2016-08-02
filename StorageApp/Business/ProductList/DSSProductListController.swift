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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "商品列表"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if DSSAccount.isLogin() && self.viewModel.isEmpty() {
            self.requestWaitSale()
            self.requestOnsale()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Request
    func pullRequestCurrentPage(isPullDown: Bool) -> Void {
        if self.viewModel.listType == DSSProductListType.OnSale {
            self.requestOnsale()
        } else {
            self.requestWaitSale()
        }
    }
    
    func requestWaitSale() -> Void {
        DSSProductListService.requestWaitsaleList(DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST,
                                                  delegate: self,
                                                  startRow: "0")
    }
    
    func requestOnsale() -> Void {
        DSSProductListService.requestOnsaleList(DSSProductListController.PRODUCTLIST_ONSALE_REQUEST,
                                                delegate: self,
                                                startRow: "0")
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if header.code == DSSResponseCode.Normal {
            let (_, waitSaleItems) = DSSProductListService.parseWaitsaleList(response)
            let (_, onSaleItems)   = DSSProductListService.parseOnsaleList(response)
            
            switch identify {
            case DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST:
                self.viewModel.removeAll(DSSProductListType.WaitSale)
                self.viewModel.append(waitSaleItems, type: DSSProductListType.WaitSale)
            case DSSProductListController.PRODUCTLIST_WAITSALE_NEXT_REQUEST:
                self.viewModel.append(waitSaleItems, type: DSSProductListType.WaitSale)
                
            case DSSProductListController.PRODUCTLIST_ONSALE_REQUEST:
                self.viewModel.removeAll(DSSProductListType.OnSale)
                self.viewModel.append(onSaleItems, type: DSSProductListType.OnSale)
            case DSSProductListController.PRODUCTLIST_ONSALE_NEXT_REQUEST:
                self.viewModel.append(onSaleItems, type: DSSProductListType.OnSale)
                
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
            default: break
//                print(total)
            }
            self.reloadData()
        } else {
            
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        self.tableView.dg_stopLoading()
        
        if let errorString = error {
            self.showText(errorString)
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
                    if let model = (self.viewModel.itemAtIndexPath(NSIndexPath.init(forRow: alertView.tag, inSection: 0)) as? DSSProductOnsaleModel) {
                        DSSProductListService.deleteList(DSSProductListController.PRODUCTLIST_DELETE_LIST_REQUEST,
                                                         delegate: self,
                                                         ids: [model.itemID],
                                                         userInfo: ["row"   : alertView.tag,
                                                                    "type"  : self.viewModel.listType.rawValue])
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 154//DSSProductOnsaleCell.height()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellName = String(DSSProductWaitsaleCell)
        if self.viewModel.listType == DSSProductListType.OnSale {
            cellName = String(DSSProductOnsaleCell)
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellName) {
            cell.fk_configWith(self.viewModel, indexPath: indexPath)
            cell.selectionStyle = .None
            
            if let waitSaleCell = cell as? DSSProductWaitsaleCell {
                waitSaleCell.button.addTarget(self,
                                              action: #selector(self.clickEditBtn(_:)),
                                              forControlEvents: .TouchUpInside)
            }
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let model = (viewModel.itemAtIndexPath(indexPath) as? DSSProductOnsaleModel) {
            self.pushEditController(kEditType.kEditTypeCheck, productId: String(model.itemID))
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
            let alert = UIAlertView.init(title: "",
                                         message: "是否确定删除该商品?",
                                         delegate: self,
                                         cancelButtonTitle: "取消",
                                         otherButtonTitles: "确定")
            alert.describeName = DSSProductListController.ALERT_VIEW_DELETE
            alert.tag = indexPath.row
            alert.show()
        }
    }
    
    // MARK: - Action
    @objc private func clickEditBtn(sender: UIButton) {
        
        let indexpath = NSIndexPath.init(forRow: 0, inSection: sender.tag)
        if let model = (viewModel.itemAtIndexPath(indexpath) as? DSSProductWaitsaleModel) {
            self.pushEditController(kEditType.kEditTypeEdit, productId: String(model.itemID))
        }
    }
    
    // MARK: - Method
    func pushEditController(editType: kEditType, productId: String) {
        
        let editType = editType
        let controller = EditViewController.init(editType: editType, productID: productId)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func reloadData() {
        self.tableView.reloadData()
        
        let count = self.viewModel.numberOfSection()
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
        
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRectMake(0, 52, CGRectGetWidth(view.bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64 - 52)
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
        let control = DSSSegmentControl.init(imageNames: ["SegmentReserveNormal", "SegmentOnsaleNormal"],
                                             selectedImageNames: ["SegmentReserveSelected", "SegmentOnsaleSelected"],
                                             titles: [" 待上架", " 已上架"])
        control.delegate = self
        return control
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = UIColor.init(rgb: 0xf4f4f4)
        tableView.registerClass(DSSProductOnsaleCell.self, forCellReuseIdentifier: String(DSSProductOnsaleCell))
        tableView.registerClass(DSSProductWaitsaleCell.self, forCellReuseIdentifier: String(DSSProductWaitsaleCell))
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

