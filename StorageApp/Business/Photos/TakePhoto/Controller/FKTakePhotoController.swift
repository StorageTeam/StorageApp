//
//  JSTakePhotoController.swift
//  JSNoteOnline
//
//  Created by jack on 16/7/25.
//  Copyright © 2016年 FirstLink. All rights reserved.
//

import UIKit
import AVFoundation

enum myerror: ErrorType {
    case JSDeviceLockError
    case JSDeviceInputInitError
}

class FKTakePhotoController: DSSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepare()
        self.addAllSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        // 获取权限
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch status {
        case .Authorized:
            self.session.startRunning()
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (res: Bool) in
                if res {
                    self.session.startRunning()
                }
            })
        case .Restricted:
            print("使用相机受限")
        default:
            print("用户未授权使用相机")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.session.stopRunning()
    }

    private func addAllSubviews() {
        
        self.previewLayer.frame = self.backLayer.bounds;
        self.backLayer.addSublayer(self.previewLayer)
        self.view.layer.addSublayer(self.backLayer)
        
        self.view.addSubview(self.takePhotoBtn)
        self.view.addSubview(self.actionView)
        
        self.takePhotoBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-35)
            make.size.equalTo(CGSizeMake(100, 50))
        }
        
        self.actionView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(100)
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
    
    // MARK: - action
    @objc private func clickTakePhoto() {
        
//        let curDeviceOrientation = UIDevice.currentDevice().orientation
//        switch curDeviceOrientation {
//        case .Portrait:
//            print("cur device = Portrait")
//        case .PortraitUpsideDown:
//            print("cur device = PortraitUpsideDown")
//        case .LandscapeLeft:
//            print("cur device = LandscapeLeft")
//        case .LandscapeRight:
//            print("cur device = LandscapeRight")
//        case .FaceDown:
//            print("cur device = FaceDown")
//        case .FaceUp:
//            print("cur device = FaceUp")
//        default:
//            print("cur device = unkown")
//            break
//        }
//
//        weak var weakself = self
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
//            weakself?.clickTakePhoto()
//        }
//        
//        return
        let connection = self.imageOutput.connectionWithMediaType(AVMediaTypeVideo)
        let curDeviceOri = UIDevice.currentDevice().orientation
        let avOrientation = self.avOrientationForDeviceOrientation(curDeviceOri)
        connection.videoOrientation = avOrientation
        connection.videoScaleAndCropFactor = 1
     
        weak var weakself = self
        self.imageOutput.captureStillImageAsynchronouslyFromConnection(connection) { (sampBuffer: CMSampleBuffer!, error: NSError!) in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampBuffer)
            let image = UIImage.init(data: imageData)
            if image != nil {
                weakself?.pushViewController(image!)
            }
        }
    }
    
    private func pushViewController(image: UIImage) {
        
//        let show = ShowImgController.init(image: image)
//        self.navigationController?.pushViewController(show, animated: true)
        
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
        layer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 160)
        layer.masksToBounds = true
        
        return layer
    }()
    
    lazy var actionView: FKCircleBgView = {
        let view = FKCircleBgView.init(frame: CGRectZero)
        return view
    }()

    lazy var takePhotoBtn: UIButton = {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("take photo", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(self.clickTakePhoto), forControlEvents: .TouchUpInside)
        return button
    }()
    

   
}
