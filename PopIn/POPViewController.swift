//
//  POPViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import pop


class POPViewController: UIViewController, POPAnimatorDelegate {

    
    let kKey1 = "hannyiable"
    
    
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
        
        
        boxView.frame = CGRectMake(0, 350, thirdScreenWidth, 10)
        boxView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        view.addSubview(boxView)
        
        
        let boxHeight:CGFloat = 80
        firstBoxButton.frame = CGRectMake(x1, 120, thirdScreenWidth, boxHeight)
        firstBoxButton.addTarget(self, action: #selector(boxButtonPressed), forControlEvents: .TouchUpInside)
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
    
    
    
    
    func toCenterPosition(buttonTag: Int) -> CGFloat{
        
        let width = view.frame.width/kNumberOfButtons

        let xPosition = ( CGFloat(buttonTag - 1) * width) + (width/2)
        return xPosition
    }
    
    
    
    
    func boxButtonPressed(button: UIButton) {
        
        print("Box button pressed")
        
        // POPBasicAnimation
        let basicanimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        basicanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        basicanimation.toValue = toCenterPosition(button.tag)

        

        
//        // POPDecayAnimation
//        let basicanimation = POPDecayAnimation()
//        basicanimation.velocity = 433 //change of value units per second
//        basicanimation.deceleration = 0.833 //range of 0 to 1
//        
//        // Size - kPOPViewBounds
//        basicanimation.property = POPAnimatableProperty.propertyWithName(kPOPLayerPositionX) as! POPAnimatableProperty
//        basicanimation.toValue = toCenterPosition(button.tag)
        
        

        
        basicanimation.name = kKey1
        basicanimation.delegate = self
    
        boxView.pop_addAnimation(basicanimation, forKey: kKey1)
//        [ pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];

    }
    
    

}
