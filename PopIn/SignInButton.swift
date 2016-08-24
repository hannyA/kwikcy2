//
//  SignInButton.swift
//  PopIn
//
//  Created by Hanny Aly on 4/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SignInButton: ASButtonNode {
    
    
//    let facebookIconNode: ASImageNode
//    let signinText: ASTextNode
    
    var blurViewOverlay: ASDisplayNode
    
    
    override init() {
                
        blurViewOverlay = ASDisplayNode()
        
        super.init()
        
        
        
        titleNode.attributedText = HAGlobal.titlesAttributedString("Sign in with Facebook", color: UIColor.whiteColor(), textSize: 30)
                
        imageNode.image =  UIImage(named: "FacebookWhiteIcon")
        
        blurViewOverlay = ASDisplayNode(viewBlock: { () -> UIView in

            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
            
            let vibrancy1 = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .ExtraLight))
            let vibrancyEffectView1 = UIVisualEffectView(effect: vibrancy1)
            vibrancyEffectView1.hidden = true

            blurEffectView.contentView.addSubview(vibrancyEffectView1)
            return blurEffectView
        })

        
        addSubnode(blurViewOverlay)
    }
    
//    override func didLoad() {
//        super.didLoad()
//    }
    
    
//    // MARK: helper methods
//    func signinAttributedString(selected: Bool) -> NSAttributedString {
//        
//        let multipleAttributes: [ String: AnyObject]
//        if selected {
//            multipleAttributes = [
//                NSForegroundColorAttributeName: UIColor.blackColor(),
//                //            NSBackgroundColorAttributeName: UIColor.darkBlueColor(),
//                // NSFontAttributeName: UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//                NSFontAttributeName: UIFont.systemFontOfSize(30)]
//            
//        } else {
//            multipleAttributes = [
//                NSForegroundColorAttributeName: UIColor.whiteColor(),
//                //            NSBackgroundColorAttributeName: UIColor.darkBlueColor(),
//                // NSFontAttributeName: UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//                NSFontAttributeName: UIFont.systemFontOfSize(30)]
//            
//        }
//        
//        
//        let attrString = NSAttributedString(string: "Signin with Facebook", attributes: multipleAttributes)
//        
//        return attrString
//    }
    
    
//    override var highlighted: Bool {
//        didSet {
//            signinText.attributedString = signinAttributedString(highlighted)
//            blurViewOverlay.backgroundColor = highlighted ? UIColor.blackColor() : UIColor.clearColor()
//        }
//    }
    
    
//    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        let horizontalButtonViewsStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                spacing: 10,
//                                                justifyContent: .Center,
//                                                alignItems: .Center,
//                                                children: [ facebookIconNode, signinText])
//    
//        let signinButtonInsets: UIEdgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
//
//        let buttonWrapper = ASInsetLayoutSpec(insets: signinButtonInsets, child: horizontalButtonViewsStack)
//        
//        let blurOverlay = ASOverlayLayoutSpec(child: buttonWrapper, overlay: blurViewOverlay)
//   
//        return blurOverlay;
//    }
    
    
    
    
//    func imageSizeForScreenWidth() -> CGSize {
//        let screenRect: CGRect = UIScreen.mainScreen().bounds
//        let screenScale: CGFloat = UIScreen.mainScreen().scale
//        return CGSizeMake(screenRect.size.width * screenScale, screenRect.size.width * screenScale)
//        
//    }
    
    
    
}

