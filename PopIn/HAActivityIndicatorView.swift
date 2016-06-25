//
//  HAActivityIndicatorView.swift
//  PopIn
//
//  Created by Hanny Aly on 6/22/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit


class HAActivityIndicatorView: ASDisplayNode {
    
    let activityIndicatorView: UIActivityIndicatorView
    
    override init() {
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.blackColor()
        
        super.init()
    }
    
    override func didLoad() {
        super.didLoad()
        
        view.addSubview(activityIndicatorView)
        
    }
    
    
    override func layout() {
        super.layout()
        
        activityIndicatorView.frame = view.bounds

//        activityIndicatorView.sizeToFit()
//        let refreshRect = activityIndicatorView.frame
//        
//        //        refreshRect.origin = CGPointMake((boundSize.width - activityIndicatorView.frame.size.width)/2.0, (boundSize.height - activityIndicatorView.frame.size.height) / 2.0)
//        
//        activityIndicatorView.frame = refreshRect
//        
//        activityIndicatorView.center = view.center
    }
    

}
    