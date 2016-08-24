//
//  CreateUsernameViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSMobileHubHelper
import AsyncDisplayKit
import Whisper
import SwiftyDrop
import RSKImageCropper

import FBSDKCoreKit

import Toucan


let kCompressionQualityBest: CGFloat = 1.0
let kCompressionQualityHigh: CGFloat = 8.0
let kCompressionQualityMedium: CGFloat = 5.0
let kCompressionQualityLow: CGFloat = 2.0
let kCompressionQualityWorst: CGFloat = 0.0


class RegisterUserVC: ASViewController, UITextFieldDelegate, RegisterProfileCameraDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
    
    
    
    //MARK: Error Messages
    
    enum FacebookError {
        case Is_Silhouette
        case SizeSmall
        case SizeBig
        case Unknown
    }
    
    
    
    let kMinimumWidth  = 500
    let kMinimumHeight = 500
    let kMaximumWidth  = 500
    let kMaximumHeight = 500
    
    
    let kValidityKey = "isValid"
    let createUserNode: CreateUserNode
    
    
    var profileImage: UIImage?
    var croppedProfileImage: UIImage?
    
    
    
    
    var usernameIsValid = false {
        didSet {
            createUserNode.enableNextButton(shouldEnableNextButton())
        }
    }
    
    
    init() {
        loadingPhoto = false
        createUserNode = CreateUserNode()
        super.init(node: createUserNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUserNode.textFieldNode.textField.delegate = self
        createUserNode.setTextFieldNodeDelegate(self)
        createUserNode.photoButtonAddTarget(self, action: #selector(photoButtonPressed))
        createUserNode.nextButtonAddTarget(self, action: #selector(registerUser))
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
            self.view.alpha = 1.0
        }, completion: nil)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func registerUser() {
        
        createUserNode.blockViewController(true)

        let kbSize:CGFloat = 1024

        
        
        let croppedImage = UIImageJPEGRepresentation(croppedProfileImage!, kCompressionQualityBest)
        let croppedImageSize = CGFloat( croppedImage!.length)
        print("croppedImageSize: \(croppedImageSize / kbSize) KB")
        
        
        let originalImage = UIImageJPEGRepresentation(profileImage!, kCompressionQualityBest)
        let originalImageSize = CGFloat( originalImage!.length)
        print("originalImageSize: \(originalImageSize / kbSize) KB")
        
        
        let croppedImageBase64 = croppedImage?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        let originalImageBase64 = originalImage?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        
        let jsonObj:[String: AnyObject] = [ "username": lastSearchTerm!,
                                            "cropImage": croppedImageBase64!,
                                            "originalImage": originalImageBase64!]
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaRegister,
         withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
        
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.createUserNode.blockViewController(false)

                    print("registerUser: CloudLogicViewController: Result: \(result)")
                    
                    if let userDetails = LambdaLoginResponse(response: result) {
                        
                        if userDetails.userExists {
                            
                            if userDetails.hasOneProfile() {
                                
                                Me.saveGuid((userDetails.profiles.first?.guid)!)
                                Me.saveAcctid((userDetails.profiles.first?.acctId)!)
                                Me.saveUsername((userDetails.profiles.first?.username)!)
                                
                            } else {
                                // Show Multi profile user selection.
                                // Let user pick Profile and save info then
                            }
                            
                            // also get username and profilephoto
                            self.navigationController?.popToRootViewControllerAnimated(false)
                            // self.navigationController?.popViewControllerAnimated(false)

                        } else {
                            // User does not exist
                            self.showDynamoDBAlertMessage(AWSErrorBackend)
                        }
                    } else {
                        // User does not exist
                        let error = LambdaErrorResponse(response: result)
                        self.showDynamoDBAlertMessage(error.message)
                    }

                })
            }
            
            if let errorMessage = AWSConstants.errorMessage(error) {
                dispatch_async(dispatch_get_main_queue(), {
                
                    self.showDynamoDBAlertMessage(errorMessage)
                    
                    self.createUserNode.blockViewController(false)
//                    self.createUserNode.disableView(true)
                })
            }
        }
    }

    

    func photoButtonPressed() {
        
        print("select photo pressed")
        
        if createUserNode.textFieldNode.textField.isFirstResponder() {
            createUserNode.textFieldNode.textField.resignFirstResponder()
        }
        
        
        let attributedString = NSAttributedString(string: "Choose Profile Photo",
                                                  attributes:[ NSFontAttributeName : UIFont.systemFontOfSize(15),
                                                    NSForegroundColorAttributeName : UIColor.blackColor()])
        
        let alertController = UIAlertController(title: "Choose Profile Photo",
                                                message: nil,
                                                preferredStyle: .ActionSheet)
        alertController.setValue(attributedString,
                                 forKey: "attributedTitle")

        if profileImage != nil {
            
            let editPhotoAction = UIAlertAction(title: "Edit Photo", style: .Default) { (action) in
                
                
                //TODO: Make this async and show spinning circle
                print("Edit photo, show pop up")
                
                let imageCropVC = RSKImageCropViewController(image: self.profileImage!, cropMode: .Custom)
                imageCropVC.delegate = self
                imageCropVC.dataSource = self

                imageCropVC.maskLayerLineWidth = 3.0
                imageCropVC.maskLayerStrokeColor = UIColor.whiteColor()
                imageCropVC.rotationEnabled = false
                
                imageCropVC.avoidEmptySpaceAroundImage = true
                
                let minimumSize = min((self.profileImage?.size.width)!, (self.profileImage?.size.height)!)
                
                let HDVersion:CGFloat = 1080.0
                let SDVersion:CGFloat = 540.0
                
                if minimumSize < 1080.0 {
                        imageCropVC.smallestPhotoSide = SDVersion
                } else {
                    imageCropVC.smallestPhotoSide = HDVersion
                }
                
                imageCropVC.moveAndScaleLabel.text = "Scale - Zoom"
                
                imageCropVC.chooseButton.setTitle("Done", forState: .Normal)
                
                self.navigationController?.pushViewController(imageCropVC, animated: true)
                
            }
            
            alertController.addAction(editPhotoAction)

        }
        
        // Facebook import
        let facebookAction = UIAlertAction(title: "Import from Facebook", style: .Default) { (action) in

            
            //TODO: Make this async and show spinning circle
            print("Importing from facebook, please wait")
            
            self.loadingPhoto = true
            
            
            let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, age_range, is_verified, email, picture.width(2000).height(2000)"])
            
            /*
             *
             
             Original facebok profile image width: 240, height: 240
             Original facebok profile image squares size of image: 21.408203125 KB
             
             Original facebok profile image width: 320, height: 320
             Original facebok profile image squares size of image: 34.3515625 KB
             
             Original facebok profile image width: 480, height: 480
             Original facebok profile image squares size of image: 71.3876953125 KB
 
             Original facebok profile image width: 720, height: 720
             Original facebok profile image squares size of image: 138.01953125 KB
   
             
             Original facebok profile image width: 960, height: 491
             Original facebok profile image squares size of image: 139.927734375 KB
             
             Original facebok profile image width: 960, height: 960
             Original facebok profile image squares size of image: 229.4833984375 KB
             
             
             Original facebok profile image width: 1066, height: 2048
             Original facebok profile image squares size of image: 537.767578125 KB
 
             Original facebok profile image width: 2048, height: 2048
             Original facebok profile image squares size of image: 857.857421875 KB
             
             */
            

            pictureRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in

                if error == nil {
                    print("\(result)")
                    
                    if let facebookSilhouette = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("is_silhouette") as? Bool {
                        if facebookSilhouette {
                            
                            self.loadingPhoto = false
                            print("\(error)")
                            self.showFacebookAlert(.Is_Silhouette)
                            return
                        }
                    }
                    
                    
                    guard let facebookUrl = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String else {
                        
                        self.loadingPhoto = false
                        print("\(error)")
                        self.showFacebookAlert(.Unknown)
                        return
                    }
                    guard let facebookURL = NSURL(string: facebookUrl) else {
                        self.loadingPhoto = false
                        print("\(error)")
                        self.showFacebookAlert(.Unknown)
                        return
                    }
                    
                    let facebookEmail = result.valueForKey("email")
                    print("facebookEmail \(facebookEmail)")
                    let facebookName = result.valueForKey("name")
                    print("name \(facebookName)")

                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                        
                        if let imageData = NSData(contentsOfURL: facebookURL) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                                guard let profileImage = UIImage(data: imageData) else {
                                    self.showFacebookAlert(.Unknown)
                                    self.loadingPhoto = false
                                    return
                                }

                                let profileSize = Toucan(image: profileImage).image.size
                                
                                
                                print("Original facebook profile image width: \(Int(profileSize.width)), height: \(Int(profileSize.height))")
                                

                                
                                if profileSize.width < CGFloat( self.kMinimumWidth) || profileSize.height < CGFloat( self.kMinimumHeight) {
                                    self.showFacebookAlert(.SizeSmall)
                                } else {
                                    
                                    let imgData = UIImageJPEGRepresentation(profileImage, 1)!
                                    let imageSize = CGFloat( imgData.length)
                                    let kbSize:CGFloat = 1024
                                    print("Original facebok profile image squares size of image: \(imageSize / kbSize) KB")
                                    
                                    print("Image size width")
                                    
                                    let realSize = Toucan(image: profileImage).image.size
                                    
                                    print("Original facebok profile image width: \(realSize.width), height: \(realSize.height)")
                                    
                                    let croppedImage = Toucan(image: profileImage).resize(CGSizeMake(CGFloat( self.kMinimumWidth), CGFloat( self.kMinimumWidth))).image
                                    
                                    self.replaceImage(profileImage, andCroppedImage: croppedImage)
                                }
                            
                            })
                        } else { // if no contents from: imageData = NSData(contentsOfURL: facebookURL!)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.loadingPhoto = false
                                self.showFacebookAlert(.Unknown)
                            })
                        }
                    })
                } else { // If error
                    print("Facebook Error: \(error)")
                    self.loadingPhoto = false
                    self.showFacebookAlert(.Unknown)
                }
            })
        }
        alertController.addAction(facebookAction)
        
        
        
        func hasCamera() -> Bool {
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                return true
            }
            return false
        }
        
        // Camera
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
           
            print("cameraAction")
            
            if hasCamera() {
                
                let cameraVC = RegisterProfileCamera()
                cameraVC.delegate = self
                
                self.presentClearViewController(cameraVC)
            } else {
                
                let alertController = UIAlertController(title: "Camera not available",
                                                        message: nil,
                                                        preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK",
                                             style: .Default,
                                             handler: nil)
                
                alertController.addAction(OKAction)
               
                self.presentViewController(alertController, animated: true, completion: nil)                
            }
        }
        alertController.addAction(cameraAction)
        
        
        // Library
