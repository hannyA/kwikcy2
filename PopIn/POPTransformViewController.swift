//
//  POPTransformViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import pop


class POPTransformViewController: UIViewController, POPAnimatorDelegate {
    
    
    
    let kKey1 = "hannyiable"
    let kClearing = "clearingOut"
    let kSliding = "sliding"
    
    
    
    func animatorWillAnimate(animator: POPAnimator!) {
        
        print("animatorWillAnimate")
    }
    func animatorDidAnimate(animator: POPAnimator!) {
        print("animatorDidAnimate")
    }
    
    
    
    
    var firstBoxButton: UIButton = UIButton(type: .Custom)
    var secondBoxButton: UIButton = UIButton(type: .Custom)
    var thirdBoxButton: UIButton = UIButton(type: .Custom)
    var boxView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thirdScreenWidth = view.frame.width/3
        
        
        let x1 = thirdScreenWidth * 0
        let x2 = thirdScreenWidth * 1
        let x3 = thirdScreenWidth * 2
        let y: CGFloat = 335
        
        // Compare box distance
        let view1 = UIView(frame: CGRectMake(x1, y, thirdScreenWidth, 10))
        let view2 = UIView(frame: CGRectMake(x2, y, thirdScreenWidth, 10))
        let view3 = UIView(frame: CGRectMake(x3, y, thirdScreenWidth, 10))
        
        view1.backgroundColor = UIColor.redColor()
        view2.backgroundColor = UIColor.greenColor()
        view3.backgroundColor = UIColor.redColor()
        
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        
        
        boxView.frame = CGRectMake(0, 350, 400, 400)
        boxView.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view.
        view.addSubview(boxView)
        
        
        let boxHeight:CGFloat = 80
        firstBoxButton.frame = CGRectMake(x1, 120, thirdScreenWidth, boxHeight)
        firstBoxButton.addTarget(self, action: #selector(shiftBoxToLeftAndClear), forControlEvents: .TouchUpInside)
        firstBoxButton.backgroundColor = UIColor.redColor()
        firstBoxButton.setTitle("First", forState: .Normal)
        firstBoxButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        firstBoxButton.tag = 1
        view.addSubview(firstBoxButton)
        
        
        secondBoxButton.frame = CGRectMake(x2, 120, thirdScreenWidth, boxHeight)
        secondBoxButton.addTarget(self, action: #selector(boxButtonPressed), forControlEvents: .TouchUpInside)
        secondBoxButton.backgroundColor = UIColor.greenColor()
        secondBoxButton.setTitle("Second", forState: .Normal)
        secondBoxButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        secondBoxButton.tag = 2
        view.addSubview(secondBoxButton)
        
        
        thirdBoxButton.frame = CGRectMake(x3, 120, thirdScreenWidth, boxHeight)
        thirdBoxButton.addTarget(self, action: #selector(boxButtonPressed), forControlEvents: .TouchUpInside)
        thirdBoxButton.backgroundColor = UIColor.redColor()
        thirdBoxButton.setTitle("Third", forState: .Normal)
        thirdBoxButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        thirdBoxButton.tag = 3
        view.addSubview(thirdBoxButton)
        
        
        
        
        
    }
    
    let kNumberOfButtons:CGFloat = 3
    
    
    let firstButton:CGFloat = 0
    let secondButton:CGFloat = 1
    let thirdButton:CGFloat = 2
    
    
    
    func toCenterPosition(buttonTag: Int) -> CGFloat{
        
        let width = view.frame.width/kNumberOfButtons
        
        let xPosition = ( CGFloat(buttonTag - 1) * width) + (width/2)
        return xPosition
    }
    
    var removingBox: Bool = true
    
    
    func shiftBoxToLeftAndClear() {
        
        let basicanimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        basicanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let slideanimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        slideanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        if removingBox {
            
            basicanimation.duration = 0.5
            slideanimation.duration = 0.6
            
            basicanimation.toValue = 0
            slideanimation.toValue = -200
            
        }else {
            
            basicanimation.duration = 0.2
            slideanimation.duration = 0.2
            
            basicanimation.toValue = 1
            let center = view.center.x
            
            slideanimation.toValue = center

        }
        
        basicanimation.name = "ClearAnimation"
        basicanimation.delegate = self
        boxView.pop_addAnimation(basicanimation, forKey: kClearing)
    

        slideanimation.name = "slideAnimation"
        slideanimation.delegate = self
        
        boxView.pop_addAnimation(slideanimation, forKey: kSliding)
        
        removingBox = !removingBox
    }
    
    
    
    func clearBox() {
       
        let basicanimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        basicanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        basicanimation.duration = 0.2
        
//        let basicanimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
//        basicanimation.velocity = 1000
//        basicanimation.springBounciness = 3
//        basicanimation.springSpeed = 3
        
        
        
        
        if removingBox {
            basicanimation.toValue = 0
        } else {
            basicanimation.toValue = 1
        }
        
        basicanimation.name = kKey1
        basicanimation.delegate = self
        
        boxView.pop_addAnimation(basicanimation, forKey: kKey1)
        removingBox = !removingBox

    }
    
    
    func boxButtonPressed(button: UIButton) {
        
        print("Box button pressed")
//        kPOPLayerOpacity
//        kPOPViewAlpha
        
        // POPBasicAnimation
        let basicanimation: POPBasicAnimation = POPBasicAnimation()
        basicanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    
        
        
        // POPSpringAnimation
        //        let basicanimation = POPSpringAnimation()
        //        basicanimation.velocity = 1000
        //        basicanimation.springBounciness = 0
        //        basicanimation.springSpeed = 0
        
        
        
        // POPDecayAnimation
//        let basicanimation = POPDecayAnimation()
//        basicanimation.velocity = 433 //change of value units per second
//        basicanimation.deceleration = 0.833 //range of 0 to 1
        
        
        
        
        
        // Size - kPOPViewBounds
        basicanimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerPositionX) as! POPAnimatableProperty
//        basicanimation.fromValue
        basicanimation.toValue = toCenterPosition(button.tag)
        
        
        
        
        basicanimation.name = kKey1
        basicanimation.delegate = self
        
        boxView.pop_addAnimation(basicanimation, forKey: kKey1)
        //        [ pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
        
    }
    
    
    
}

