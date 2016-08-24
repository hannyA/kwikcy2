//
//  ProfileButtonNode2.swift
//  PopIn
//
//  Created by Hanny Aly on 8/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class ProfileButtonNode2: ASButtonNode {
    
    let loadingViewOverlayNode: ASImageNode
    let activityIndicatorView:UIActivityIndicatorView
    
    
    override init() {
        
        print("ProfileButtonNode init")
        
        //Center Spining wheel
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.whiteColor()
        
        
        // Full screen Cover to show that screen cannot be used
        
        loadingViewOverlayNode = ASImageNode()
        loadingViewOverlayNode.contentMode = .ScaleAspectFit
        loadingViewOverlayNode.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        
        
        super.init()
        // Full screen Cover to show that screen cannot be used
        
        setBackgroundImage(UIImage(named: "circle"), forState: .Normal)
        backgroundImageNode.contentMode = .ScaleAspectFit
        backgroundImageNode.layerBacked = false

        
        let photoAttributedTitle = HAGlobal.titlesAttributedString("PHOTO",
                                                                   color: UIColor.whiteColor(),
                                                                   textSize: kTextSizeXL)
//        titleNode.attributedText = photoAttributedTitle
        
        setAttributedTitle(photoAttributedTitle,
                           forState: .Normal)
    }
    
    
    override func didLoad() {
        super.didLoad()
        
//        addSubnode(loadingViewOverlayNode)
        view.addSubview(activityIndicatorView)
        
        loadingImage(false)
    }
    
    override func layout() {
        super.layout()
        activityIndicatorView.center = backgroundImageNode.view.center
    }
    
    
    func enableButton(enabled: Bool) {
        print("here enableButton: \(enabled)")
        self.enabled = enabled
        loadingViewOverlayNode.hidden = enabled
    }
    
    
    func loadingImage(loading: Bool) {
        
        enableButton(!loading)
        
        if loading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    func backgroundImageIsNull() -> Bool {
        if backgroundImageForState(.Normal) != nil {
            return false
        } else  {
            return true
        }
    }
    
    
    func imageIsNull() -> Bool {
        if backgroundImageForState(.Normal) != nil {
            return false
        } else  {
            return true
        }
    }
    
    
    
    func setImage(image: UIImage?, cornerRadius: CGFloat) {
        
        print("Setting image circle")
        
        makeImageCircle(backgroundImageNode, cornerRadius: cornerRadius)
        setAttributedTitle(nil, forState: .Normal)
        setBackgroundImage(image, forState: .Normal)
    }
    
    
    
    func makeImageCircle(imageNode: ASImageNode, cornerRadius: CGFloat) {
        
        print("Make image circle")
        imageNode.imageModificationBlock = { (image) -> UIImage? in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth = constrainedSize.max.width
        
        loadingViewOverlayNode.cornerRadius = maxWidth/2
        loadingViewOverlayNode.clipsToBounds = true
        
        makeImageCircle(loadingViewOverlayNode, cornerRadius: maxWidth/2)
       
        loadingViewOverlayNode.preferredFrameSize = CGSizeMake(maxWidth, maxWidth)
//        let staticLoadingViewOverlayNode = ASStaticLayoutSpec(children: [loadingViewOverlayNode])
        
        return ASOverlayLayoutSpec(child: titleNode, overlay: loadingViewOverlayNode)
    }
    
    
}