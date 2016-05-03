//
//  WindowWithStatusBarUnderlay.swift
//  PopIn
//
//  Created by Hanny Aly on 4/25/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class WindowWithStatusBarUnderlay: UIWindow {
    
    var _statusBarOpaqueUnderlayView: UIView
    
    override init(frame: CGRect) {

        _statusBarOpaqueUnderlayView = UIView()

        super.init(frame: frame)
        
        _statusBarOpaqueUnderlayView.backgroundColor = UIColor.blueColor()
        
        addSubview(_statusBarOpaqueUnderlayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        bringSubviewToFront(_statusBarOpaqueUnderlayView)
        
        var statusBarFrame: CGRect = CGRectZero
        statusBarFrame.size.width = UIScreen.mainScreen().bounds.size.width
        statusBarFrame.size.height = UIApplication.sharedApplication().statusBarFrame.size.height
        _statusBarOpaqueUnderlayView.frame = statusBarFrame
    }
    
}