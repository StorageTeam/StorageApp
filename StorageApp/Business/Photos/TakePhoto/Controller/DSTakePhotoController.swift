//
//  JSTakePhotoController.swift
//  JSNoteOnline
//
//  Created by jack on 16/7/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DSTakePhotoController: DSBaseViewController {
    
    private let topHeight = 44.0
    private let actionViewH = 97.0
    private let imgListH = 90.0
    var maxImgCount = 30
    
    private var imageArray: [UIImage] = []
    private var finshColsure: ((images: [UIImage]) -> Void)?
    private var cancelColsure: (() -> Void)?
    
    convenience init(title: String,
                     takeDonePicture: ([UIImage] -> Void)?,
                     cancel:( ()->Void )?) {
        self.init()
        self.topView.titleLabel.text = title
        self.finshColsure = takeDonePicture
        self.cancelColsure = cancel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAllSubviews()
        self.prepare()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.checkAuthority()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.session.stopRunning()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
    }

    private func addAllSubviews() {
        
        self.previewLayer.frame = self.backLayer.bounds;
        self.backLayer.addSublayer(self.previewLayer)
        
        self.view.layer.addSublayer(self.backLayer)
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.photoListView)
        self.view.addSubview(self.actionView)
        
        self.topView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(topHeight)
        }
        
        self.photoListView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.actionView.snp_top)
            make.height.equalTo(90)
        }
        
        self.actionView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(actionViewH)
        }
    }
    
    private func prepare() {
        
        if self.session.canAddInput(self.videoInput) {
            self.session.addInput(self.videoInput)
        }
        
        if self.session.canAddOutput(self.imageOutput) {
            self.session.addOutput(self.imageOutput)
        }
    }
    
    private func checkAuthority() {
    
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch status {
            case .Authorized:
                self.actionView.takePhotoBtn.userInteractionEnabled = true
                self.session.startRunning()
            case .NotDetermined:
                weak var weakSelf = self
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (res: Bool) in
                    if res {
                        weakSelf!.session.startRunning()
                        weakSelf!.actionView.takePhotoBtn.userInteractionEnabled = true
                    } else {
                        weakSelf!.actionView.takePhotoBtn.userInteractionEnabled = false
                    }
    
                })
            case .Restricted, .Denied:
                let alert = UIAlertView.init(title: nil, message: "无法使用相机，请前往设置打开", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                self.actionView.takePhotoBtn.userInteractionEnabled = false
        }

    }
    
    // MARK: - action
    @objc private func clickCancelBtn() {
        if self.cancelColsure != nil {
            self.cancelColsure!()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @objc private func clickFinishBtn() {
        guard self.imageArray.count > 0 else {
            self.showText("至少选择一张照片")
            return
        }
        
        if self.finshColsure != nil {
            self.finshColsure!(images: self.imageArray)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @objc private func clickTakePhoto() {

        if self.imageArray.count >= self.maxImgCount {
//            let warnStr = String.init(format: "最多添加%d张照片", self.maxImgCount)
            self.showText("最多添加30张照片")
            return
        }
        
        // 防止重复多次点击
        self.actionView.takePhotoBtn.userInteractionEnabled = false
        
        let connection = self.imageOutput.connectionWithMediaType(AVMediaTypeVideo)
        let curDeviceOri = UIDevice.currentDevice().orientation
        let avOrientation = self.avOrientationForDeviceOrientation(curDeviceOri)
        connection.videoOrientation = avOrientation
        connection.videoScaleAndCropFactor = 1
     
        weak var weakself = self
        self.imageOutput.captureStillImageAsynchronouslyFromConnection(connection) { (sampBuffer: CMSampleBuffer!, error: NSError!) in
            
            if weakself != nil {
                weakself!.actionView.takePhotoBtn.userInteractionEnabled = true
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampBuffer)
                let image = UIImage.init(data: imageData)
                if image != nil {
                    weakself?.takeOnePicture(image!)
                }
            }
        }
    }
    
    private func takeOnePicture(image: UIImage) {
        
        let sizeImg = image.dss_thumImageFromCenter(self.backLayer.bounds.size)
        self.imageArray.append(sizeImg)
        self.photoListView.reloadData(self.imageArray, scrollToLast: true)
        
        // 保存图片
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ 
            PHAssetChangeRequest.creationRequestForAssetFromImage(sizeImg)
            }, completionHandler: nil)
    }
    
    private func avOrientationForDeviceOrientation(deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation{
        switch deviceOrientation {
        case .Portrait, .FaceUp, .FaceDown:
            return .Portrait
        case .PortraitUpsideDown:
            return .PortraitUpsideDown
        case .LandscapeLeft:
            return .LandscapeRight
        case .LandscapeRight:
            return .LandscapeLeft
        case .Unknown:
            return .Portrait
        }
    }
    
    // MARK: - property
    lazy var session: AVCaptureSession = {
        let session = AVCaptureSession.init()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        return session
    }()
    
    lazy var device: AVCaptureDevice = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            try device.lockForConfiguration()
        } catch {
//            throw myerror.JSDeviceLockError
        }

        device.flashMode = .Auto
        device.unlockForConfiguration()
        return device
    }()

    lazy var videoInput: AVCaptureDeviceInput? = {
        do {
            let input = try AVCaptureDeviceInput.init(device: self.device)
            return input
        } catch {
            
        }
        return nil
    }()
    
    lazy var imageOutput: AVCaptureStillImageOutput = {
       let output = AVCaptureStillImageOutput.init()
        let outputSet = [AVVideoCodecKey : AVVideoCodecJPEG]
        output.outputSettings = outputSet
        return output
    }()
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
       let prelayer = AVCaptureVideoPreviewLayer.init(session: self.session)
        prelayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return prelayer
    }()
    
    lazy var backLayer : CALayer = {
        let layer = CALayer.init()
        layer.frame = CGRectMake(0, 44, DSConst.UISCREENWIDTH, DSConst.UISCREENHEIGHT - CGFloat(self.topHeight) - CGFloat(self.actionViewH) - CGFloat(self.imgListH))
        layer.masksToBounds = true
        
        return layer
    }()
    
    lazy var actionView: FKTakePhotoActionView = {
        
        let view = FKTakePhotoActionView.init()
        view.takePhotoBtn.addTarget(self, action: #selector(self.clickTakePhoto), forControlEvents: .TouchUpInside)
        view.cancelBtn.addTarget(self, action: #selector(self.clickCancelBtn), forControlEvents: .TouchUpInside)
        view.finishBtn.addTarget(self, action: #selector(self.clickFinishBtn), forControlEvents: .TouchUpInside)
        
        return view
    }()
    
    lazy var topView: FKTakePhotoTopView = {
       let view = FKTakePhotoTopView.init()
        view.titleLabel.text = "DSU93U02U3"
        return view
    }()
    
    lazy var photoListView: FKPhotoListView = {
       let view = FKPhotoListView.init()
        view.maxCount = self.maxImgCount
        
        weak var weakSelf = self
        view.removeClosure = {
            (index: Int) -> () in
            
            guard index >= 0 && index < weakSelf!.imageArray.count else {
                return
            }
            weakSelf!.imageArray.removeAtIndex(index)
            weakSelf!.photoListView.reloadData(weakSelf!.imageArray, scrollToLast: false)
        }
        
        return view
    }()
}
