//
//  RegisterProfileCamera.swift
//  PopIn
//
//  Created by Hanny Aly on 8/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit
import RSKImageCropper

import Toucan

protocol RegisterProfileCameraDelegate {
    func replaceImage(image: UIImage, andCroppedImage croppedImage:UIImage?)
    func replaceCroppedImage(croppedImage: UIImage?)
}

class RegisterProfileCamera: ASViewController,
    INFullCameraDisplayDelegate,
    INCameraControlsCellNodeViewControllerDelegate,
    INCameraNextCellNodeViewControllerDelegate,
    INCameraContainerViewViewControllerDelegate,
RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource{
 
    
    // Do not inplement
    func videoStarted(){ }
    
    // Do not inplement
    func videoStopped(){ }
    
    
    var delegate:RegisterProfileCameraDelegate?
    
    var photo               : UIImage?
    let fullCameraDisplay   : INFullCameraDisplayNode
    let controlsCellNode    : INCameraControlsCellNode
    let nextControlsCellNode: INCameraNextCellNode
    
    
    var cameraInitOnce: Bool = false
    
    init() {
        
        controlsCellNode = INCameraControlsCellNode()
        nextControlsCellNode = INCameraNextCellNode()
        
        fullCameraDisplay = INFullCameraDisplayNode(controlsCellNode: controlsCellNode, nextControlsCellNode: nextControlsCellNode)
        
        super.init(node: fullCameraDisplay)
        
        fullCameraDisplay.delegate = self
        controlsCellNode.viewControllerDelegate = self
        nextControlsCellNode.viewContollerDelegate = self
        
        if !cameraInitOnce {
            cameraInitOnce = true
            fullCameraDisplay.initializeCamera(withFrame: self.view.frame, side: .Front, allowVideoRecording: false)
            fullCameraDisplay.cameraContainerView?.viewControllerDelegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        view.addSubnode(fullCameraDisplay)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        fullCameraDisplay.cameraContainerView?.cameraWillAppear()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.alpha = 1.0
            }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        fullCameraDisplay.cameraContainerView?.cameraWillDisappear()
        super.viewWillDisappear(animated)
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
    
    
    
    var imageCropSize = kHDVersion
    
    func gotoNextViewController() {
        
        print("Will open RSKIMageCropViewController")
        
        let imageCropVC = RSKImageCropViewController(image: photo!, cropMode: .Custom)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        imageCropVC.maskLayerLineWidth = 3.0
        imageCropVC.maskLayerStrokeColor = UIColor.whiteColor()
        imageCropVC.rotationEnabled = false
        
        imageCropVC.avoidEmptySpaceAroundImage = true

        
        let minimumSize = min((photo?.size.width)!, (photo?.size.height)!)
        if minimumSize < kHDVersion {
            imageCropSize = kSDVersion
            imageCropVC.smallestPhotoSide = kSDVersion
        } else {
            imageCropVC.smallestPhotoSide = kHDVersion
        }
                
//        BackCamera:  width: 960.0, height: 1280.0
//        FrontCamera: width: 2448.0, height: 3264.0
        
        imageCropVC.moveAndScaleLabel.text = "Scale - Zoom"
        imageCropVC.cancelButton.setTitle("Back", forState: .Normal)
        imageCropVC.chooseButton.setTitle("Done", forState: .Normal)

        
        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }
    

    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
     RSKImage CropViewController Delegate
     
     ================================================================================
     ================================================================================
     */

    
    
    // The original image will be cropped.
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        print("imageCropViewController Will crop image")
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
       
        print("imageCropViewController Delegate Did crop image")
        //save Image here
        delegate!.replaceImage(photo!, andCroppedImage: croppedImage)
        
        //        saveImageToLibaryForTestingPurposes(croppedImage)
        
        dismissCamera()
    }
    
    
    // Protocol from Camera, do not need to implent as we will be not have a "save" button
    func saveImageData() {}
    // Save image to iPhone library
   
    
    func saveImageToLibaryForTestingPurposes(croppedImage:UIImage) {
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        print("Saved image")
    }
    
    
    

    
    
    
    
    /* ================================================================================
     ================================================================================
     
     RSKImage CropViewController DataSource
     
     ================================================================================
     ================================================================================
     */
    
    
    // Returns a custom rect for the mask.
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        let viewWidth = CGRectGetWidth(controller.view.frame)
        let viewHeight:CGFloat = CGRectGetHeight(controller.view.frame)
        
        let maskSize: CGSize = CGSizeMake(viewWidth, viewWidth)
        
        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        
        return maskRect
    }
    
    
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        let rect = controller.maskRect
        let point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let rectangle = UIBezierPath()
        
        rectangle.moveToPoint(point1)
        rectangle.addLineToPoint(point2)
        rectangle.addLineToPoint(point3)
        rectangle.addLineToPoint(point4)
        rectangle.closePath()
        
        return rectangle
    }
    
    
    // CHanged zoom at Search "Hanny Special Edit" HannyEdit
    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
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
            
            let vcIndex = self.navigationController?.viewControllers.indexOf({ (viewController) -> Bool in
                
                if let _ = viewController as? RegisterUserVC {
                    return true
                }
                return false
            })
            
            let registerVC = self.navigationController?.viewControllers[vcIndex!] as! RegisterUserVC
            
            self.navigationController?.popToViewController(registerVC, animated: false)
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
            
            let alertController = UIAlertController(title: "Unauthorized access", message: "\(AppName) doesn't have permission to use the camera. Go to Settings to change permissions", preferredStyle: .ActionSheet)
            
            
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
    
    
    let randomUpsetEmojis = ["😤","😰","😢","😭","😡","😩","😫","😔"]
    
    func randomUpsetEmoji() -> String {
        return randomUpsetEmojis[Int(arc4random_uniform(UInt32(randomUpsetEmojis.count)))]
    }
    
    
    
    
    func photoWillBeTaken() {
        print("photoWillBeTaken")
        fullCameraDisplay.cameraContainerView?.takePhoto() //capturePhoto()
    }
    
    
    
    /*
     Front Camera: width: 960.0, height: 1280.0
     Back Camera: width: 2448.0, height: 3264.0
     */
    
    
    func cameraShotFinished(image: UIImage?, fromCameraSide side: AVCaptureDevicePosition?) {
        
        print("cameraShotFinished")
        if let photoImage = image {
            photo = photoImage
            
            print("Hanny photo size width: \(photoImage.size.width), height: \(photoImage.size.height)")
            fullCameraDisplay.scrollToNextPageNode()
        }
    }
}


