//
//  NVActivityIndicatorBallClipRotate.swift
//  NVActivityIndicatorViewDemo
//
//  Created by Nguyen Vinh on 7/23/15.
//  Copyright (c) 2015 Nguyen Vinh. All rights reserved.
//

import UIKit
 
class NVActivityIndicatorAnimationBallClipRotate: NVActivityIndicatorAnimationDelegate {
    
    func setUpAnimationInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 0.75
        
        //    Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.6, 1]
        
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.keyTimes = scaleAnimation.keyTimes
        rotateAnimation.values = [0, M_PI, 2 * M_PI]
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, rotateAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.removedOnCompletion = false
        
        // Draw circle
        let circle = NVActivityIndicatorShape.RingThirdFour.createLayerWith(size: CGSize(width: size.width, height: size.height), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
            y: (layer.bounds.size.height - size.height) / 2,
            width: size.width,
            height: size.height)
        
        circle.frame = frame
        circle.addAnimation(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}


class NVActivityIndicatorAnimationSnapper: NVActivityIndicatorAnimationDelegate {
    
    func setUpAnimationInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 0.75
        
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.values = [0, M_PI, 2 * M_PI]
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = HUGE
        rotateAnimation.removedOnCompletion = false

        // Draw circle
        let circle = NVActivityIndicatorShape.RingThirdFour.createLayerWith(size: CGSize(width: size.width, height: size.height), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                           y: (layer.bounds.size.height - size.height) / 2,
                           width: size.width,
                           height: size.height)
        
        circle.frame = frame
        circle.addAnimation(rotateAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }
}



class NVActivityIndicatorAnimationSnapper2: NVActivityIndicatorAnimationDelegate {
    
    func setUpAnimationInLayer(layer: CALayer, size: CGSize, color: UIColor) {
        let bigCircleSize: CGFloat = size.width
        let smallCircleSize: CGFloat = size.width / 2
        let longDuration: CFTimeInterval = 0.75
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleOf(shape: .RingTwoHalfHorizontal,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: bigCircleSize,
                 color: color, reverse: false)
        circleOf(shape: .RingTwoHalfVertical,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: smallCircleSize,
                 color: color, reverse: true)
    }
    
    func createAnimationIn(duration duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, reverse: Bool) -> CAAnimation {
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.values = [0, M_PI, 2 * M_PI]
        
        rotateAnimation.timingFunction = timingFunction
        if (!reverse) {
            rotateAnimation.values = [0, M_PI, 2 * M_PI]
        } else {
            rotateAnimation.values = [0, -M_PI, -2 * M_PI]
        }
        rotateAnimation.duration = duration
        
        
        rotateAnimation.repeatCount = HUGE
        rotateAnimation.removedOnCompletion = false

        return rotateAnimation
    }
    
    func circleOf(shape shape: NVActivityIndicatorShape, duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, layer: CALayer, size: CGFloat, color: UIColor, reverse: Bool) {
        let circle = shape.createLayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size) / 2,
                           y: (layer.bounds.size.height - size) / 2,
                           width: size,
                           height: size)
        let animation = createAnimationIn(duration: duration, timingFunction: timingFunction, reverse: reverse)
        
        circle.frame = frame
        circle.addAnimation(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}

