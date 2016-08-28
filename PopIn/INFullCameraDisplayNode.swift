//
//  INFullCameraDisplayNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol INFullCameraDisplayDelegate {
    func dismissCamera()
    func moveToNextVC()
}


public enum INContainerMode {
    case Camera
    case Library
}



class INFullCameraDisplayNode: ASDisplayNode, ASPagerDataSource, ASPagerDelegate,
    ASCollectionDelegate,
    INCameraControlsCellNodeDisplayDelegate, INCameraContainerViewDisplayDelegate {
    
    var mode: INContainerMode?
    
    let CameraTitle = "Camera"
    let LibraryTitle = "Library"
    
    var delegate: INFullCameraDisplayDelegate?
    
    
    
    var leftNavigationButton: ASButtonNode  // Close button
    var middleNavigationButton: ASButtonNode // Title
    var rightNavigationButton: ASButtonNode // Next button
    
    
    var cameraContainer: ASDisplayNode
    var cameraContainerView: INCameraContainerView?
    //    var imageViewContainer: ASImageNode
    
    
    
    let pagerInterfaceNode: ASPagerNode
    let cameraPagerButton: ASButtonNode
    let libraryPagerButton: ASButtonNode
    
    
    let controlsCellNode: INCameraControlsCellNode
    let nextControlsCellNode: INCameraNextCellNode

    let showPagerControls = false
    let showNextControls = true
    
    
    let saveImageMessage:HAPaddedTextNode
    let failSaveImageMessage:HAPaddedTextNode
    var activityIndicatorView: UIActivityIndicatorView

    
    //    let cameraView = CameraContainerView.instance()
    
    
    
    init(controlsCellNode _controlsCellNode: INCameraControlsCellNode, nextControlsCellNode _nextControlsCellNode: INCameraNextCellNode) {
        
        controlsCellNode = _controlsCellNode
        nextControlsCellNode = _nextControlsCellNode
        
        //  INTERNAL FUNCTIONS
        let textSize:CGFloat = 16.0
        
        func attributedString(string: String) -> NSAttributedString {
            
            return NSAttributedString(string: string, attributes:
                [NSForegroundColorAttributeName: UIColor.blackColor(),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            
        }
        
        func normalAttributedString(string: String, forState state: UIControlState) -> NSAttributedString {
            
            switch state {
            case UIControlState.Normal:
                return NSAttributedString(string: string,
                                          attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            case UIControlState.Highlighted:
                return NSAttributedString(string: string,
                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
                
            case UIControlState.Selected:
                return NSAttributedString(string: string,
                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            case UIControlState.Disabled:
                return NSAttributedString(string: string,
                                          attributes: [NSForegroundColorAttributeName: UIColor.grayColor(),
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            default:
                return NSAttributedString(string: string,
                                          attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            }
        }
        
        
        func createButtonWithAllStatesSetWithText(text: String) ->ASButtonNode {
            
            let button = ASButtonNode()
            button.backgroundColor = UIColor.whiteColor()
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
            button.flexGrow = true

            button.setAttributedTitle(normalAttributedString(text, forState:.Normal), forState: .Normal)
            button.setAttributedTitle(normalAttributedString(text, forState:.Disabled), forState: .Disabled)
            button.setAttributedTitle(normalAttributedString(text, forState:.Highlighted), forState: .Highlighted)
            
            button.setAttributedTitle(normalAttributedString(text, forState:.Selected), forState: .Selected)
            return button
        }
        
        //  END INTERNAL FUNCTIONS

        
        
        leftNavigationButton   = createButtonWithAllStatesSetWithText("Cancel")
        middleNavigationButton = createButtonWithAllStatesSetWithText("Camera")
        rightNavigationButton  = createButtonWithAllStatesSetWithText("")
        
        rightNavigationButton.enabled = false
        
        // UIImagePickerViewController
        cameraContainer = ASDisplayNode()
        // imageViewContainer = ASImageNode()
        
        // Camera controls
        pagerInterfaceNode = ASPagerNode()
        
        //Bottom Page Controls
        cameraPagerButton = ASButtonNode()
        cameraPagerButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        cameraPagerButton.flexGrow = true
        
        libraryPagerButton = ASButtonNode()
        libraryPagerButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        libraryPagerButton.flexGrow = true
        
        let saveMessageAttributedString = HAGlobal.centerTitleAttributedString("Saved!", color: UIColor.blackColor(), textSize: kTextSizeRegular)
        
        saveImageMessage = HAPaddedTextNode()
//        saveImageMessage.layerBacked = true
        saveImageMessage.textnode.attributedString = saveMessageAttributedString
        saveImageMessage.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        saveImageMessage.borderColor = UIColor.whiteColor().CGColor
        saveImageMessage.borderWidth = 2.0
        saveImageMessage.cornerRadius = 5.0
        saveImageMessage.hidden = true
        
        
        
        let errorMessageAttributedString = HAGlobal.centerTitleAttributedString("Couldn't save", color: UIColor.blackColor(), textSize: kTextSizeRegular)
        failSaveImageMessage = HAPaddedTextNode()
//        failSaveImageMessage.layerBacked = true
        failSaveImageMessage.textnode.attributedString = errorMessageAttributedString
        failSaveImageMessage.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        failSaveImageMessage.borderColor = UIColor.whiteColor().CGColor
        failSaveImageMessage.borderWidth = 2.0
        failSaveImageMessage.cornerRadius = 5.0
        failSaveImageMessage.hidden = true
        

        
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.whiteColor()

        super.init()
                
        
        cameraContainer.backgroundColor = UIColor.blackColor()
        
        
        
        // Navigation top
        leftNavigationButton.addTarget(self, action: #selector(dismissCamera), forControlEvents: .TouchUpInside)
        rightNavigationButton.addTarget(self, action: #selector(moveToNextViewController), forControlEvents: .TouchUpInside)
        
        
        
        
        
        // Camera and libary view
        //        cameraViewContainer.backgroundColor = UIColor.blackColor()
        //        cameraViewContainer.placeholderEnabled = true
        controlsCellNode.displayDelegate = self

        
        
        // Camera controls - reocrd, flash, etc
        pagerInterfaceNode.setDataSource(self)
        pagerInterfaceNode.backgroundColor = UIColor.clearColor()
        pagerInterfaceNode.delegate = self
        pagerInterfaceNode.view.scrollEnabled = false
        
        // Page controls - Camera/Photo Roll
        
        let camNorm   = pageTitlesAttributedString(CameraTitle, forState: .Normal)
        let camSelect = pageTitlesAttributedString(CameraTitle, forState: .Selected)
        
        cameraPagerButton.setAttributedTitle(camNorm, forState: .Normal)
        cameraPagerButton.setAttributedTitle(camSelect, forState: .Selected)
        
        cameraPagerButton.backgroundColor = UIColor.whiteColor()
        cameraPagerButton.addTarget(self, action: #selector(showCameraControls), forControlEvents: .TouchUpInside)
        
        
        let libNorm = pageTitlesAttributedString(LibraryTitle, forState: .Normal)
        let libSelect = pageTitlesAttributedString(LibraryTitle, forState: .Selected)
        
        
        libraryPagerButton.setAttributedTitle(libNorm, forState: .Normal)
        libraryPagerButton.setAttributedTitle(libSelect, forState: .Selected)
        
        libraryPagerButton.backgroundColor = UIColor.whiteColor()
        libraryPagerButton.addTarget(self, action: #selector(showLibraryControls), forControlEvents: .TouchUpInside)
        
        
        
        leftNavigationButton.contentHorizontalAlignment = .HorizontalAlignmentLeft
        
        cameraPagerButton.selected  = true
        libraryPagerButton.selected = false
        
        
        backgroundColor = UIColor.blackColor()
        
        usesImplicitHierarchyManagement = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        view.addSubview(activityIndicatorView)
    }
    
    func initializeCamera(withFrame frame: CGRect, side position: AVCaptureDevicePosition, allowVideoRecording capability:Bool) {
        
        cameraContainerView = INCameraContainerView(withFrame: CGRectMake(0,0, frame.width, frame.height),
                                                    side: position,
                                                    allowVideoRecording: capability)
        
        cameraContainerView?.displayDelegate = self
        cameraContainerView!.layoutIfNeeded()
        cameraContainer.view.addSubview(cameraContainerView!)
    }
    
    
    override func layout() {
        super.layout()

        let boundSize = view.bounds.size
        
        activityIndicatorView.sizeToFit()
        var refreshRect = activityIndicatorView.frame
        refreshRect.origin = CGPointMake( (boundSize.width - activityIndicatorView.frame.size.width)/2.0, (boundSize.height - activityIndicatorView.frame.size.height) / 2.0)
        
        activityIndicatorView.frame = refreshRect
    }
    
    
    func showSpinningWheel() {
        
        activityIndicatorView.startAnimating()
    }
    
    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
        
    }
    
    func showMessageForSuccessfulSave(success: Bool) {
       
        let duration: NSTimeInterval = 0.6
        let delay: NSTimeInterval = 0.1
        
        if success {
            saveImageMessage.hidden = false
            UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
                self.saveImageMessage.alpha = 0.0
                }, completion: { (finished) in
                    self.saveImageMessage.hidden = true
                    self.saveImageMessage.alpha = 1.0
            })

        } else {
            failSaveImageMessage.hidden = false
            
            UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
                self.failSaveImageMessage.alpha = 0.0
                }, completion: { (finished) in
                    self.failSaveImageMessage.hidden = true
                    self.failSaveImageMessage.alpha = 1.0
            })
        }
    }
    
    /* ================================================================================
     ================================================================================
     
            CAMERA DELEGATE METHODS / INCameraControlsCellNodeDelegate
     
     ================================================================================
     ================================================================================
     */
    
    
    func changeCamera() {
        cameraContainerView?.changeCamera()
    }
    
    func toggleFlashMode() {
        cameraContainerView?.toggleFlashMode()
    }
    
    
    /* ================================================================================
     ================================================================================
     
     INCameraContainerView INCameraViewControlsDelegate DELEGATE METHODS
     
     ================================================================================
     ================================================================================
     */
    
    
    func captureButtonEnabled(enabled: Bool) {
        if enabled {
            cameraContainerView?.addFocusImage()
        } else {
            cameraContainerView?.removeFocusImage()
        }
        controlsCellNode.enableCaptureButton(enabled)
    }

    func flipButtonEnabled(enabled: Bool) {
        controlsCellNode.enableFlipButton(enabled)
    }
    
    func flashButtonEnabled(enabled: Bool) {
        controlsCellNode.enableFlashButton(enabled)
    }
    
    func setFlashButtonOn(on: Bool) {
        controlsCellNode.setFlashButtonOn(on)
    }
    
    
    /* ================================================================================
     ================================================================================
     
            CAMERA_VIEW_CONTROLLER_NAVIGATION DELEGATE METHODS
     
     ================================================================================
     ================================================================================
     */
    
    func dismissCamera() {
        delegate?.dismissCamera()
    }
    
    
    func moveToNextViewController() {
        delegate?.moveToNextVC()
    }
    
    
    // Select Page Controls
    
    func showCameraControls() {
        print("showCameraControls")
        
        cameraPagerButton.selected = true
        libraryPagerButton.selected = false
        
        pagerInterfaceNode.scrollToPageAtIndex(0, animated: true)
    }
    
    
    func showLibraryControls() {
        print("showLibraryControls")
        
        libraryPagerButton.selected = true
        cameraPagerButton.selected = false
        pagerInterfaceNode.scrollToPageAtIndex(1, animated: true)
    }
    
    
    
    func scrollToCameraPageNode() {
        pagerInterfaceNode.scrollToPageAtIndex(0, animated: true)
    }

    func scrollToNextPageNode() {
        pagerInterfaceNode.scrollToPageAtIndex(1, animated: true)
    }
    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
            SCROLLVIEW DELEGATE METHODS
     
     ================================================================================
     ================================================================================
     */
    
    
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    
    //        func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    //            print("scrollViewWillBeginDragging")
    //
    //            let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
    //            print("percentage: \(percentage)")
    //        }
    
    
    //        func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //            print("scrollViewWillEndDragging: withVelocity \(targetContentOffset)")
    //
    //            let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
    //            print("percentage: \(percentage)")
    //        }
    //
    //
    //
    //        func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //            print("scrollViewDidEndDragging:willDecelerate: \(decelerate)")
    //
    //            let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
    //            print("percentage: \(percentage)")
    //        }
    
    
    
    let cameraPercent:CGFloat = 0.0
    let libraryPercent:CGFloat = 0.5
    
    
    var scrollViewIsScrolling = false
    var scrollLastDragPointInPercent: CGFloat?
    var scrollNextScrollPoint: CGFloat?
    
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
        //        print("scrollViewWillBeginDecelerating percentage: \(percentage)")
        
        scrollLastDragPointInPercent = scrollView.contentOffset.x / scrollView.contentSize.width
        
        if scrollLastDragPointInPercent > 0 || scrollLastDragPointInPercent < 1 {
            scrollViewIsScrolling = true
        }
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        print("scrollViewDidScroll percentage: \(scrollView.contentOffset.x / scrollView.contentSize.width)" )
        
        
        if scrollViewIsScrolling {
            scrollViewIsScrolling = false
            let nextPointInPercent = scrollView.contentOffset.x / scrollView.contentSize.width
            
            if nextPointInPercent < scrollLastDragPointInPercent {
                changeButtonForScrollPercentage(cameraPercent)
            } else {
                changeButtonForScrollPercentage(libraryPercent)
            }
        }
    }

    
    
    // When scrolling by hands
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
        changeButtonForScrollPercentage(percentage)
    }
    
    
    
    
    func changeButtonForScrollPercentage(percentage: CGFloat) {
        
        //        print("changeButtonForScrollPercentage")
        if percentage < 0.4 {
            //            print("changeButtonForScrollPercentage camera ")
            
            cameraPagerButton.selected = true
            libraryPagerButton.selected = false
            
        } else {
            //            print("changeButtonForScrollPercentage library ")
            
            libraryPagerButton.selected = true
            cameraPagerButton.selected = false
        }
    }
    
    
    
    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
            PAGERNODE DATASOURCE METHODS
     
     ================================================================================
     ================================================================================
     */
    
    
    
    func handleTap(gesture: UIGestureRecognizer) {
        print("finaly tapped")
    }
    

    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
        let boundSize: CGSize = pagerNode.bounds.size
        print("pagerNode.bounds.size: \(pagerNode.bounds.size)")
        
        let rowSize = CGSizeMake(boundSize.width, boundSize.height)

        if index == 0 {
            let cameraPageNode = INCameraTableNode(withRowSize: rowSize, andControlNode: controlsCellNode)
            cameraPageNode.preferredFrameSize = boundSize
            cameraPageNode.backgroundColor = UIColor.clearColor()
         
            return cameraPageNode
            
        } else {
            
            let cameraPageNode = INCameraTableNode(withRowSize: rowSize, andControlNode: nextControlsCellNode)
            cameraPageNode.preferredFrameSize = rowSize
            cameraPageNode.backgroundColor = UIColor.clearColor()

            return cameraPageNode
            
        }
    }
    
    func numberOfPagesInPagerNode(pagerNode: ASPagerNode!) -> Int {
        if showPagerControls {
            return 2
        } else if showNextControls {
            return 2
        }
        return 1
    }
    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
            LAYOUT SPEC
     
     ================================================================================
     ================================================================================
     */
    
    
    
    
//    override func layout() {
//        super.layout()
//        
//        pagerNode.frame
//    }
//    
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
//        pagerInterfaceNode.scrollToPageAtIndex(0, animated: true)

    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let pagerHeight = constrainedSize.max.height*(1/5)
        
        pagerInterfaceNode.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        pagerInterfaceNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, pagerHeight)
        
        pagerInterfaceNode.layoutPosition = CGPointMake(0, constrainedSize.max.height - pagerHeight)
        
        pagerInterfaceNode.sizeRange = ASRelativeSizeRangeMake(
            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(0), ASRelativeDimensionMakeWithPoints(300)),
            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(300)));
        
        let pagerInterfaceNodeStatic = ASStaticLayoutSpec(children: [pagerInterfaceNode])

        let pagerOverImage = ASOverlayLayoutSpec(child: cameraContainer, overlay: pagerInterfaceNodeStatic)
        
        pagerOverImage.flexGrow = true
        
//        return pagerOverImage
        
        
//        let leftButtonHeight = constrainedSize.max.height*(1/20)
//        
//        leftNavigationButton.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
//        leftNavigationButton.preferredFrameSize = CGSizeMake(constrainedSize.max.width, leftButtonHeight)
//
//        leftNavigationButton.layoutPosition = CGPointMake(0, 0)
//        
//        leftNavigationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
//        
//        let leftNavigationButtonStatic = ASStaticLayoutSpec(children: [leftNavigationButton])
//        let leftNavigationOverImage = ASOverlayLayoutSpec(child: pagerOverImage, overlay: leftNavigationButtonStatic)
//        leftNavigationOverImage.flexGrow = true
        
//        return leftNavigationOverImage

        
        
//        
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
//            self.view.alpha = 1.0
//            }, completion: nil)
        
        
        
        let messageHeight = constrainedSize.max.height/10

        
        
        failSaveImageMessage.flexGrow = true
        failSaveImageMessage.preferredFrameSize = CGSizeMake(constrainedSize.max.width/3, messageHeight)
        
//        let failStaticSpec = ASStaticLayoutSpec(children: [failSaveImageMessage])
        
        

        let failSaveCenterMessage = ASCenterLayoutSpec(centeringOptions: .XY,
                                                   sizingOptions: .Default,
                                                   child: failSaveImageMessage)
        failSaveCenterMessage.flexGrow = true
        let failMessageSpec = ASOverlayLayoutSpec(child: pagerOverImage,
                                                overlay: failSaveCenterMessage)
        failMessageSpec.flexGrow = true
        
        
        
        saveImageMessage.flexGrow = true
        saveImageMessage.preferredFrameSize = CGSizeMake(constrainedSize.max.width/3, messageHeight)
        let saveStaticSpec = ASStaticLayoutSpec(children: [saveImageMessage])

        let saveCenterMessage = ASCenterLayoutSpec(centeringOptions: .XY,
                                               sizingOptions: .Default,
                                               child: saveStaticSpec)
        saveCenterMessage.flexGrow = true
        let fullImageSpec = ASOverlayLayoutSpec(child: failMessageSpec,
                                                overlay: saveCenterMessage)
        fullImageSpec.flexGrow = true
        
        return fullImageSpec

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        let navigationStack = ASStackLayoutSpec(direction: .Horizontal,
                                                spacing: 0,
                                                justifyContent: .SpaceBetween,
                                                alignItems: .Center,
                                                children: [leftNavigationButton, middleNavigationButton, rightNavigationButton])
        navigationStack.flexShrink = true
        navigationStack.alignSelf = .Stretch

        

        var mainStack = [ASLayoutable]()

        mainStack.append(navigationStack)
        mainStack.append(pagerOverImage)

        
        let lastStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .End,
                                          alignItems: .Stretch,
                                          children: mainStack)
        
        
        
        
        return lastStack

        
        
        
        
        
        
        
        
        
        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                                     spacing: 0,
                                                     justifyContent: .SpaceAround,
                                                     alignItems: .Center,
                                                     children: [cameraPagerButton, libraryPagerButton])
        
        
        
        
        // Change this ratio to give more space to the pageNode
        let heightRatio:CGFloat = 1/2
        
        
        
        
        
        
        
        