//        let libraryAction = UIAlertAction(title: "Choose from Library", style: .Default) { (action) in
//            print(action)
//        }
//        alertController.addAction(libraryAction)
        
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
    
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func presentClearViewController(viewController: UIViewController) {
        
        viewController.view.alpha = 0
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    
    
    
    /* Image crop Delegate */
    
    // The original image will be cropped.
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        print("Will crop image")
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        print("Did crop image")
        
        replaceCroppedImage(croppedImage)
        

//        saveImageToLibaryForTestingPurposes(croppedImage)
        
        navigationController?.popViewControllerAnimated(false)
    }
    
    
    
    func saveImageToLibaryForTestingPurposes(croppedImage:UIImage) {
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        print("Saved image")
    }

    
    
    /* Image Crop Datasource */
    
    // Returns a custom rect for the mask.
    
    
    // Returns a custom rect for the mask.
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        let viewWidth = CGRectGetWidth(controller.view.frame)
        let viewHeight = CGRectGetHeight(controller.view.frame)
        
        let maskSize = CGSizeMake(viewWidth, viewWidth)
        
        let maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        
        return maskRect
    }
    
    
   
    
    
    
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        
        print("RegisterUserVC imageCropViewControllerCustomMaskPath")

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
        print("RegisterUserVC imageCropViewControllerCustomMovementRect")
        return controller.maskRect
    }
    
    
    func replaceImage(image: UIImage, andCroppedImage croppedImage: UIImage?) {
        
        print("Delegate replaceImage")

        profileImage = image
        replaceCroppedImage(croppedImage)
    }
    
    func replaceCroppedImage(croppedImage: UIImage?) {
     
        if let cropped = croppedImage {
            croppedProfileImage = cropped
        }

//        let circleImage = Toucan(image: croppedProfileImage!).maskWithEllipse().image

        createUserNode.replaceUserPhoto(croppedProfileImage!)
        self.loadingPhoto = false

    }
    

    
    var loadingPhoto: Bool {
        didSet {
            createUserNode.enableUserPhotoButton(!loadingPhoto)
            createUserNode.enableNextButton(shouldEnableNextButton())
        }
    }

    
    
    
    
    
    //MARK: Interactive Functions
    
    enum ErrorMessageType {
        case UsernameExists
        case InvalidCharacters
    }
    
    
    func showErrorMessage(type: ErrorMessageType) {
        
        switch type {
        case .UsernameExists:
            Drop.down("This username already exists", state: .Blur(.ExtraLight), duration: 4.0, action: nil)
            
        case .InvalidCharacters:
            Drop.down("Invalid characters: Only letters, numbers and ._-", state: .Blur(.ExtraLight), duration: 4.0, action: nil)
        }
    }
    
    
    func shouldEnableNextButton() -> Bool {
   
        if usernameIsValid && createUserNode.userDidSelectProfilePhoto() && !loadingPhoto  {
            return true
        } else {
            return false
        }
    }
    
    
    func usernameIsValid(username: String) {
     
        if usernameCharactersValid(username) {
            
            createUserNode.textFieldNode.userIsDoneTyping()

            let jsonObj:[String: AnyObject] = ["username": username]
            
            AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaValidateUsername, withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
                if let result = result {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if self.lastSearchTerm != username {
                            return
                        }
                        
                        print("CloudLogicViewController: Result: \(result)")
                        if let isValid = self.detailsFromResults(result) {
                            if isValid {
                                self.createUserNode.textFieldNode.userReceivedResultsForValidText(true)
                                self.usernameIsValid = true

                            } else {
                                self.createUserNode.textFieldNode.userReceivedResultsForValidText(false)
                                
                                self.showErrorMessage(.UsernameExists)
                            }
                        } else { // Server error
                            self.showDynamoDBAlertMessage(AWSErrorBackend)
                        }
                    })
                }
                
                if let errorMessage = AWSConstants.errorMessage(error) {
                    dispatch_async(dispatch_get_main_queue(), {
                        print("Error occurred in invoking Lambda Function: \(error)")
                        self.createUserNode.textFieldNode.userReceivedResultsForValidText(false)
                        self.showDynamoDBAlertMessage(errorMessage)
                    })
                }
            }
        } else {
            self.showErrorMessage(.InvalidCharacters)
        }
    }


    
    
    
    //MARK: TextField Delegate Methods

    
    
    var userTypingTimer: NSTimer?
    var lastSearchTerm: String?

    func userDidType() {
        usernameIsValid = false
        createUserNode.textFieldNode.userIsTyping()
    }
    
    func startTypingTimer(username: String) {
        userTypingTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(search), userInfo: username, repeats: false)
    }
    
    func stopTypingTimer(timer: NSTimer) -> Bool {
        if timer.valid {
            timer.invalidate()
            return true
        }
        return false
    }
    
    
    
    func search(timer:NSTimer) {
        
        let username = timer.userInfo as! String
        
        let validTimer = stopTypingTimer(timer)
        
        if validTimer {
            usernameIsValid(username)
        }
    }
    

    
    func usernameTextDidChange(notification: NSNotification) {
        print("usernameTextDidChange")

        userDidType() // invalidateUsername
        
        if let timer = userTypingTimer {
            stopTypingTimer(timer)
        }
        
        let notif = notification.object as! UITextField
        if let username = notif.text {

            lastSearchTerm = username
            
            
            if username.characters.count > 0 {
                if usernameCharactersValid(username) {
                    startTypingTimer(username)
                } else {
                    self.showErrorMessage(.InvalidCharacters)
                }
            }
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(usernameTextDidChange),
                                                         name: UITextFieldTextDidChangeNotification,
                                                         object: textField)

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UITextFieldTextDidChangeNotification,
                                                            object: textField)
        
        if let timer = userTypingTimer {
            let usernameNotSearched = stopTypingTimer(timer)
            print("textFieldDidEndEditing timer.invalidate()")
            if usernameNotSearched {
                if let username = textField.text {
                    usernameIsValid(username)
                }

            }
        }
    }
    
    
    
    // Press Done button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        if let timer = userTypingTimer {
            let usernameNotSearched = stopTypingTimer(timer)

            if usernameNotSearched {
                if let username = textField.text {
                    usernameIsValid(username)
                }
            } else {
                if usernameIsValid {
                    textField.resignFirstResponder()
                    // return true
                }
            }
        } else {
            if usernameIsValid {
                textField.resignFirstResponder()
                //return true
            } else {
                //return false
            }
        }
        return false
    }
    
    
    //MARK: Helper functions
    
    func usernameCharactersValid(searchTerm: String) -> Bool{
        
        if searchTerm.isEmpty {
            return false
        }
        
        let characterset = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.-_")
        if searchTerm.rangeOfCharacterFromSet(characterset.invertedSet) != nil {
            print("string contains special characters")
            return false
        }
        
        return true
    }
    
    
    
    
    
    
    
    
    func detailsFromResults(object: AnyObject?) -> Bool? {
        
        var isValid = false
        
        if object == nil {
            print("object == nil")
        } else if let resultArray = object as? [AnyObject] {
            print("resultArray = object")
            
        } else if object is NSDictionary  {
            print("object is NSDictionary")
            
            let objectAsDictionary: [String: AnyObject] = object as! [String: AnyObject]
            
            if objectAsDictionary.isEmpty {
                print("object is NSDictionary isEmpty")
                return nil
            } else {
                print("object is NSDictionary not isEmpty")
                
                isValid = objectAsDictionary[kValidityKey] as! Bool
            }
        }
        print("Details isValid = \(isValid)")
        return isValid
    }
    
    
