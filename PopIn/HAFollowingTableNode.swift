//
//  HAFollowingTableNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol HAFollowingTableNodeDelegate {
    func tabbarHeight() -> CGFloat
    func openCamera()
}
class HAFollowingTableNode: ASDisplayNode {
    
    
    var delegate: HAFollowingTableNodeDelegate?
    let tableNode: ASTableNode

    let screenView: ASDisplayNode
    let cameraButton: ASButtonNode
    var activityIndicatorView: UIActivityIndicatorView

    
    override init() {
        
        print("initing this")
        
        screenView = ASDisplayNode()
//        screenView.sizeRange = ASRelativeSizeRangeMake( ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(kSoldOutGBHeight)),
//        ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(kSoldOutGBHeight)));
        screenView.backgroundColor = UIColor.greenColor()
        screenView.flexGrow = true
        screenView.layerBacked = true
        screenView.hidden = true
  
        
        
        tableNode = ASTableNode(style: .Plain)
        cameraButton = ASButtonNode()
        cameraButton.setImage(UIImage(named: "camera"), forState: .Normal)
        cameraButton.setImage(UIImage(named: "earth"), forState: .Selected)
        cameraButton.setImage(UIImage(named: "earth"), forState: .Highlighted)
        cameraButton.contentMode = .ScaleAspectFit
        cameraButton.hidden = true
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

        super.init()
        
        
        addSubnode(screenView)
        addSubnode(tableNode)
        addSubnode(cameraButton)
        
    }
    
    override func didLoad() {
        super.didLoad()        
        cameraButton.addTarget(self, action: #selector(openCamera), forControlEvents: .TouchUpInside)
       
        view.addSubview(activityIndicatorView)
    }
    
    
    
    override func layout() {
        super.layout()

        let boundSize = view.bounds.size
        
        activityIndicatorView.sizeToFit()
        var refreshRect = activityIndicatorView.frame
        refreshRect.origin = CGPointMake( (boundSize.width - activityIndicatorView.frame.size.width)/2.0, (boundSize.height - activityIndicatorView.frame.size.height) / 2.0)
        
        activityIndicatorView.frame = refreshRect
        activityIndicatorView.color = UIColor.blackColor()
        
    }
    
    
    func openCamera() {
        delegate!.openCamera()
    }
    
    
    
    func showSpinningWheel() {
        activityIndicatorView.startAnimating()
        screenView.hidden = false
    }
    
    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
        screenView.hidden = true
        
    }
    

    
    
    func getTabbarHeight() -> CGFloat {
        return  (delegate?.tabbarHeight())!
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
//        let buttonHeight = constrainedSize.max.height/8
//        
//        cameraButton.preferredFrameSize = CGSizeMake(constrainedSize.max.width, buttonHeight)
//        let staticButtonsDisplaySpec = ASStaticLayoutSpec(children: [cameraButton])
//        
//        tableNode.flexGrow = true
//        
//        let tablePreferredSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height - buttonHeight)
//        tableNode.preferredFrameSize = tablePreferredSize
//        let staticTableNodeSpec = ASStaticLayoutSpec(children: [ tableNode])
        
//        let tabbarHeight
        
        
        let soldOutBG = ASStaticLayoutSpec(children: [screenView])
        let centerScreen = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: soldOutBG)
        
        let whiteScreenOverTable = ASOverlayLayoutSpec(child: tableNode, overlay: centerScreen)
        
//        ASOverlayLayoutSpec *soldOutOverImage = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageSpec
//            overlay:[self soldOutLabelSpec]];
//        
//        
//        ASStaticLayoutSpec *soldOutBG = [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[self.soldOutLabelBackground]];
//        
//        ASCenterLayoutSpec *centerSoldOut = [ASCenterLayoutSpec
//        centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
//        sizingOptions:ASCenterLayoutSpecSizingOptionDefault
//        child:soldOutBG];
//        
        
        
        cameraButton.borderColor = UIColor.greenColor().CGColor
        cameraButton.borderWidth = 2.0
  
        let tabarHeight = getTabbarHeight()
        let buttonWidth = constrainedSize.max.width/7
        
        let cameraButtonYPosition = constrainedSize.max.height - tabarHeight - buttonWidth  - 10
        
        
        cameraButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonWidth)
        cameraButton.layoutPosition = CGPointMake(constrainedSize.max.width-buttonWidth, cameraButtonYPosition)
                                                  //UIScreen.mainScreen().bounds.height)
        
        cameraButton.sizeRange = ASRelativeSizeRangeMake(
            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(0), ASRelativeDimensionMakeWithPoints(buttonWidth)),
            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(buttonWidth)))
        let cameraButtonStatic = ASStaticLayoutSpec(children: [cameraButton])

        
        let cameraButtonOverTablenode = ASOverlayLayoutSpec(child: whiteScreenOverTable, overlay: cameraButtonStatic)
        
        cameraButtonOverTablenode.flexGrow = true
    
        return cameraButtonOverTablenode
        
        
//        return ASStackLayoutSpec(direction: .Vertical,
//                                                  spacing: 0,
//                                                  justifyContent: .SpaceBetween,
//                                                  alignItems: .End,
//                                                  children: [tableNode])

      
//        let fullStack = ASStackLayoutSpec(direction: .Vertical,
//                                          spacing: 0,
//                                          justifyContent: .SpaceBetween,
//                                          alignItems: .End,
//                                          children: [staticTableNodeSpec, staticButtonsDisplaySpec])
//        return fullStack
//        
//        
//        
//        let pagerHeight = constrainedSize.max.height*(1/5)
//        
//        pagerInterfaceNode.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
//        pagerInterfaceNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, pagerHeight)
//        
//        pagerInterfaceNode.layoutPosition = CGPointMake(0, constrainedSize.max.height - pagerHeight)
//        
//        pagerInterfaceNode.sizeRange = ASRelativeSizeRangeMake(
//            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(0), ASRelativeDimensionMakeWithPoints(300)),
//            ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(1), ASRelativeDimensionMakeWithPoints(300)));
//        
//        let pagerInterfaceNodeStatic = ASStaticLayoutSpec(children: [pagerInterfaceNode])
//        
//        let pagerOverImage = ASOverlayLayoutSpec(child: cameraContainer, overlay: pagerInterfaceNodeStatic)
//        
//        pagerOverImage.flexGrow = true
        
    }
}
