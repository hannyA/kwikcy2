//
//  FocusAnimation.swift
//  PopIn
//
//  Created by Hanny Aly on 8/11/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import pop

class FocusAnimationView: UIView { //, POPAnimationDelegate {
    
    
    var circle: CALayer
    
    override init(frame: CGRect) {
        
        circle = FocusAnimationView.createLayerWith(size: frame.size, color: UIColor.whiteColor())
        super.init(frame: frame)
        hidden = true
        
//        circle!.frame = CGRect(x: (layer.bounds.size.width - frame.size.width) / 2,
//                              y: (layer.bounds.size.height - frame.size.height) / 2,
//                              width: frame.size.width,
//                              height: frame.size.height);
        layer.addSublayer(circle)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createLayerWith(size size: CGSize, color: UIColor) -> CALayer {
        
        let path = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2),
                              radius: size.width / 2,
                              startAngle: 0,
                              endAngle: CGFloat(2 * M_PI),
                              clockwise: false)
        
        
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = color.CGColor
        layer.lineWidth = 1.0
        layer.backgroundColor = UIColor.clearColor().CGColor
//        layer.frame = CGRectMake(0, 0, size.width, size.height)
        return layer
    }

    
//
//
//    func pop_animationDidStart(anim: POPAnimation!) {
//        print("pop_animationDidStart")
//    }
//
//    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
//        print("pop_animationDidStop")
//        hidden = true
//        pop_removeAllAnimations()
//    }
//    
//    func animate() {
//        
//        hidden = false
//        
//        pop_removeAllAnimations()
//        
//////        //Scale small to large
////        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerSize)
//////        scaleAnimation.fromValue = NSValue(CGSize:CGSizeMake(0, 0))
////        scaleAnimation.toValue   = NSValue(CGSize:CGSizeMake(90, 90))
////        scaleAnimation.duration = 2.0
////        scaleAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
////        scaleAnimation.name = "scaleAnimation"
////        scaleAnimation.delegate = self
////        circle.pop_addAnimation(scaleAnimation,  forKey: "scale")
//        
//        
////        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBounds)
////        scaleAnimation.toValue = NSValue(CGRect: CGRectMake(0, 0, 90, 90))
////        
////        scaleAnimation.duration = 2.0
////        scaleAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
////        scaleAnimation.name = "scaleAnimation"
////        scaleAnimation.delegate = self
////        pop_addAnimation(scaleAnimation,  forKey: "scale")
//        
////        
////        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
////        scaleAnimation.toValue = 1.0
////        scaleAnimation.fromValue = 0.0
////        scaleAnimation.duration = 2.0
////        scaleAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
////        scaleAnimation.name = "scaleAnimation"
////        scaleAnimation.delegate = self
////        pop_addAnimation(scaleAnimation,  forKey: "scale")
////        
//        
////        
////        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewBounds)
////        scaleAnimation.toValue = NSValue(CGRect: CGRectMake(0, 0, 90, 90))
//////        scaleAnimation.fromValue = NSValue(CGRect: CGRectMake(0, 0, 0, 0))
////        scaleAnimation.duration = 2.0
////        scaleAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
////        scaleAnimation.name = "scaleAnimation"
////        scaleAnimation.delegate = self
////        pop_addAnimation(scaleAnimation,  forKey: "scale")
////        
////
//        
//        
//        
//        
//        
//        
//        
//        //Change opacity from clear to white
////        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
////        opacityAnimation.fromValue = 0.0
////        opacityAnimation.toValue   = 1.0
////        opacityAnimation.duration = 1.0
////        opacityAnimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
////        opacityAnimation.name = "opacityAnimation"
////        opacityAnimation.delegate = self
////        circle.pop_addAnimation(opacityAnimation, forKey: "opacity")
//    }
}

