//
//  INCameraContainerView.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import UIKit
import AVFoundation

protocol INCameraContainerViewViewControllerDelegate: class {
    
    func cameraShotFinished(image: UIImage?)
    func cameraWillAppear(result:INCameraContainerView.AVCamSetupResult)
}



protocol INCameraContainerViewDisplayDelegate: class {
   
    func flashButtonEnabled(enabled: Bool)
    func captureButtonEnabled(enabled: Bool)
    func flipButtonEnabled(enabled: Bool)

}


final class INCameraContainerView: UIView, UIGestureRecognizerDelegate {
    
    
    enum AVCamSetupResult {
        case Success
        case CameraNotAuthorized
        case SessionConfigurationFailed
    }
    
    var setupResult: AVCamSetupResult

    
    
    weak var viewControllerDelegate: INCameraContainerViewViewControllerDelegate?
    weak var displayDelegate: INCameraContainerViewDisplayDelegate?
    
    
    
    var previewViewContainer: UIView?
    var finalViewContainer: UIImageView?
    
//    var captureSession: AVCaptureSession?
//    var imageOutput: AVCaptureStillImageOutput?

    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var focusView: UIView?
    
    
    
//     Used in  init:withFullFrame
    let session:AVCaptureSession // = AVCaptureSession()
    let stillImageOutput:AVCaptureStillImageOutput //  = AVCaptureStillImageOutput()
    //    var error: NSError?
    
    
    let sessionQueue: dispatch_queue_t
    

