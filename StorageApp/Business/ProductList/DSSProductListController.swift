//
//  ViewController.swift
//  StorageApp
//
//  Created by ascii on 16/6/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSProductListController: DSSBaseViewController, DSSSegmentControlDelegate, DSSDataCenterDelegate, UITableViewDataSource, UITableViewDelegate {
    static let PRODUCTLIST_ONSALE_REQUEST          : Int   = 0
    static let PRODUCTLIST_ONSALE_NEXT_REQUEST     : Int   = 1
    static let PRODUCTLIST_WAITSALE_REQUEST        : Int   = 2
    static let PRODUCTLIST_WAITSALE_NEXT_REQUEST   : Int   = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Item Managerment"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if DSSAccount.isLogin() {
            if self.viewModel.isEmpty() {
                DSSProductListService.requestList(DSSProductListController.PRODUCTLIST_ONSALE_REQUEST,
                                                  delegate: self,
                                                  status: "2",
                                                  startRow: "0")
                DSSProductListService.requestList(DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST,
                                                  delegate: self,
                                                  status: "1",
                                                  startRow: "0")
            }
        } else {
            let controller = DSSLoginController()
            self.navigationController?.presentViewController(controller, animated: true, completion: {});
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Edit, target: self, action: #selector(clickButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Request
//    func requestData(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            let (total, items) = DSSProductListService.parseList(response)
            print(total)
            
            switch identify {
            case DSSProductListController.PRODUCTLIST_ONSALE_REQUEST:
                self.viewModel.append(items, type: DSSProductListType.WaitSale)
                break
//            case DSSProductListController.PRODUCTLIST_ONSALE_NEXT_REQUEST:
//            case DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST:
//            case DSSProductListController.PRODUCTLIST_WAITSALE_NEXT_REQUEST:
            default:
                print("a")
            }
            self.tableView.reloadData()
        } else {
            
        }
    }
    
    // MARK: - DSSSegmentControlDelegate
    func segmentControlDidSelected(control: DSSSegmentControl, index: Int) {
        print(index)
        
        DSSProductListService.requestList(DSSProductListController.PRODUCTLIST_WAITSALE_REQUEST,
                                          delegate: self,
                                          status: "2",
                                          startRow: "0")
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
            return cell
        }
        return UITableViewCell.init()
    }
    
    // MARK: - Action
    func clickButton(sender: UIButton){
        print("push eidt")
        let editController = EditViewController()
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    // MARK: - Method
    
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
        self.tableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(line.snp_bottom)
        }
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
    
    lazy var viewModel: DSSProductListViewModel = {
        let viewModel = DSSProductListViewModel.init()
        viewModel.listType = DSSProductListType.WaitSale
        return viewModel
    }()
}

