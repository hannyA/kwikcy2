//
//  HASwitchNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HASwitchNode: ASControlNode {
    
    
    let switchView: UISwitch
    
    override init() {
        switchView = UISwitch()
        switchView.onTintColor = UIColor.greenColor()
        switchView.backgroundColor = UIColor.blackColor()
    
        super.init()
        
        backgroundColor = UIColor.redColor()
    }
    
    
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(switchView)
    }
    
    override func layout() {
        super.layout()
        switchView.frame = view.bounds
        
//        textField.frame = view.bounds
//        if leftPaddingSet {
//            // adjust place holder text
//            let paddingView = UIView(frame: CGRectMake(0, 0, leftPadding, textField.frame.height))
//            textField.leftView = paddingView
//            textField.leftViewMode = .Always
//        }
        
    }
    
}

