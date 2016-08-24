//
//  HAFullCameraNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


protocol HAFullCameraDelegate {
    func didCancelCamera()
    func moveToNextVC()
}

class HAFullCameraNode: ASDisplayNode, ASCollectionDelegate, ASPagerDataSource { // ASPagerNodeDataSource
    
    
    let CameraTitle = "Camera"
    let LibraryTitle = "Library"
    
    var delegate: HAFullCameraDelegate?
    
    
    var leftNavigationButton: ASButtonNode
    var middleNavigationButton: ASButtonNode
    var rightNavigationButton: ASButtonNode
    
    var imageView: ASImageNode
    
    let pagerNode: ASPagerNode
    
    
    let cameraPagerButton: ASButtonNode
    let libraryPagerButton: ASButtonNode
    
    
    
    
    
    
    
    
    init(leftText: String, middleText: String, rightText: String) {
        
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
            button.setAttributedTitle(normalAttributedString(text, forState:.Normal), forState: .Normal)
            button.setAttributedTitle(normalAttributedString(text, forState:.Disabled), forState: .Disabled)
            button.setAttributedTitle(normalAttributedString(text, forState:.Highlighted), forState: .Highlighted)
            
            button.setAttributedTitle(normalAttributedString(text, forState:.Selected), forState: .Selected)
            return button
        }
        
        
        
        
        leftNavigationButton   = createButtonWithAllStatesSetWithText(leftText)
        middleNavigationButton = createButtonWithAllStatesSetWithText(middleText)
        rightNavigationButton  = createButtonWithAllStatesSetWithText(rightText)

        rightNavigationButton.enabled = false
        
        // UIImagePickerViewController
        imageView = ASImageNode()
        
        // Camera controls
        pagerNode = ASPagerNode()

        //Bottom Page Controls
        cameraPagerButton = ASButtonNode()
        cameraPagerButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        cameraPagerButton.flexGrow = true
        
        libraryPagerButton = ASButtonNode()
        libraryPagerButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        libraryPagerButton.flexGrow = true
        
        
        super.init()
        
        // Navigation top
        leftNavigationButton.addTarget(self, action: #selector(dismissCamera), forControlEvents: .TouchUpInside)
        rightNavigationButton.addTarget(self, action: #selector(moveToNextViewController), forControlEvents: .TouchUpInside)
        
        
        // Camera and libary view
        imageView.backgroundColor = UIColor.blackColor()
        imageView.placeholderEnabled = true
        
        
        // Camera controls - reocrd, flash, etc
        pagerNode.setDataSource(self)
        pagerNode.backgroundColor = UIColor.darkGrayColor()
//        pagerNode.dele
//        pagerNode.delegate = self
        
        
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
        
     
        
        
        cameraPagerButton.selected  = true
        libraryPagerButton.selected = false
        
        
        backgroundColor = UIColor.greenColor()

        usesImplicitHierarchyManagement = true
    }
    
    
    
    
    /* ================================================================================
     ================================================================================
     
                    CAMERA DELEGATE METHODS
     
     ================================================================================
     ================================================================================
     */
    
    func dismissCamera() {
        delegate?.didCancelCamera()
    }
    
    
    func moveToNextViewController() {
        delegate?.moveToNextVC()
    }
    
    
    // Select Page Controls
    
    func showCameraControls() {
        print("showCameraControls")
        
        cameraPagerButton.selected = true
        libraryPagerButton.selected = false
        
        pagerNode.scrollToPageAtIndex(0, animated: true)
    }
    
    
    func showLibraryControls() {
        print("showLibraryControls")
        
        libraryPagerButton.selected = true
        cameraPagerButton.selected = false
        pagerNode.scrollToPageAtIndex(1, animated: true)
    }
    
    
    
    
    
    /* ================================================================================
       ================================================================================
    
                            SCROLLVIEW DELEGATE METHODS
     
       ================================================================================
       ================================================================================
    */
 
 
 
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
        
//        print("donezo percentage: \(percentage)")
        
        changeButtonForScrollPercentage(percentage)
    }
    
    
    
//    // When finished scrolling by page button
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        print("scrollViewDidEndScrollingAnimation")
////        let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
//    }
    
    
    
    
    
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
    

    
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
//        let boundSize: CGSize = CGSizeMake(pagerNode.bounds.width, 400)
//        print("pagerNode CGSizeMake: \(boundSize)")
        
        let discoveryPageNode = HADiscoveryNode()
        
//        discoveryPageNode.preferredFrameSize = boundSize
        
        if index == 0 {
            discoveryPageNode.backgroundColor = UIColor.redColor()
        } else { // if index == 1 {
            discoveryPageNode.backgroundColor = UIColor.blueColor()
        }
        
        return discoveryPageNode
    }
    
    func numberOfPagesInPagerNode(pagerNode: ASPagerNode!) -> Int {
        return 2
    }
    
    
    
    
    
    
    /* ================================================================================
     ================================================================================
     
                        LAYOUT SPEC
     
     ================================================================================
     ================================================================================
     */
    

    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let navigationStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .Center,
                                          children: [leftNavigationButton, middleNavigationButton, rightNavigationButton])
        let ceilings:CGFloat = 10.0
        let sides:CGFloat = 15.0
        
        navigationStack.flexShrink = true
        navigationStack.alignSelf = .Stretch
        
        let topstackWithInsets = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: navigationStack)
        
        
        
        
        imageView.preferredFrameSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.width)

        
        
        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                                     spacing: 0,
                                                     justifyContent: .SpaceAround,
                                                     alignItems: .Center,
                                                     children: [cameraPagerButton, libraryPagerButton])
        
//        let bottomStackWithInsets = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(ceilings, sides, ceilings, sides), child: pageButtonsNodeStack)

        

        pagerNode.flexGrow = true
        let lastStack = ASStackLayoutSpec(direction: .Vertical,
                                                     spacing: 0,
                                                     justifyContent: .Start,
                                                     alignItems: .Stretch,
                                                     children: [topstackWithInsets, imageView, pagerNode, pageButtonsNodeStack])
        
        return lastStack
        
        
        
        let fullNodeStack = ASStackLayoutSpec(direction: .Vertical,
                                                     spacing: 0,
                                                     justifyContent: .SpaceAround,
                                                     alignItems: .Start,
                                                     children: [topstackWithInsets, imageView, pagerNode, pageButtonsNodeStack])
        return fullNodeStack
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
