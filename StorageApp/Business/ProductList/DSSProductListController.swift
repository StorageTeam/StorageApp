//
//  ViewController.swift
//  StorageApp
//
//  Created by ascii on 16/6/22.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSProductListController: DSSBaseViewController, DSSSegmentControlDelegate, DSSDataCenterDelegate {
    static let DSS_PRODUCTLIST_REQUEST_IDENTIFY: Int      = 0
    static let DSS_PRODUCTLIST_NEXT_REQUEST_IDENTIFY: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Item Managerment"
        
        DSSProductListService.requestList(DSSProductListController.DSS_PRODUCTLIST_REQUEST_IDENTIFY,
                                          delegate: self,
                                          status: "2",
                                          startRow: "0")
        DSSProductListService.requestList(DSSProductListController.DSS_PRODUCTLIST_REQUEST_IDENTIFY,
                                          delegate: self,
                                          status: "1",
                                          startRow: "0")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if DSSAccount.isLogin() {
//            print("user login")
        } else {
            let controller = DSSLoginController()
            self.navigationController?.presentViewController(controller, animated: true, completion: {});
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Edit, target: self, action: #selector(clickButton))
    }
    
    func clickButton(sender: UIButton){
        print("push eidt")
        let editController = EditViewController()
        self.navigationController?.pushViewController(editController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
    }
    
    // MARK: - DSSSegmentControlDelegate
    func segmentControlDidSelected(control: DSSSegmentControl, index: Int) {
        print(index)
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
        
    }
    
    // MARK: - Property
    lazy var segmentControl: DSSSegmentControl = {
        let control = DSSSegmentControl.init(imageNames: ["SegmentReserveNormal", "SegmentOnsaleNormal"], selectedImageNames: ["SegmentReserveSelected", "SegmentOnsaleSelected"], titles: ["Reserve", "On Sale"])
        control.backgroundColor = UIColor(white: 0.5, alpha: 1)
        control.delegate = self
        return control
    }()
}

