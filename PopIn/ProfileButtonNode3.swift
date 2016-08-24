////
////  ProfileButtonNode3.swift
////  PopIn
////
////  Created by Hanny Aly on 8/10/16.
////  Copyright © 2016 Aly LLC. All rights reserved.
////
//
//import AsyncDisplayKit
//
//
//class ProfileButtonNode: ASButtonNode {
//    
//    let loadingViewOverlayNode: ASImageNode
//    let activityIndicatorView: UIActivityIndicatorView
//    
//    
//    override init() {
//        
//        print("ProfileButtonNode init")
//        
//        //Center Spining wheel
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//        activityIndicatorView.color = UIColor.whiteColor()
//        
//        
//        // Full screen Cover to show that screen cannot be used
//        
//        loadingViewOverlayNode = ASImageNode()
//        loadingViewOverlayNode.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
//        loadingViewOverlayNode.flexGrow = true
//        
//        
//        
//        super.init()
//        
//        setBackgroundImage(UIImage(named: "circle"), forState: .Normal)
//        backgroundImageNode.contentMode = .ScaleAspectFit
//        
//        let photoAttributedTitle = HAGlobal.titlesAttributedString("PHOTO",
//                                                                   color: UIColor.whiteColor(),
//                                                                   textSize: kTextSizeXL)
//        buttonNode.setAttributedTitle(photoAttributedTitle, forState: .Normal)
//    }
//    
//    
//    override func didLoad() {
//        super.didLoad()
//        
//        addSubnode(loadingViewOverlayNode)
//        view.addSubview(activityIndicatorView)
//        
//        loadingImage(false)
//    }
//    
//    override func layout() {
//        super.layout()
//        activityIndicatorView.center = loadingViewOverlayNode.view.center
//    }
//    
//    
//    func enableButton(enabled: Bool) {
//        buttonNode.enabled = enabled
//        loadingViewOverlayNode.hidden = enabled
//    }
//    
//    func loadingImage(loading: Bool) {
//        
//        enableButton(!loading)
//        
//        if loading {
//            activityIndicatorView.startAnimating()
//        } else {
//            activityIndicatorView.stopAnimating()
//        }
//    }
//    
//    func backgroundImageIsNull() -> Bool {
//        if buttonNode.backgroundImageForState(.Normal) != nil {
//            return false
//        } else  {
//            return true
//        }
//    }
//    
//    
//    func imageIsNull() -> Bool {
//        if buttonNode.imageForState(.Normal) != nil {
//            return false
//        } else  {
//            return true
//        }
//    }
//    
//    
//    
//    func setImage(image: UIImage?, cornerRadius: CGFloat) {
//        
//        print("Setting image circle")
//        
//        buttonNode.imageNode.contentMode = .ScaleAspectFit
//        buttonNode.imageNode.imageModificationBlock = { image in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
//        buttonNode.backgroundImageNode.imageModificationBlock = { image in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
//        
//        setAttributedTitle(nil, forState: .Normal)
//        buttonNode.setImage(image, forState: .Normal)
//        
//        //        buttonNode.clipsToBounds = true
//        //        buttonNode.cornerRadius = cornerRadius
//        
//    }
//    
//    func setAttributedTitle(title: NSAttributedString?, forState state: ASControlState) {
//        buttonNode.setAttributedTitle(title, forState: state)
//    }
//    
//    
//    func attributedTitleForState(state: ASControlState) -> NSAttributedString? {
//        return buttonNode.attributedTitleForState(state)
//    }
//    
//    
//    
//    
//    func makeImageCircle(imageNode: ASImageNode, cornerRadius: CGFloat) {
//        
//        print("Make image circle")
//        imageNode.imageModificationBlock = { (image) -> UIImage? in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
//    }
//    
//    
//    
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        let maxWidth = constrainedSize.max.width
//        loadingViewOverlayNode.cornerRadius = maxWidth/2
//        loadingViewOverlayNode.clipsToBounds = true
//        
//        loadingViewOverlayNode.imageModificationBlock = { image in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: maxWidth/2).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
//        
//        loadingViewOverlayNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height)
//        
//        
//        return ASOverlayLayoutSpec(child: buttonNode, overlay: loadingViewOverlayNode)
//    }
//}