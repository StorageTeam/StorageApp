//
//  FKBuyingController.swift
//  StorageApp
//
//  Created by jack on 16/8/26.
//  Copyright © 2016年 DSB. All rights reserved.
//

import UIKit

class DSSBuyingController: DSSBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DSSDataCenterDelegate{

    var missionItem: DSSMissionItem?
    var finishBlock: (Bool -> Void)?
    
    let reqSuccessIdentify = 2001
    let reqFailIdentify = 2002
    
    convenience init(missionItem: DSSMissionItem, finish: (Bool -> Void)?) {
        self.init()
        self.missionItem = missionItem
        self.finishBlock = finish
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllSubviews()
        self.addTapGesture()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "采购任务"
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapGestureClick(_:)))
        //        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func addAllSubviews() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    //MARK: - Response
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        
        self.hidHud(true)
        if header.code == DSSResponseCode.Normal {
            if identify == reqSuccessIdentify {
                if self.finishBlock != nil {
                    self.finishBlock!(true)
                }
            } else if identify == reqFailIdentify {
                if self.finishBlock != nil {
                    self.finishBlock!(false)
                }
            }
         }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        
        self.hidHud(true)
        if let errorString = error {
            self.showText(errorString)
        }
    }

    //MARK: tableView datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            if let proCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingProCell)) as? DSSBuyingProCell {
                proCell.proImgView.dss_setImageFromURLString((missionItem?.firstPic)!, cdnWidth: DSSBuyingProCell.imgCdnWidth())
                proCell.titleLabel.text = missionItem?.title
                return proCell
            }
            
        } else if (indexPath.section == 1){
            if let countCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingCountCell)) as? DSSBuyingCountCell {
                countCell.buyCountField.text = String.init(format: "%@", (missionItem?.quantity)!)
                countCell.buyCountField.delegate = self
                countCell.waitCountLabel.text = String.init(format: "待采购数%@", (missionItem?.quantity)!)
                return countCell
            }
  
        } else if (indexPath.section == 2) {
            if let confirmCell = tableView.dequeueReusableCellWithIdentifier(String(DSSBuyingBtnCell)) as? DSSBuyingBtnCell {
                confirmCell.buyButton.addTarget(self,
                                                action: #selector(self.clickConfirmBtn),
                                                forControlEvents: .TouchUpInside)
                
                confirmCell.failBtn.addTarget(self,
                                              action: #selector(self.clickFailBtn),
                                              forControlEvents: .TouchUpInside)
                return confirmCell
            }
        }
        return UITableViewCell.init(style: .Default, reuseIdentifier: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 100.0
        } else if (indexPath.section == 1) {
            return 60
        } else if (indexPath.section == 2) {
            return 45;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(DSSBuyingHeaderView)) as? DSSBuyingHeaderView{
                header.titleLabel.text = "商品信息"
                return header
            }
        } else if (section == 1) {
            if let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(DSSBuyingHeaderView)) as? DSSBuyingHeaderView{
                header.titleLabel.text = "采购统计"
                return header
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    //MARK: Request
    
    func reqMissionSuccess() {
        if self.missionItem?.goodsID != nil {
            self.showHUD()
            DSSBuyingServe.reqMissionSuccess(reqSuccessIdentify,
                                             goodsID: (self.missionItem?.goodsID)!,
                                             quality: self.getInputNum(),
                                             delegate: self)
        }
    }
    
    func reqMissionFail() {
        if self.missionItem?.goodsID != nil {
            self.showHUD()
            DSSBuyingServe.reqMissionFail(reqFailIdentify,
                                          goodsID: (self.missionItem?.goodsID)!,
                                          delegate: self)
        }
    }
    
    
    //MARK: action
    
    func tapGestureClick(sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func clickConfirmBtn() {
        
        self.view.endEditing(true)
        
        let inputNum = self.getInputNum()
        if inputNum <= 0 {
            self.showText("采购数量必须大于0")
            return
        }
        
        if inputNum > Int((self.missionItem?.quantity)!)! {
            self.showText("采购数量不能大于待采购数")
            return
        }
        
        self.showAlertWith(String.init(format: "本次采购数量%ld", inputNum), tag: 0)
    }
    
    func clickFailBtn() {
        
        self.view.endEditing(true)
        self.showAlertWith("确认采购失败", tag: 1)
    }

    //MARK: - textField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text != nil) {
            let inputNum = Int(textField.text!)
            if inputNum  <= 1 {
                textField.text = "1"
            }
        } else {
            textField.text = "1"
        }
    }
    
    //MARK: - method
    func getInputNum() -> Int {
        var num = 0
        for cell in self.tableView.visibleCells {
            if let countCell = cell as? DSSBuyingCountCell {
                num = Int(countCell.buyCountField.text!)!
                break
            }
        }
        return num
    }
    
    func showAlertWith(title: String?, tag: Int) {
        let alertController = UIAlertController.init(title: nil, message: title, preferredStyle: .Alert)
//        alertController.view.tag = tag
        let action0 = UIAlertAction.init(title: "确认", style: UIAlertActionStyle.Default) { (action) in
            if tag == 0 {
                self.reqMissionSuccess()
            } else if tag == 1 {
                self.reqMissionFail()
            }
         }
        
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel) { (action) in
            
        }
        alertController.addAction(action0)
        alertController.addAction(action1)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - property
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        table.delegate = self
        table.dataSource = self
        table.scrollEnabled = false
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        
        table.registerClass(DSSBuyingProCell.self, forCellReuseIdentifier: String(DSSBuyingProCell))
        table.registerClass(DSSBuyingCountCell.self, forCellReuseIdentifier: String(DSSBuyingCountCell))
        table.registerClass(DSSBuyingBtnCell.self, forCellReuseIdentifier: String(DSSBuyingBtnCell))
        table.registerClass(DSSBuyingHeaderView.self, forHeaderFooterViewReuseIdentifier: String(DSSBuyingHeaderView))
        return table
    }()

}
