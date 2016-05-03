//
//  WelcomeNode.swift
//  PopIn
//
//  Created by Hanny Aly on 4/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class WelcomeNode: ASDisplayNode {
    
    let kSigninButtonHeight = UIScreen.mainScreen().bounds.size.height / 5
    
    let titleLabel: ASTextNode
    let signinButton: SignInButton
    
    
    
    
    func updateTitle() -> NSAttributedString {
        
        return NSAttributedString(string: "Plum Record", fontSize: 50, color: UIColor.blackColor(), firstWordColor: UIColor.redColor())

        let multipleAttributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
        
            NSFontAttributeName: UIFont.systemFontOfSize(50)]
        
        return NSAttributedString(string: "Eye Records", attributes: multipleAttributes)
    }
    
    override init() {
        

        signinButton = SignInButton()
        
//        signinButton.addTarget(self, action: #selector(signinThroughFacebook), forControlEvents: .TouchUpInside)
        
        titleLabel = ASTextNode()
        
        super.init()
        
        titleLabel.maximumNumberOfLines = 1;
//        titleLabel.alignSelf = .Center
        titleLabel.flexGrow = true
        titleLabel.layerBacked = true
        titleLabel.attributedString = updateTitle()
        
//        signinButton.flexGrow = true
//        signinButton.autoresizingMask = .FlexibleWidth
//          imageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//        signinButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)

        
        addSubnode(titleLabel)
        addSubnode(signinButton)
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
//        let preferredHeight = UIScreen.mainScreen().bounds.size.height / 7
//        
//        let preferredWidth: CGFloat = constrainedSize.max.width;
//        
//        signinButton.preferredFrameSize = CGSizeMake(preferredWidth, preferredHeight)
//        signinButton.frame = cgrectma

        

        let kInsetHorizontal: CGFloat = 16.0
        let kInsetTop: CGFloat = 6.0
        let kInsetBottom: CGFloat = 0.0
        
        let titleInsets: UIEdgeInsets = UIEdgeInsetsMake(kInsetTop, kInsetHorizontal, kInsetBottom, kInsetHorizontal);
        
        
        
        let appTitle = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: titleLabel)
        
        let appTitleWrapper = ASInsetLayoutSpec(insets: titleInsets, child: appTitle)
        appTitleWrapper.flexGrow = true
        
        
        
        let signintitleInsets: UIEdgeInsets = UIEdgeInsetsMake(kInsetTop, kInsetHorizontal, kInsetBottom, kInsetHorizontal);

        let signinButtonCenter = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: signinButton)

        let signinButtWrapper = ASInsetLayoutSpec(insets: signintitleInsets, child: signinButtonCenter)
        signinButtWrapper.flexGrow = true
        
        
        
        let titleStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 0,
                                          justifyContent: .Center,
                                          alignItems: .Center,
                                          children: [titleLabel])

        
        let titleWrapper = ASInsetLayoutSpec(insets: titleInsets, child: appTitle)
        titleWrapper.flexGrow = true
        
        let verticalSpacer = ASLayoutSpec()
        verticalSpacer.flexGrow = true
        
        
//        UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        
        let signinButtonInsets: UIEdgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
        
        let siginButtonStack = ASStackLayoutSpec(direction: .Horizontal,
                                           spacing: 0,
                                           justifyContent: .Start,
                                           alignItems: .Stretch,
                                           children: [signinButton])
        
        let siginButtonWrapper = ASInsetLayoutSpec(insets: signinButtonInsets, child: siginButtonStack)
        siginButtonWrapper.flexGrow = true

        
        let verticalLayout = ASStackLayoutSpec(direction: .Vertical,
                                                spacing: 0,
                                                justifyContent: .Start,
                                                alignItems: .Stretch ,
                                                children: [appTitleWrapper, verticalSpacer, signinButton])
        
        verticalLayout.flexGrow = true
    
        return verticalLayout;
        
    }
    
    
//    
//    func signinThroughFacebook() {
//        
//        let alertView = UIAlertController(title: "Title", message: "a message", preferredStyle: .Alert)
//
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            print("You've pressed okay")
//        }
//
//        alertView.addAction(OKAction)
//
//        self.presentViewController(alertController, animated: true, completion:nil)
//    }
//    
    
    
    //    override func didLoad() {
    //        super.didLoad()
    ////        welcomeImageNode.frame = view.frame
    ////        welcomeImageNode.contentMode = .ScaleAspectFill
    //
    ////        addSubnode(signinButton)
    //
    ////        view.addSubnode(facebookIconImageNode)
    //
    ////            imageNode.frame = self.view.bounds;
    //////            imageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ////            imageNode.contentMode = UIViewContentModeScaleAspectFit;
    ////
    ////            [self.view addSubnode:imageNode];
    //    }
    
    //    

}