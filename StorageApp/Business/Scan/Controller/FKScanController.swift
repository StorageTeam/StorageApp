//
//  FKScanController.swift
//  JackSwift
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import AVFoundation

class FKScanController: DSSBaseViewController, DSSDataCenterDelegate {
    private static let UPC_VALID_REQUEST          : Int   = 1
    
    var scanRect    : CGRect!
    var observeObj  : AnyObject?
    let session     : AVCaptureSession = AVCaptureSession.init()

    var supplierID  : String?
    var finishBlock : ((resStr: String) -> Void)?
    
    lazy var messageIcon: UIImageView = {
        let view = UIImageView.init()
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.yellowColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.text = "该商品已经存在，请勿重复扫描"
        label.hidden = true
        return label
    }()
    
    lazy var downTipLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(rgb: 0x1fbad6)
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        label.text = "将条形码放入框内，即可自动扫描"
        return label
    }()
    
    lazy var duoshoubangLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.text = "DUO SHOU BANG"
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(supplierID: String?, finish: (resStr: String) -> Void){
        self.init(nibName: nil, bundle: nil)
        self.supplierID  = supplierID
        self.finishBlock = finish
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.setup()
        self.navigationItem.title = "扫码"
    }
    
    // MARK: - DSSDataCenterDelegate
    func networkDidResponseSuccess(identify: Int, header: DSSResponseHeader, response: [String : AnyObject], userInfo: [String : AnyObject]?) {
        if header.code == DSSResponseCode.Normal {
            if let exist = response["data"]?["result"] as? Int {
                if exist == 1 {
                    self.messageLabel.hidden = false
                    NSTimer.scheduledTimerWithTimeInterval(3,
                                                           target: self,
                                                           selector: #selector(self.hideMessageLabel),
                                                           userInfo: nil,
                                                           repeats: false)
                } else {
                    self.messageLabel.hidden = true
                    if let upc = (userInfo?["upc"] as? String) {
                        if self.finishBlock != nil {
                            self.finishBlock!(resStr: upc)
                        }
                    }
                }
            }
        }
    }
    
    func networkDidResponseError(identify: Int, header: DSSResponseHeader?, error: String?, userInfo: [String : AnyObject]?) {
        if let errorString = error {
            self.showText(errorString)
        }
        self.session.startRunning()
    }
    

    // MARK: - Action
    
    func hideMessageLabel() -> Void {
        self.messageLabel.hidden = true
        self.session.startRunning()
    }
    
    func setup() {
        let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch authorizationStatus {
        case .Authorized:
            self.setupScan()
        case .Restricted, .Denied:
            print("访问受限制")
        case .NotDetermined:
            
            weak var weakSelf = self
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (res: Bool) in
                if res == true {
                    weakSelf?.setupScan()
                }else{
                    print("用户拒绝")
                }
            })
        }
    }
    
    func setupScan() {
        
        let length : CGFloat = 260.0
        let x : CGFloat = (CGRectGetWidth(self.view.frame) - length) / 2.0
        let y : CGFloat = (CGRectGetHeight(self.view.frame) - 64 - length) / 2.0
        self.scanRect = CGRectMake(x, y, length, length)
        
        self.sessionAddInput()
        self.sessionAddOutput()
        self.session.startRunning()
    }
    
    func sessionAddInput() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        let input = try AVCaptureDeviceInput.init(device: device)
    
        do {
            let input = try AVCaptureDeviceInput.init(device: device)
            self.session.addInput(input)
            
        } catch let error{
            print("AVCaptureDeviceInput error = \(error)")
        }
    }
    
    func sessionAddOutput() {
        
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        self.session.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = FKScanController.getDefaultMetadataTypes()
        
        let preViewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
        preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        preViewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(preViewLayer, atIndex: 0)
        
        weak var weakSelf = self
        self.observeObj = NSNotificationCenter.defaultCenter().addObserverForName(AVCaptureInputPortFormatDescriptionDidChangeNotification, object: nil, queue: NSOperationQueue.currentQueue()) { (note: NSNotification) in
            metadataOutput.rectOfInterest = preViewLayer.metadataOutputRectOfInterestForRect((weakSelf?.scanRect)!)
        }
        
        let coverView = FKScanCoverView.init(scanRect: self.scanRect!)
        self.view.addSubview(coverView)
        
        coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        self.view.addSubview(self.duoshoubangLabel)
        self.duoshoubangLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-20)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.downTipLabel)
        self.downTipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.scanRect) + 8)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.messageLabel)
        self.messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(CGRectGetMinY(self.scanRect) - 24)
            make.centerX.equalTo(self.view)
        }
    }
    
    deinit{
     
        if self.observeObj != nil{
            NSNotificationCenter.defaultCenter().removeObserver(self.observeObj!)
        }
    }
    
    class func getDefaultMetadataTypes() -> [String]!{
        
        return [AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeAztecCode]
    }
}

extension FKScanController : AVCaptureMetadataOutputObjectsDelegate{
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        
        if metadataObj != nil{
            if let supplierID = self.supplierID {
                self.session.stopRunning()
                DSSScanService.requestUPCExist(FKScanController.UPC_VALID_REQUEST
                    , delegate: self
                    , upc: (metadataObj?.stringValue)!
                    , supplierID: supplierID
                    , userInfo: ["upc" : (metadataObj?.stringValue)!])
            } else {
                if self.finishBlock != nil {
                    self.finishBlock!(resStr: (metadataObj?.stringValue)!)
                }
            }
//            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