    init(withFullFrame frame: CGRect) {
        
        print("INCamera init")
        session = AVCaptureSession()
        stillImageOutput = AVCaptureStillImageOutput()

         sessionQueue = dispatch_queue_create("Camera.SessionQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0))
        
        setupResult = .Success
        
        super.init(frame: frame)
        
        // Check video authorization status. Video access is required and audio access is optional.
        // If audio access is denied, audio is not recorded during movie recording.
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            // The user has previously granted access to the camera.
            break
        case .NotDetermined:
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            dispatch_suspend(sessionQueue)
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) in
                if !granted {
                    self.setupResult = .CameraNotAuthorized
                }
                dispatch_resume(self.sessionQueue)
            })
        default:
            setupResult = .CameraNotAuthorized;

        }
        
        // Setup the capture session.
        // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
        // Why not do all of this on the main queue?
        // Because -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue
        // so that the main queue isn't blocked, which keeps the UI responsive.
        dispatch_async(sessionQueue, {

            print("INCamera init dispatch_async sessionQueue")
            if self.setupResult != .Success {
                return
            }

            
            let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Back }
            
            if let captureDevice = devices.first as? AVCaptureDevice  {
               
                self.device = captureDevice
                

                do {
                    print("INCamera init beginConfiguration")

                    self.session.beginConfiguration()
                    try self.session.addInput(AVCaptureDeviceInput(device: captureDevice))
                    
                    
                    self.session.sessionPreset = AVCaptureSessionPresetPhoto

                    if self.session.canAddOutput(self.stillImageOutput) {
                        self.stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                        self.session.addOutput(self.stillImageOutput)
                    }
                    print("INCamera session canAddOutput")

    //                self.session.startRunning()
    //                print("session.startRunning()")

                    
    //                previewViewContainer = UIView(frame: bounds)
    //                self.addSubview(previewViewContainer!)
                    

                    if let previewLayer = AVCaptureVideoPreviewLayer(session: self.session) {
                        
                        dispatch_async(dispatch_get_main_queue(), {

                            let cameraFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)
                            previewLayer.bounds = self.bounds
                            previewLayer.position = CGPointMake(self.bounds.midX, self.bounds.midY)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            self.previewViewContainer = UIView(frame: cameraFrame)
                            self.previewViewContainer!.layer.addSublayer(previewLayer)
                            self.addSubview(self.previewViewContainer!)
                            
                            let finalViewContainerFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)

                            self.finalViewContainer = UIImageView(frame: finalViewContainerFrame)
                            self.finalViewContainer?.alpha = 0.0
                            self.finalViewContainer!.contentMode = .ScaleAspectFill

                            self.addSubview(self.finalViewContainer!)
                        
                        })
                        
                        self.session.commitConfiguration()
                        print("INCamera session commitConfiguration")
                    }
                    
                } catch _ {
                    print("INCameraContainerView session.addInput Error")
                }
                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(INCameraContainerView.willEnterForegroundNotification(_:)),
                                                                 name: UIApplicationWillEnterForegroundNotification,
                                                                 object: nil)
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    
    func cameraWillAppear() {
        print("cameraWillAppear")

        dispatch_async(sessionQueue, {
            print("sessionQueue")

            switch self.setupResult {
            case .Success:

                // Only setup observers and start the session running if setup succeeded.
//                [self addObservers];
                print("session.startRunning()")
                self.session.startRunning()
//                self.sessionRunning = self.session.isRunning
                dispatch_async(dispatch_get_main_queue(), {
                    self.cameraControlsSetup()
                })
                
            case .CameraNotAuthorized:
                dispatch_async(dispatch_get_main_queue(), { 
                    self.viewControllerDelegate?.cameraWillAppear(.CameraNotAuthorized)
                })
            case .SessionConfigurationFailed:
                dispatch_async(dispatch_get_main_queue(), { 
                    self.viewControllerDelegate?.cameraWillAppear(.SessionConfigurationFailed)
                })
            }
        })
        
    }
    
    
    
    func restartCamera() {
        
        viewControllerDelegate?.cameraShotFinished(nil)
        self.finalViewContainer?.image = nil
        self.finalViewContainer?.alpha = 0.0
        
        
        if !session.running {
            session.startRunning()
        }
        displayDelegate?.captureButtonEnabled(true)
    }
    
    
    func cameraControlsSetup() {
        print("cameraControlsSetup")

        displayDelegate?.captureButtonEnabled(true)
        setFlashConfigurationOff()

        if cameraHasFlash() {
            displayDelegate?.flashButtonEnabled(true)
        } else {
            displayDelegate?.flashButtonEnabled(false)
        }
        
        if cameraHasFrontCamera() {
            displayDelegate?.flipButtonEnabled(true)
            
        } else {
            displayDelegate?.flipButtonEnabled(false)
        }
    }
    
    
    deinit {
        print("deinit NSNotificationCenter")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func willEnterForegroundNotification(notification: NSNotification) {
        print("willEnterForegroundNotification")
        if setupResult == .Success {
            session.startRunning()
        } else {
            session.stopRunning()
        }
    }
    
    
    
    
    func save(imageData: NSData) {
        
        UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)

    }
    
    
    func takePhoto() {
        
        displayDelegate?.captureButtonEnabled(false)

        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            
            dispatch_async(sessionQueue, {
                
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                    
                    self.session.stopRunning()

                    if error == nil && CMSampleBufferIsValid(imageDataSampleBuffer) {
                      
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                        if let image = UIImage(data: imageData), let delegate = self.viewControllerDelegate {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.finalViewContainer?.image = image
                                self.finalViewContainer?.alpha = 1.0
                                delegate.cameraShotFinished(image)
                            })
                        }
                    } else {
                        
                        if !self.session.running {
                            self.session.startRunning()
                        }
                        self.displayDelegate?.captureButtonEnabled(true)
                    
                        print("INCameraContainreView error: \(error)")
                        print("INCameraContainreView error: \(error.description)")
                        print("Send delegate an error message")
                        
                    }
                })
            })
        } else {
            displayDelegate?.captureButtonEnabled(true)
        }
    }
    
    
    
    
    /*  ====================================================================================
        ====================================================================================
                    Flip Camera Functions
        ====================================================================================
        ====================================================================================
     */
    
    /*
     *  Determines if the camera has a front camera
     *  and if so, then flipButton will be enabled
     */
    func cameraHasFrontCamera() -> Bool {
        
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Front }
        
        if let _ = devices.first as? AVCaptureDevice  {
            
            return true
        }
        
        return false
    }
    
    
    /*  
     *  All buttons should be disabled (except for cancel button)
     *  before this func is called.
     *  
     *  On success the camera will flip, 
     *  Returns successfully flipped and the camera orientation
     *
     
     */
    func flipButtonPressed() -> (flipped: Bool, position: AVCaptureDevicePosition?) {

        var didFlip = false
        var deviceInputPosiiton: AVCaptureDevicePosition?
      
        session.stopRunning()

        do {
            session.beginConfiguration()

            for input in session.inputs {
                session.removeInput(input as! AVCaptureInput)
            }

            deviceInputPosiiton = videoInput?.device.position == .Front ? .Back : .Front
            
            let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == deviceInputPosiiton }
            
            if let device = devices.first as? AVCaptureDevice  {
                videoInput = try AVCaptureDeviceInput(device: device)
                session.addInput(videoInput)
                didFlip = true
            }

            session.commitConfiguration()


        } catch {

        }

        session.startRunning()
      
        return (didFlip, deviceInputPosiiton)
    }
    
    
    /*  ====================================================================================
        ====================================================================================
                        Flash Functions
        ====================================================================================
        ====================================================================================
     */
    
    /*
     * Returns true if camera has flash
     * False otherwise
     */
    func cameraHasFlash() -> Bool {
        
        if let device = device {
            guard device.hasFlash else { return false }
            return true
        }
        return false
    }

    
    /*
     * Returns the current flash mode
     * nil on error
     */
    func flashModeStatus() -> AVCaptureFlashMode? {
        
        if let device = device {
            guard device.hasFlash else { return nil }
            return device.flashMode
        }
        return nil
    }
    
    
    /*
     * Can set the flash mode to on/off/auto
     * Return: true if successful changing modes
     */
    func setFlashMode(mode: AVCaptureFlashMode) -> Bool {
        
        do {
            if let device = device {
                guard device.hasFlash else { return false }
                try device.lockForConfiguration()
                device.flashMode = mode
                device.unlockForConfiguration()
                return true
            }
            return false
        } catch {
            return false
        }
    }
    

