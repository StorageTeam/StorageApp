//
//  EditViewController.swift
//  JackSwift
//
//  Created by jack on 16/6/23.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    private var tableView : UITableView! = nil
    private var viewModel : EditViewModel = EditViewModel()
    
    
    override func viewDidLoad() {
        self.buildTableView()
        self.addAllSubviews()
    }
    
    func addAllSubviews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
    }
    
    private func buildTableView() -> Void{
        self.tableView = UITableView.init(frame: CGRectZero, style: .Grouped)
        self.tableView.backgroundColor = UIColor.colorFromHexStr("f8f8f8")
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .None
        
        self.tableView.registerClass(FKEditInputCell.self, forCellReuseIdentifier: EDIT_COMMON_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditPicCell.self, forCellReuseIdentifier: PIC_CELL_IDENTIFY)
        self.tableView.registerClass(FKSexChooseCell.self, forCellReuseIdentifier: SEX_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditDescCell.self, forCellReuseIdentifier: DESC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditUpcCell.self, forCellReuseIdentifier: UPC_CELL_IDENTIFY)
        self.tableView.registerClass(FKEditHeaderView.self, forHeaderFooterViewReuseIdentifier: EDIT_HEADER_VIEW_IDENTIFY)
    }
    
    func setUpcWithString(string: String){
        
    }
    
    func clickScanAction(sender: UIButton){
        
        weak var weakself = self
        let scanController = FKScanController.init { (resStr) -> Void in
            print("scan res string = \(resStr)")
            weakself?.viewModel.currentUpcStr = resStr
            weakself?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(scanController, animated: true)
    }
}

extension EditViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.viewModel.heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.viewModel.cellIdentifyForIndexPath(indexPath))
        if cell == nil{
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: nil)
        }
        
        if let upcCell = cell as? FKEditUpcCell{
            upcCell.addButton.addTarget(self, action: #selector(self.clickScanAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        cell?.fk_configWith(self.viewModel, indexPath: indexPath);
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(EDIT_HEADER_VIEW_IDENTIFY) as? FKEditHeaderView
        
        if section == 0 {
            headerView?.titleLabel.text = "name&photo"
        } else if section == 1 {
            headerView?.titleLabel.text = "basic information"
        } else if section == 2 {
            headerView?.titleLabel.text = "commodity information"
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
}


