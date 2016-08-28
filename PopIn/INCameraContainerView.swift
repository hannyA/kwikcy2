//
//  INCameraContainerView.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import UIKit
import AVFoundation
import NVActivityIndicatorView

import pop


protocol INCameraContainerViewViewControllerDelegate: class {
    
    func cameraShotFinished(image: UIImage?, fromCameraSide side: AVCaptureDevicePosition?)
    func cameraWillAppear(result:INCameraContainerView.AVCamSetupResult)
}



protocol INCameraContainerViewDisplayDelegate: class {
   
    func setFlashButtonOn(on: Bool)
    func flashButtonEnabled(enabled: Bool)
    func captureButtonEnabled(enabled: Bool)
    func flipButtonEnabled(enabled: Bool)

}


final class INCameraContainerView: UIView, UIGestureRecognizerDelegate, POPAnimationDelegate {
    
    
    enum AVCamSetupResult {
        case Success
        case CameraNotAuthorized
        case SessionConfigurationFailed
    }
    
    var setupResult: AVCamSetupResult

    
    
    weak var viewControllerDelegate: INCameraContainerViewViewControllerDelegate?
    weak var displayDelegate: INCameraContainerViewDisplayDelegate?
    
    
    
    var previewView: INCameraPreviewView!
    var finalViewContainer: UIImageView?
    
    var videoDeviceInput: AVCaptureDeviceInput?
    let session:AVCaptureSession
    let stillImageOutput:AVCaptureStillImageOutput
    var movieFileOutput: AVCaptureMovieFileOutput?
    
    
    let focusAnimation: FocusAnimationView // NVActivityIndicatorView
//    let focusView: UIView
    
    
    
    private var isSessionRunning = false
    let sessionQueue: dispatch_queue_t
    
    

