//
//  FKBuyMissionController.swift
//  StorageApp
//
//  Created by jack on 16/8/24.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class DSBuyMissionController: DSBaseViewController, UITableViewDelegate, UITableViewDataSource, DSDataCenterDelegate, UIGestureRecognizerDelegate {
    var naviController : UINavigationController?
    var isReceiveOrderOn : Bool!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.naviController = nil
        self.isReceiveOrderOn = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.configNavItem()
        self.addRefresh()
        self.requestDataList()
        
        if self.naviController == nil {
            self.naviController = self.navigationController
        }
    }

    func addAllSubviews() {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(self.deliverButton)
        self.deliverButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.bottom.equalTo(self.view).offset(-20)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        self.deliverButton.layer.cornerRadius = 30
        
        self.tableView.addSubview(self.emptyView)
        self.emptyView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func addRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pullRequestCurrentPage(true)
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
    }
    
    func pullRequestCurrentPage(isPullDown: Bool) -> Void {
        self.requestDataList()
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    //MARK: - Request
    func requestDataList() {
        DSMissionServe.reqMissionList(2000, delegate: self)
    }
    
    
    //MARK: - Response
    func networkDidResponseSuccess(identify: Int, header: DSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
        self.hidHud(false)
        self.tableView.dg_stopLoading()
        
        if header.code == DSResponseCode.Normal {
            if identify == 2000 {
                self.viewModel.orginDataArray = DSMissionServe.parserMissionList(response)
                self.refreshEmptyView(self.isReceiveOrderOn)
                self.tableView.reloadData()
            }
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        
        self.hidHud(false)
        self.tableView.dg_stopLoading()
        
//        if let errorString = error {
//            self.showText(errorString)
//        }
        self.refreshEmptyView(self.isReceiveOrderOn)
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
        
        let missionItem = self.viewModel.missionItemAtIndex(indexPath.section)
        
        if (indexPath.row == 1) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSBuyMissionCell)) as? DSBuyMissionCell
            
            if (cell != nil && missionItem != nil) {
                cell?.fk_configWith(missionItem!, indexPath: indexPath)
                cell?.buyButton.tag = indexPath.section
                cell?.buyButton.addTarget(self,
                                          action: #selector(self.clickBuy(_:)),
                                          forControlEvents: .TouchUpInside)
            }
            return cell!
        } else if (indexPath.row == 0 && missionItem != nil) {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(DSBuyLocationCell)) as? DSBuyLocationCell
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
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    func configNavItem() {
        
        self.navigationItem.title = "采购任务"
    }
    
    //MARK: Interface
    
    func refreshEmptyView(isReceiveOrder: Bool) -> Void {
        self.isReceiveOrderOn = isReceiveOrder
        self.emptyView.hidden = true
        
        var tipText: String? = nil
        if self.viewModel.orginDataArray?.count == 0 {
            self.emptyView.hidden = false
            tipText = "您没有采购任务哦~\n可尝试下拉刷新试试看"
        }
        if isReceiveOrder == false {
            self.emptyView.hidden = false
            tipText = "您没有采购任务哦~\n可点击右上角\"接单\"按钮开启接单模式"
        }
        
        if let text = tipText {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .Center
            
            let attrText = NSMutableAttributedString(string: text)
            attrText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrText.length))
            self.emptyView.tipLabel.attributedText = attrText
        }
    }
    
    //MARK: action
    
    func clickBack() {
        self.naviController?.popViewControllerAnimated(true)
    }
    
    func clickBuy(sender: UIButton) -> Void {
        let missionItem = self.viewModel.missionItemAtIndex(sender.tag)
        if (missionItem != nil) {
            self.pushBuyingController(missionItem!)
        }
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
    
    func clickDeliverButtonAction(sender: UIButton) {
        let controller = DSDeliverMissionController.init()
        controller.hidesBottomBarWhenPushed = true
        self.naviController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - method
    
    func pushBuyingController(missionItem: DSMissionItem) {
        
        weak var weakSelf = self
        let controller = DSBuyingController.init(missionItem: missionItem) { (finish) in
            weakSelf?.naviController?.popViewControllerAnimated(true)
            weakSelf?.showHUD()
            weakSelf?.requestDataList()
        }
        self.naviController?.pushViewController(controller, animated: true)
    }
    
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
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        table.registerClass(DSBuyMissionCell.self, forCellReuseIdentifier: String(DSBuyMissionCell))
        table.registerClass(DSBuyLocationCell.self, forCellReuseIdentifier: String(DSBuyLocationCell))
        return table
    }()
    
    lazy var choseShopView: DSBuySelectShopView = {
        let view = DSBuySelectShopView()
        view.actionBtn.addTarget(self, action: #selector(self.clickSelectShop), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var shopListView: DSShopListView = {
        let view = DSShopListView.init()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.listHeaderView.actionButton.addTarget(self, action: #selector(clickHideShopListButton), forControlEvents: .TouchUpInside)
        return view
    }()
    
    lazy var emptyView: DSEmptyView = {
        let view = DSEmptyView.init()
        view.hidden = true
        view.userInteractionEnabled = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    lazy var deliverButton: UIButton = {
        var button = UIButton.init(type: UIButtonType.Custom)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitle("前往发货", forState: .Normal)
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.69)
        button.addTarget(self, action: #selector(self.clickDeliverButtonAction), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var viewModel: DSMissionViewModel = {
        let viewModel = DSMissionViewModel()
        return viewModel
    }()
}