//        var mainStack = [ASLayoutable]()
//        
//        mainStack.append(navigationStack)
//        mainStack.append(cameraContainer)
//        mainStack.append(pagerInterfaceNode)
//        if showPagerControls {
//            mainStack.append(pageButtonsNodeStack)
//        }
//        //        else if showNextControls {
//        //            mainStack.append(pageButtonsNodeStack)
//        //        }
//        
//        let lastStack = ASStackLayoutSpec(direction: .Vertical,
//                                          spacing: 0,
//                                          justifyContent: .End,
//                                          alignItems: .Stretch,
//                                          children: mainStack)
//        
//        return lastStack
        
        
        
        
        
        
        
        
        //
//        let cameraHeight = constrainedSize.max.height * heightRatio
//        
//        print("cameraHeight: \(cameraHeight)")
//
//
//        cameraContainer.preferredFrameSize = CGSizeMake(constrainedSize.max.width, cameraHeight)
//        cameraContainer.flexGrow = true

        
        
        
        
//        pagerNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 100)
//
////        let difference = cameraContainer.preferredFrameSize.height - cameraContainer.preferredFrameSize.height
//     
//        cameraContainer.preferredFrameSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.width+50)

//        
//        var mainStack = [ASLayoutable]()
//        
//        mainStack.append(navigationStack)
//        mainStack.append(cameraContainer)
//        mainStack.append(pagerInterfaceNode)
//        if showPagerControls {
//            mainStack.append(pageButtonsNodeStack)
//        }
////        else if showNextControls {
////            mainStack.append(pageButtonsNodeStack)
////        }
//        
//        let lastStack = ASStackLayoutSpec(direction: .Vertical,
//                                          spacing: 0,
//                                          justifyContent: .End,
//                                          alignItems: .Stretch,
//                                          children: mainStack)
//        
//        return lastStack
//
//        
//        
    }
    
    
    
        
    
    
    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
                            HELPER FUNCTIONS
     
     ================================================================================
     ================================================================================
     */
    
    
    
    let textSize: CGFloat = 20.0
    
    func pageTitlesAttributedString(string: String, forState state: UIControlState) -> NSAttributedString {
        
        switch state {
        case UIControlState.Normal:
            let lightGray = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: lightGray,
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
        case UIControlState.Highlighted:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blueColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
            
        case UIControlState.Selected:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
        default:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: textSize)!])
        }
    }
    
}