//    func setFlashConfigurationOn() {
//        
//        if let device = device {
//            
//            guard device.hasFlash else { return }
//            do {
//                try device.lockForConfiguration()
//                device.flashMode = .On
//                device.unlockForConfiguration()
//            }
//            catch _ {
//                return
//            }
//        }
//    }

    
    /*
     * Sets flash off
     */

    func setFlashConfigurationOff() {
        
        if let device = device {
            guard device.hasFlash else { return }
            
            do {
                try device.lockForConfiguration()
                device.flashMode = .Off
                device.unlockForConfiguration()
                
            } catch _ { return }
        }
    }

    
//    /*
//     *  Returns nil if flash is not available
//     *  Else returns the status of flash
//     */
//    
//    func isFlashModeOn() -> Bool? {
//        
//        var flashModeOn: Bool?
//        do {
//            if let device = device {
//                
//                guard device.hasFlash else { return nil}
//                
//                try device.lockForConfiguration()
//                let mode = device.flashMode
//                if mode == .Off {
//                    flashModeOn = false
//                } else if mode == .On {
//                    flashModeOn = true
//                }
//                device.unlockForConfiguration()
//
//                return flashModeOn
//            }
//            
//        } catch _ {
//            return nil
//        }
//        
//        return nil
//    }
    
    
    /*
     *  Turns flash mode on/off and returns the status
     *  Returns nil if camera if not available
     */
    func flashButtonPressed() -> AVCaptureFlashMode? {

        do {
            if let device = device {
                guard device.hasFlash else { return nil }
                try device.lockForConfiguration()
                device.flashMode = ( device.flashMode == .On ) ? .Off : .On
                device.unlockForConfiguration()
                return device.flashMode
            }
        } catch _ {
            return nil
        }
        return nil
    }
    
    
}

 extension CameraContainerView {
    
    //    @objc func focus(recognizer: UITapGestureRecognizer) {
    //
    //        let point = recognizer.locationInView(self)
    //        let viewsize = self.bounds.size
    //        let newPoint = CGPoint(x: point.y/viewsize.height, y: 1.0-point.x/viewsize.width)
    //
    //        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    //
    //        do {
    //
    //            try device.lockForConfiguration()
    //
    //        } catch _ {
    //
    //            return
    //        }
    //
    //        if device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) == true {
    //
    //            device.focusMode = AVCaptureFocusMode.AutoFocus
    //            device.focusPointOfInterest = newPoint
    //        }
    //
    //        if device.isExposureModeSupported(AVCaptureExposureMode.ContinuousAutoExposure) == true {
    //
    //            device.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
    //            device.exposurePointOfInterest = newPoint
    //        }
    //
    //        device.unlockForConfiguration()
    //
    //        self.focusView?.alpha = 0.0
    //        self.focusView?.center = point
    //        self.focusView?.backgroundColor = UIColor.clearColor()
    //        self.focusView?.layer.borderColor = UIColor.redColor().CGColor
    //        self.focusView?.layer.borderWidth = 1.0
    //        self.focusView!.transform = CGAffineTransformMakeScale(1.0, 1.0)
    //        self.addSubview(self.focusView!)
    //
    //        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.8,
    //                                   initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseIn, // UIViewAnimationOptions.BeginFromCurrentState
    //            animations: {
    //                self.focusView!.alpha = 1.0
    //                self.focusView!.transform = CGAffineTransformMakeScale(0.7, 0.7)
    //            }, completion: {(finished) in
    //                self.focusView!.transform = CGAffineTransformMakeScale(1.0, 1.0)
    //                self.focusView!.removeFromSuperview()
    //        })
    //    }
    //
    //    func flashConfiguration() {
    //
    //        do {
    //
    //            if let device = device {
    //
    //                guard device.hasFlash else { return }
    //
    //                try device.lockForConfiguration()
    //                
    //                device.flashMode = AVCaptureFlashMode.Off
    //                flashButton.setImage(UIImage(named: "ic_flash_off", inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    //                
    //                device.unlockForConfiguration()
    //                
    //            }
    //            
    //        } catch _ {
    //            
    //            return
    //        }
    //    }
    //    
//    
//    func cameraIsAvailable() -> Bool {
//        
//        print("cameraIsAvailable")
//        
//        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
//        
//        if status == AVAuthorizationStatus.Authorized {
//            
//            return true
//        }
//        
//        return false
//    }
}
