//
//  INCameraVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//
//  CameraVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/29/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class INCameraVC: ASViewController,
INFullCameraDisplayDelegate,
INCameraControlsCellNodeViewControllerDelegate,
INCameraNextCellNodeViewControllerDelegate,
INCameraContainerViewViewControllerDelegate {
    
    
    var photo: UIImage?
    let fullCameraDisplay: INFullCameraDisplayNode
    let controlsCellNode: INCameraControlsCellNode
    let nextControlsCellNode: INCameraNextCellNode
    
    
    var cameraInitOnce: Bool = false
   
    init(withCameraPosition position: AVCaptureDevicePosition) {
        
        controlsCellNode = INCameraControlsCellNode()
        nextControlsCellNode = INCameraNextCellNode()
        
        fullCameraDisplay = INFullCameraDisplayNode(controlsCellNode: controlsCellNode, nextControlsCellNode: nextControlsCellNode)
        
        super.init(node: fullCameraDisplay)
        
        fullCameraDisplay.delegate = self
        controlsCellNode.viewControllerDelegate = self
        nextControlsCellNode.viewContollerDelegate = self
        
        if !cameraInitOnce {
            cameraInitOnce = true
            
            fullCameraDisplay.initializeCamera(withFrame: self.view.frame, side: position, allowVideoRecording: true)
            fullCameraDisplay.cameraContainerView?.viewControllerDelegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("navigationController?.navigationBarHidden = \(navigationController?.navigationBarHidden)")
        
        view.addSubnode(fullCameraDisplay)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = true

        fullCameraDisplay.cameraContainerView?.cameraWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        fullCameraDisplay.cameraContainerView?.cameraWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { 
            self.view.alpha = 1.0
        }, completion: nil)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    /* ================================================================================
     ================================================================================
     
     INFullCameraDisplayDelegate Navigation Functions
     
     ================================================================================
     ================================================================================
     */
    
    func restartCamera() {
        fullCameraDisplay.cameraContainerView?.restartCamera()
        fullCameraDisplay.scrollToCameraPageNode()
    }
    
    func gotoNextViewController() {
        print("AlbumUploadVC gotoNextViewController")
        let albumUploadVC = AlbumUploadVC(withPhoto:photo!)
        navigationController?.pushViewController(albumUploadVC, animated: true)
    }

    
    
    /* ================================================================================
     ================================================================================
     
            INFullCameraDisplayDelegate Navigation Functions
     
     ================================================================================
     ================================================================================
     */
    
    func dismissCamera() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut , animations: {
            self.view.alpha = 0.0
        }) { (complete) in
            self.navigationController?.popViewControllerAnimated(false)
//            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    

    
    
    // Used for top right button. Not being used
    // The Bottom PageController for NextNode has a next button being used
    // Keep around just in case we move things around
    func moveToNextVC() {
        print("moveToNextVC")
    }
    
    
    /* ================================================================================
     ================================================================================
     
                INCameraControlsDelegate Functions
     
     ================================================================================
     ================================================================================
     */
    
    

    func cameraWillAppear(result: INCameraContainerView.AVCamSetupResult) {
        
        if result == .CameraNotAuthorized {
            
            let alertController = UIAlertController(title: "Unauthorized", message: "\(AppName) doesn't have permission to use the camera. Go to Settings to give it", preferredStyle: .ActionSheet)
            
            
            let settingsAction = UIAlertAction(title: "Take me me there", style: .Default) { (settingsAction) in
                print("editUsersAction pressed")
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }
            alertController.addAction(settingsAction)
            
            
            let cancelAction = UIAlertAction(title: "Do it later", style: .Cancel) { (canceled) in
                print("Canceled pressed")
                //dismiss camera here
            }
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true) {}
        } else if result == .SessionConfigurationFailed {
            
            let alertController = UIAlertController(title: "Uh oh", message: "Unable to capture media", preferredStyle: .ActionSheet)
            
            
            let okAction = UIAlertAction(title: randomUpsetEmoji(), style: .Cancel) { (settingsAction) in
                print("okAction pressed")
            }
            alertController.addAction(okAction)
            
            presentViewController(alertController, animated: true) {}
        }
    }
    
    
    

    func photoWillBeTaken() {
        print("photoWillBeTaken")
        fullCameraDisplay.cameraContainerView?.takePhoto() //capturePhoto()
    }

    
    func videoStarted() {
        print("videoStarted")
    }
    func videoStopped() {
        print("videoStopped")
    }
    
    // Either we use camera side for when photo is taken by camera, or change usingFrontCamera to Image width and height for import images
  
    
    func cameraShotFinished(image: UIImage?, fromCameraSide side: AVCaptureDevicePosition?) {
        
        print("cameraShotFinished")
        if let photoImage = image {
            photo = photoImage
            fullCameraDisplay.scrollToNextPageNode()
        }
    }
    
    func saveImageData() {
        
        fullCameraDisplay.showSpinningWheel()
        if let photo = photo {
            UIImageWriteToSavedPhotosAlbum(photo, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else  {
            fullCameraDisplay.hideSpinningWheel()
            fullCameraDisplay.showMessageForSuccessfulSave(false)
        }
    }
    

    // Save image to iPhone library
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        fullCameraDisplay.hideSpinningWheel()

        if error == nil {
            fullCameraDisplay.showMessageForSuccessfulSave(true)
        } else {
            fullCameraDisplay.showMessageForSuccessfulSave(false)
        }
    }
    
    
    func showMessage(){
        
//        
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
//            self.view.alpha = 1.0
//            }, completion: nil)
//        
    }
}