//    func resultDetails(object: AnyObject?) -> [String: AnyObject]? {
//        
//        if object == nil {
//            print("object == nil")
//        }
////        else if let resultArray = object as? [AnyObject] {
////            print("resultArray = object")
////            
////        }
//        else if let objectAsDictionary = object as? [String: AnyObject] {
//            
//            if objectAsDictionary.isEmpty {
//                print("object is NSDictionary isEmpty")
//                return objectAsDictionary
//            } else {
//                print("object is NSDictionary not isEmpty")
//                return objectAsDictionary
//
//            }
//        }
//        return nil
//    }
//    
//
//    
    
    
    
    func showFacebookAlert(type: FacebookError) {
        
        let title   : String
        let message : String
        
        switch type {
        case .Is_Silhouette:
            title = "No Photo"
            message = "You do not have a Facebook profile to import"
        case .SizeSmall:
            title = "Facebook profile image is too small"
            message = "The minimum size is \(kMinimumWidth) x \(kMinimumHeight)"
        case .SizeBig:
            title = "Facebook profile image is too big"
            message = "The maximum size is \(kMaximumWidth) x \(kMaximumHeight)"
        case .Unknown:
            title = "No Photo"
            message = "There was a problem importing your Facebook profile photo"
        }
        
        let facebookAlertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: .Alert)
        let facebookCancel = UIAlertAction(title: "OK",
                                           style: .Cancel,
                                           handler: nil)
        facebookAlertController.addAction(facebookCancel)
        presentViewController(facebookAlertController,
                              animated: true,
                              completion: nil)
    }

    
    func showDynamoDBAlertMessage(message: String?) {
        
        let alertView = UIAlertController(title: NSLocalizedString("Error",
                                          comment: "Title bar for error alert."),
                                          message: message,
                                          preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                          comment: "Button on alert dialog."),
                                          style: .Default,
                                          handler: nil))
        print("should showDynamoDBAlertMessage")

        presentViewController(alertView,
                              animated: true,
                              completion: nil)
    }
    
    
}
