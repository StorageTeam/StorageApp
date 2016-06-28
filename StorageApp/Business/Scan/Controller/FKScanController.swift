//
//  FKScanController.swift
//  JackSwift
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import AVFoundation

class FKScanController: UIViewController {

    let session : AVCaptureSession = AVCaptureSession.init()
    var scanRect: CGRect!
    var finishBlock: ((resStr: String) -> Void)?
    var observeObj : AnyObject?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(finish: (resStr: String) -> Void){
        self.init(nibName: nil, bundle: nil)
        self.finishBlock = finish
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.setup()
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
        
        let margin : CGFloat = 260.0
        let x : CGFloat = (UIScreen.mainScreen().bounds.size.width - 260.0) / 2.0
        let y : CGFloat = 150.0
        self.scanRect = CGRectMake(x, y, margin, margin)
        
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
            self.session.stopRunning()
            
            if self.finishBlock != nil {
               self.finishBlock!(resStr: (metadataObj?.stringValue)!)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