    init(withFrame frame: CGRect, side position: AVCaptureDevicePosition, allowVideoRecording capability:Bool) {
        
        session = AVCaptureSession()
        stillImageOutput = AVCaptureStillImageOutput()
        sessionQueue = dispatch_queue_create("Camera.SessionQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0))
        
        
        focusAnimation = FocusAnimationView(frame: CGRectMake(0, 0, 10, 10))
        
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

            if self.setupResult != .Success {
                return
            }
            self.session.beginConfiguration()

            /*
             We do not create an AVCaptureMovieFileOutput when setting up the session because the
             AVCaptureMovieFileOutput does not support movie recording with AVCaptureSessionPresetPhoto.
             */
            self.session.sessionPreset = AVCaptureSessionPresetPhoto


            do {
                // Add video input
                let videoDevice = INCameraContainerView.deviceWithMediaType(AVMediaTypeVideo,
                                                                        preferringPosition: position)
                                
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

                if self.session.canAddInput(videoDeviceInput) {
                    self.session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    self.setupResult = .SessionConfigurationFailed
                    self.session.commitConfiguration()
                    return
                }
                
//                // Setup movie file output
//                let movieFileOutput = AVCaptureMovieFileOutput()
//                if self.session.canAddOutput(movieFileOutput) {
//                    self.session.addOutput(movieFileOutput)
//                    let connection = movieFileOutput.connectionWithMediaType(AVMediaTypeVideo)
//                    if connection.supportsVideoStabilization {
//                        connection.preferredVideoStabilizationMode = .Auto
//                    }
//                    self.movieFileOutput = movieFileOutput
//                } else {
//                    print("")
////                    self.setupResult = .SessionConfigurationFailed
//                }

                
                
                // Add audio input.
                do {
                    let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
                    let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                    
                    if self.session.canAddInput(audioDeviceInput) {
                        self.session.addInput(audioDeviceInput)
                    }
                    else {
                        print("Could not add audio device input to the session")
                    }
                }
                catch {
                    print("Could not create audio device input: \(error)")
                }

                
                if self.session.canAddOutput(self.stillImageOutput) {
                    self.stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                    
                    
                    self.session.addOutput(self.stillImageOutput)
                } else {
                    
                    self.setupResult = .SessionConfigurationFailed
                    self.session.commitConfiguration()
                    return
                }
                
                
                let cameraFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)

                self.previewView = INCameraPreviewView(frame: cameraFrame)
//                let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                self.previewView.session = self.session
                
                self.previewView.videoPreviewLayer.bounds = self.bounds
                self.previewView.videoPreviewLayer.position = CGPointMake(self.bounds.midX, self.bounds.midY)
                self.previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill


                let focusGesture = UITapGestureRecognizer(target: self, action: #selector(self.focusAndExposeTap(_:)))
                focusGesture.numberOfTapsRequired = 1
                self.previewView.addGestureRecognizer(focusGesture)
                
                
//                self.previewView.session = self.session

//                self.previewView.videoPreviewLayer.bounds = self.bounds
//                self.previewView.videoPreviewLayer.position = CGPointMake(self.bounds.midX, self.bounds.midY)
               
                
                
                let finalViewContainerFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)

                self.finalViewContainer = UIImageView(frame: finalViewContainerFrame)
                self.finalViewContainer!.alpha = 0.0
                self.finalViewContainer!.contentMode = .ScaleAspectFill

                dispatch_async(dispatch_get_main_queue(), {
                    self.addSubview(self.previewView)
                    self.addSubview(self.finalViewContainer!)
                })
                
                self.session.commitConfiguration()
            
                
            } catch _ {
                print("INCameraContainerView session.addInput Error")
            }
                
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(INCameraContainerView.willEnterForegroundNotification(_:)),
                                                             name: UIApplicationWillEnterForegroundNotification,
                                                             object: nil)
        
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private class func deviceWithMediaType(mediaType: String, preferringPosition position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
       if let videoDevice = AVCaptureDevice.devices().filter({ $0.hasMediaType(AVMediaTypeVideo) && $0.position ==  position }).first as? AVCaptureDevice {
            return videoDevice
        }
        
        return nil
    }
    
    
    func cameraWillAppear() {
        print("===========  cameraWillAppear  =============")
        dispatch_async(sessionQueue, {

            switch self.setupResult {
            case .Success:

                self.addObservers()
                self.session.startRunning()
                self.isSessionRunning = self.session.running
                
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
    
    func cameraWillDisappear() {
        print("===========  cameraWillDisappear  =============")
        dispatch_async(sessionQueue, {
            if self.setupResult == .Success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.running
                self.removeObservers()
            }
        })
    }
    
    func restartCamera() {
        
        print("===========   Restarting Camera   =================")
        
        viewControllerDelegate?.cameraShotFinished(nil, fromCameraSide: nil)
        self.finalViewContainer?.image = nil
        self.finalViewContainer?.alpha = 0.0
        
        
        if !session.running {
            session.startRunning()
            isSessionRunning = session.running
        }
        cameraControlsSetup()
    }
    
    
    func addFocusImage() {
        addSubview(focusAnimation)
    }
    
    func removeFocusImage() {
        focusAnimation.removeFromSuperview()
    }
    
    // Must always run on main queue
    func cameraControlsSetup() {

        // Enable flash button
        enableCameraFlash()
        setFlashButtonMode()
        
        // Enable Flip button
        if supportsMultipleCameras() {
            displayDelegate?.flipButtonEnabled(true)
        } else {
            displayDelegate?.flipButtonEnabled(false)
        }
        
        // Enable capture button

        displayDelegate?.captureButtonEnabled(true)
    }
    
    
    func willEnterForegroundNotification(notification: NSNotification) {
        print("willEnterForegroundNotification")
        if setupResult == .Success {
            session.startRunning()
        } else {
            session.stopRunning()
        }
    }
    
    
    func takePhoto() {
        
        displayDelegate?.captureButtonEnabled(false)
      
        
//        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//        
//        // Update the orientation on the still image output video connection before capturing.
//        connection.videoOrientation = previewLayer.connection.videoOrientation;
//        

//        
//        case Portrait
//        case PortraitUpsideDown
//        case LandscapeRight
//        case LandscapeLeft
        
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            
            let previewLayer = previewView.videoPreviewLayer
            videoConnection.videoOrientation = (previewLayer.connection.videoOrientation)
            
            dispatch_async(sessionQueue, {
                
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                    
//                    self.session.stopRunning()

                    if error == nil && CMSampleBufferIsValid(imageDataSampleBuffer) {
                      
                        
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                        imageData.asdk_animatedImageData()
                        print("Real Original image size: \(imageData.length/1024) kb")
                        
                        if let image = UIImage(data: imageData), let delegate = self.viewControllerDelegate {
                            
                            dispatch_async(dispatch_get_main_queue(), {

                                self.shutterCamera()
                                
//                                
//                                self.finalViewContainer?.image = image
//                                self.finalViewContainer?.alpha = 1.0
//                                delegate.cameraShotFinished(image, fromCameraSide: .Back)
                                

                                if self.videoDeviceInput?.device.position == .Front {
                                    print("device.position == .Front")
                                
                                    // Try 1
//                                    let newImage = image.imageFlippedForRightToLeftLayoutDirection()
//
//                                    self.finalViewContainer?.image = image
//                                    self.finalViewContainer?.alpha = 1.0
//                                    delegate.cameraShotFinished(image, fromCameraSide: .Front)
                                    
                                    // Try 2
//                                    self.finalViewContainer?.image = image
//                                    self.finalViewContainer?.alpha = 1.0
//                                    self.finalViewContainer?.transform = CGAffineTransformMakeScale(-1, 1);
//                                    
//                                    delegate.cameraShotFinished(image, fromCameraSide: .Front)
                                    

                                    // Try 3
//                                    let ciImage: CIImage = CIImage(CGImage: image.CGImage!)
//                                    let rotada3 = ciImage.imageByApplyingTransform(CGAffineTransformMakeScale(-1, 1))
//                                    
//                                    let image = UIImage(CIImage: rotada3)
//                                    
//                                    self.finalViewContainer?.image = image
//                                    self.finalViewContainer?.alpha = 1.0
//                                    delegate.cameraShotFinished(image, fromCameraSide: .Front)
                                    
                                    
                                    let flippedImage = UIImage(CGImage: image.CGImage!,
                                                                scale: image.scale,
                                                                orientation: .LeftMirrored)
                                   
                                    print("Image Orientation: \(flippedImage.imageOrientation.rawValue)")
                                    print("Image Orientation: \(flippedImage.imageOrientation)")

                                    
                                    self.finalViewContainer?.image = flippedImage
                                    self.finalViewContainer?.alpha = 1.0
                                    delegate.cameraShotFinished(flippedImage, fromCameraSide: .Front)

                                } else if self.videoDeviceInput?.device.position == .Back {
                                    print("device.position == .Back")

                                    print("Image Orientation: \(image.imageOrientation.rawValue)")

                                    print("Image Orientation: \(image.imageOrientation)")
                                    
                                    self.finalViewContainer?.image = image
                                    self.finalViewContainer?.alpha = 1.0
                                    delegate.cameraShotFinished(image, fromCameraSide: .Back)
                                }
                            })
                        }
                    } else {
                        
//                        if !self.session.running {
//                            self.session.startRunning()
//                        }
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
     *  All buttons should be disabled (except for cancel button)
     *  before this func is called.
     *  
     *  On success the camera will flip, 
     *  Returns successfully flipped and the camera orientation
     *
     */
    
    func supportsMultipleCameras() -> Bool {
        return AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count > 1
    }
    
    
    func changeCamera() {
        
        displayDelegate?.flashButtonEnabled(false)
        displayDelegate?.captureButtonEnabled(false)
        displayDelegate?.flipButtonEnabled(false)
        
        dispatch_async(self.sessionQueue) {
            
            let currentVideoDevice = self.videoDeviceInput!.device
            let currentPosition = currentVideoDevice!.position
            
            let preferredPosition: AVCaptureDevicePosition
            
            switch currentPosition {
            case .Unspecified, .Front:
                preferredPosition = .Back
                
            case .Back:
                preferredPosition = .Front
            }

            
            if let videoDevice = INCameraContainerView.deviceWithMediaType(AVMediaTypeVideo, preferringPosition: preferredPosition)
            {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                       self.shutterCamera()
                    })
                    
                    self.session.beginConfiguration()
                    
                    // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
                    self.session.removeInput(self.videoDeviceInput)
                    
                    if self.session.canAddInput(videoDeviceInput) {
                        
                        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: currentVideoDevice)
                        
                        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.subjectAreaDidChange), name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: videoDeviceInput.device)
                        
                        self.session.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                        
                    } else {
                        self.session.addInput(self.videoDeviceInput);
                    }
//                    if let connection = self.movieFileOutput?.connection(withMediaType: AVMediaTypeVideo) {
//                        if connection.isVideoStabilizationSupported {
//                            connection.preferredVideoStabilizationMode = .auto
//                        }
//                    }
                    
                    /*
                     Set Live Photo capture enabled if it is supported. When changing cameras, the
                     `isLivePhotoCaptureEnabled` property of the AVCapturePhotoOutput gets set to NO when
                     a video device is disconnected from the session. After the new video device is
                     added to the session, re-enable Live Photo capture on the AVCapturePhotoOutput if it is supported.
                     */
//                        self.photoOutput.isLivePhotoCaptureEnabled = self.photoOutput.isLivePhotoCaptureSupported;
                    
                    
                    self.session.commitConfiguration()
                }
                    
                catch {
                    print("Error occured while creating video device input: \(error)")
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.enableCameraFlash()
                
                // Enable Flip button
                if self.supportsMultipleCameras() {
                    self.displayDelegate?.flipButtonEnabled(true)
                } else {
                    self.displayDelegate?.flipButtonEnabled(false)
                }
                
                self.displayDelegate?.captureButtonEnabled(true)
            })
        }
    }
    
    
    /*  ====================================================================================
        ====================================================================================
                        Flash Functions
        ====================================================================================
        ====================================================================================
     */
    
    
    
    func enableCameraFlash() {
        print("enableCameraFlash")
        
        let device = videoDeviceInput?.device
        
        if device?.position == .Back && cameraHasFlash() {
            displayDelegate?.flashButtonEnabled(true)
            print("flashButtonEnabled true")


        } else {
            displayDelegate?.flashButtonEnabled(false)
        }
    }
    
    
    /*
     * Returns true if camera has flash
     * False otherwise
     */
    func cameraHasFlash() -> Bool {
        
        if let device = videoDeviceInput?.device {
            if device.hasFlash {
                return true
            } else {
                return false
            }
        }
        return false
    }

    
    /*
     * Returns the current flash mode
     * nil on error
     */
    func flashModeStatus() -> AVCaptureFlashMode? {
        
        if let device = videoDeviceInput?.device {
            guard device.hasFlash else { return nil }
            return device.flashMode
        }
        return nil
    }
    
    
    /*
     * Can set the flash mode to on/off/auto
     * Return: true if successful changing modes
     */
    func setFlashMode(mode: AVCaptureFlashMode) {
        
        do {
            if let device = videoDeviceInput?.device {
                guard device.hasFlash else { return }
                try device.lockForConfiguration()
                device.flashMode = mode
                device.unlockForConfiguration()
            }
        } catch {
            return 
        }
    }

    
    /*
     *  Turns flash mode on/off and returns the status
     *  Returns nil if camera if not available
     */
    func toggleFlashMode() {
        
        if let device = videoDeviceInput?.device {
            let flashMode = device.flashMode
            switch flashMode {
            case .On:
                setFlashMode(.Off)
            default:
                setFlashMode(.On)
            }
        }
        setFlashButtonMode()
    }
    
    func setFlashButtonMode() {
        if let flashMode = flashModeStatus() {
            if flashMode == .On {
                displayDelegate?.setFlashButtonOn(true)
            } else {
                displayDelegate?.setFlashButtonOn(false)
            }
        }
    }





    // MARK: Selector
    func subjectAreaDidChange(notification: NSNotification){
        print("subjectAreaDidChange")

        let devicePoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
        focus(with: .AutoFocus, exposureMode: .ContinuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
    }
    
//    previewView
    
    @objc private func focusAndExposeTap(gestureRecognizer: UITapGestureRecognizer) {
        
        print("focusAndExposeTap")
        let devicePoint = previewView.videoPreviewLayer.captureDevicePointOfInterestForPoint(gestureRecognizer.locationInView(gestureRecognizer.view))
        focus(with: .AutoFocus, exposureMode: .AutoExpose, at: devicePoint, monitorSubjectAreaChange: true)
    }
    
    private func focus(with focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, at devicePoint: CGPoint, monitorSubjectAreaChange: Bool) {
        
        dispatch_async(self.sessionQueue) {
            if let device = self.videoDeviceInput?.device {
                do {
                    try device.lockForConfiguration()
                    
                    /*
                     Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
                     Call set(Focus/Exposure)Mode() to apply the new point of interest.
                     */
                    
                    if device.focusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                        device.focusPointOfInterest = devicePoint
                        device.focusMode = focusMode
                        
                        let viewsize = self.bounds.size
                        let newPoint = CGPoint(x: (1.0 - devicePoint.y) * viewsize.width,
                                               y: devicePoint.x * viewsize.height)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.focusAnimation.pop_removeAllAnimations()

                            self.focusAnimation.center = newPoint
                            
                            self.addAnimations()
                            
                        })
                    }
                    
                    if device.exposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                        print("focusPointOfInterestSupported isExposureModeSupported")

                        device.exposurePointOfInterest = devicePoint
                        device.exposureMode = exposureMode
                    }
                    
                    device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                    device.unlockForConfiguration()
                }
                catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
        }
    }
    
    
    func addAnimations() {
        
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        scaleAnimation.fromValue = NSValue(CGSize: CGSizeMake(1, 1))
        scaleAnimation.toValue = NSValue(CGSize: CGSizeMake(7, 7))
        
        scaleAnimation.duration = 0.5
        scaleAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        scaleAnimation.name = "scaleAnimation"
        scaleAnimation.delegate = self
        
        focusAnimation.pop_addAnimation(scaleAnimation, forKey: "scale")
        
        
        
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0.0
        
        alphaAnimation.duration = 0.4
        alphaAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        alphaAnimation.name = "alphaAnimation"
        alphaAnimation.delegate = self
        
        focusAnimation.pop_addAnimation(alphaAnimation, forKey: "alpha")
    }
    
    func pop_animationDidStart(anim: POPAnimation!) {
        print("pop_animationDidStart")
        self.focusAnimation.hidden = false
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        print("pop_animationDidStop")
        
        let value = anim.name
        print("value: \(value)")
        self.focusAnimation.hidden = true
        self.focusAnimation.pop_removeAllAnimations()
    }
    
    
    
    
    
    /* ==================================================================================
       ==================================================================================
     
                                    Notifiactions
       
       ==================================================================================
       ==================================================================================
     */
    
    
    let kPathRunning = "running"
    let KCapturingStillImage = "capturingStillImage"
    
    
    private var sessionRunningObserveContext = 0
    private var capturingStillImageObserveContext = 0
    
    
    private func addObservers() {
        
        print("addObservers")
        
        session.addObserver(self, forKeyPath: kPathRunning, options: .New, context: &sessionRunningObserveContext)
        stillImageOutput.addObserver(self, forKeyPath: KCapturingStillImage, options: .New, context: &capturingStillImageObserveContext)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subjectAreaDidChange), name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: self.videoDeviceInput?.device)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sessionRuntimeError), name: AVCaptureSessionRuntimeErrorNotification, object: self.session)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sessionWasInterrupted), name: AVCaptureSessionWasInterruptedNotification, object: self.session)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sessionInterruptionEnded), name: AVCaptureSessionInterruptionEndedNotification, object: self.session)
    }
    
    private func removeObservers() {
        print("removeObservers")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        session.removeObserver(self, forKeyPath: kPathRunning, context: &sessionRunningObserveContext)
        stillImageOutput.removeObserver(self, forKeyPath: KCapturingStillImage, context: &capturingStillImageObserveContext)
    }
    
    func shutterCamera() {
//        previewView.videoPreviewLayer!.opacity = 0.0
//        UIView.animateWithDuration(0.25, animations: {
//            self.previewView.videoPreviewLayer!.opacity = 1.0
//        })
        previewView.layer.opacity = 0.0
        UIView.animateWithDuration(0.25, animations: {
            self.previewView.layer.opacity = 1.0
        })
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print("observeValueForKeyPath")

        if context == &capturingStillImageObserveContext {
            guard let isCapturingStillImage = change![NSKeyValueChangeNewKey] as? Bool else { return }
            
            print("1 context = capturingStillImageObserveContext isCapturingStillImage")
            if isCapturingStillImage {
                print("2 isCapturingStillImage")

                dispatch_async(dispatch_get_main_queue(), {
                    self.shutterCamera()
                })
            }
        }
            
        else if context == &sessionRunningObserveContext {
            guard let isSessionRunning = change![NSKeyValueChangeNewKey] as? Bool else { return }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                print("isSessionRunning && AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 1")
                print("isSessionRunning = \(isSessionRunning)")
                
                if isSessionRunning {
                    self.setFlashMode(.Off)
                    self.cameraControlsSetup()
                }
            })
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    
    func sessionRuntimeError(notification: NSNotification) {
        //        guard let errorValue = notification.userInfo?[AVCaptureSessionErrorKey] as? NSError else {
        //            return
        //        }
        //
        //        let error = AVError(_nsError: errorValue)
        //        print("Capture session runtime error: \(error)")
        //
        //        /*
        //         Automatically try to restart the session running if media services were
        //         reset and the last start running succeeded. Otherwise, enable the user
        //         to try to resume the session running.
        //         */
        //        if error.code == .mediaServicesWereReset {
        //            sessionQueue.async { [unowned self] in
        //                if self.isSessionRunning {
        //                    self.session.startRunning()
        //                    self.isSessionRunning = self.session.isRunning
        //                }
        //                else {
        //                    DispatchQueue.main.async { [unowned self] in
        //                        self.resumeButton.isHidden = false
        //                    }
        //                }
        //            }
        //        }
        //        else {
        //            resumeButton.isHidden = false
        //        }
    }
    
    func sessionWasInterrupted(notification: NSNotification) {
        //        /*
        //         In some scenarios we want to enable the user to resume the session running.
        //         For example, if music playback is initiated via control center while
        //         using AVMetadataRecordPlay, then the user can let AVMetadataRecordPlay resume
        //         the session running, which will stop music playback. Note that stopping
        //         music playback in control center will not automatically resume the session
        //         running. Also note that it is not always possible to resume, see `resumeInterruptedSession(_:)`.
        //         */
        //        if let reasonIntegerValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey]?.integerValue, let reason = AVCaptureSessionInterruptionReason(rawValue: reasonIntegerValue) {
        //            print("Capture session was interrupted with reason \(reason)")
        //
        //            var showResumeButton = false
        //
        //            if reason == AVCaptureSessionInterruptionReason.audioDeviceInUseByAnotherClient || reason == AVCaptureSessionInterruptionReason.videoDeviceInUseByAnotherClient {
        //                showResumeButton = true
        //            }
        //            else if reason == AVCaptureSessionInterruptionReason.videoDeviceNotAvailableWithMultipleForegroundApps {
        //                // Simply fade-in a label to inform the user that the camera is unavailable.
        //                cameraUnavailableLabel.alpha = 0
        //                cameraUnavailableLabel.isHidden = false
        //                UIView.animate(withDuration: 0.25) { [unowned self] in
        //                    self.cameraUnavailableLabel.alpha = 1
        //                }
        //            }
        //
        //            if showResumeButton {
        //                // Simply fade-in a button to enable the user to try to resume the session running.
        //                resumeButton.alpha = 0
        //                resumeButton.isHidden = false
        //                UIView.animate(withDuration: 0.25) { [unowned self] in
        //                    self.resumeButton.alpha = 1
        //                }
        //            }
        //        }
    }
    
    func sessionInterruptionEnded(notification: NSNotification) {
        //        print("Capture session interruption ended")
        //
        //        if !resumeButton.isHidden {
        //            UIView.animate(withDuration: 0.25,
        //                           animations: { [unowned self] in
        //                            self.resumeButton.alpha = 0
        //                }, completion: { [unowned self] finished in
        //                    self.resumeButton.isHidden = true
        //                }
        //            )
        //        }
        //        if !cameraUnavailableLabel.isHidden {
        //            UIView.animate(withDuration: 0.25,
        //                           animations: { [unowned self] in
        //                            self.cameraUnavailableLabel.alpha = 0
        //                }, completion: { [unowned self] finished in
        //                    self.cameraUnavailableLabel.isHidden = true
        //                }
        //            )
        //        }
    }
    

}

// extension CameraContainerView {

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
//}