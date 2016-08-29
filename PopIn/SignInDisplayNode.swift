//
//  WelcomeNode.swift
//  PopIn
//
//  Created by Hanny Aly on 4/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import ChameleonFramework
import NVActivityIndicatorView

class SignInDisplayNode: ASDisplayNode {
    
    let kSigninButtonHeight = UIScreen.mainScreen().bounds.size.height / 5
    
    
    let appTitleLabel: ASTextNode
    let signinButton: LTRButtonNode

    let screenView: ASDisplayNode
//    let activityIndicatorView: UIActivityIndicatorView
    
    let spinningWheel: NVActivityIndicatorView
    
    
    
    override init() {
        spinningWheel = NVActivityIndicatorView(frame: CGRectMake(0, 0, 65, 65),
                                    type: .BallRotateChase,
                                    color: UIColor.flatWhiteColor(),
                                    padding: 10.0)
        spinningWheel.hidesWhenStopped = true
        
    
        
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//        activityIndicatorView.color = UIColor.blackColor()
        
        screenView = ASDisplayNode()
        screenView.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        screenView.flexGrow = true
        screenView.layerBacked = true
  
        
        
        
        
        signinButton = LTRButtonNode()
//        signinButton.contentEdgeInsets = UIEdgeInsetsMake(40, 0, 60, 0)
        let normalSigninTitle = HAGlobal.titlesAttributedString("Sign in with Facebook",
                                                                color: UIColor.flatWhiteColor(),
                                                                textSize: 30)
        
        let selectedSigninTitle = HAGlobal.titlesAttributedString("Sign in with Facebook",
                                                                  color: UIColor.flatGrayColor(),
                                                                  textSize: 30)
        
        
        signinButton.setAttributedTitle(normalSigninTitle,
                                        forState: .Normal)
        signinButton.setAttributedTitle(selectedSigninTitle,
                                        forState: .Highlighted )
        signinButton.setAttributedTitle(selectedSigninTitle,
                                        forState: .Selected)
        
        
        signinButton.imageNodeIcon(from: .Ionicon,
                                   code: "social-facebook-outline",
                                   imageSize: CGSizeMake(30, 45),
                                   ofSize: 45,
                                   color: UIColor.flatWhiteColor(),
                                   forState: .Normal)
        signinButton.imageNodeIcon(from: .Ionicon,
                                   code: "social-facebook-outline",
                                   imageSize: CGSizeMake(30, 45),
                                   ofSize: 45,
                                   color: UIColor.flatGrayColor(),
                                   forState: .Selected)
        signinButton.imageNodeIcon(from: .Ionicon,
                                   code: "social-facebook-outline",
                                   imageSize: CGSizeMake(30, 45),
                                   ofSize: 45,
                                   color: UIColor.flatGrayColor(),
                                   forState: .Highlighted)
        
        
//        signinButton.setImage(UIImage(named: "FacebookWhiteIcon"),
//                              forState: .Normal)
//        signinButton.setImage(UIImage(named: "FacebookWhiteIcon"),
//                              forState: .Highlighted)
//        signinButton.setImage(UIImage(named: "FacebookWhiteIcon"),
//                              forState: .Selected)
        
        appTitleLabel = ASTextNode()
        appTitleLabel.layerBacked = true
        appTitleLabel.attributedString = NSAttributedString(string: AppName,
                                                            fontSize: 50,
                                                            color: UIColor.blackColor(),
                                                            firstWordColor: UIColor.redColor())
        
        super.init()
        
        addSubnode(appTitleLabel)
        addSubnode(signinButton)
        addSubnode(screenView)
    }
    
    
    
    
    
    func showSpinningWheel() {
//        activityIndicatorView.startAnimating()
        screenView.hidden = false
        
        spinningWheel.startAnimation()
    }
    
    func hideSpinningWheel() {
//        activityIndicatorView.stopAnimating()
        screenView.hidden = true
        spinningWheel.stopAnimation()
        
    }

    
    override func didLoad() {
        super.didLoad()
        hideSpinningWheel()
        

        view.addSubview(spinningWheel)
//        view.addSubview(activityIndicatorView)
    }
    
    
    override func layout() {
        super.layout()
        
        backgroundColor = GradientColor(.TopToBottom,
                                        frame: view.frame,
                                        colors: [
                                            UIColor.flatWatermelonColor(),
                                            UIColor.flatWhiteColor(),
                                            UIColor.flatWhiteColor()])
        
        
        spinningWheel.center = view.center
        
//        activityIndicatorView.center = view.center
    
    
//        let backgroundImageView = UIImageView(image: UIImage(named: "mad-men-1.png"))
//        backgroundImageView.contentMode = .ScaleAspectFill
//        backgroundImageView.frame = view.frame
//        backgroundImageView.userInteractionEnabled = false
//        
//        view.addSubview(backgroundImageView)
//        view.sendSubviewToBack(backgroundImageView)
        
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let signinButtonInsets = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 0, 15, 0),
                                                  child: signinButton)

        
        
        let titleStack = ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 0,
                                           justifyContent: .SpaceBetween,
                                           alignItems: .Center,
                                           children: [appTitleLabel, signinButtonInsets])
        
        let fullWrapperInsets = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(80, 10, 0, 10) ,
                                                  child: titleStack)


        return ASOverlayLayoutSpec(child: fullWrapperInsets, overlay: screenView)
    }
}

