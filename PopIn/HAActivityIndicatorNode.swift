//
//  HAActivityIndicatorNode.swift
//  PopIn
//
//  Created by Hanny Aly on 8/13/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class HAActivityIndicatorNode: ASDisplayNode {
    
    let activityIndicatorView: UIActivityIndicatorView


    override init() {
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.color = UIColor.blackColor()
        
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.addSubview(activityIndicatorView)
        showSpinningWheel()
    }


    override func layout() {
        super.layout()
        activityIndicatorView.center = view.center
    }

    func showSpinningWheel() {
        activityIndicatorView.startAnimating()
    }

    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
    }
}

