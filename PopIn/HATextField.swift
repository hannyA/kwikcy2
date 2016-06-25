//
//  HATextField.swift
//  PopIn
//
//  Created by Hanny Aly on 6/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



class HATextField: ASDisplayNode {
    
    let textField: UITextField
    
    let leftPadding:CGFloat = 15
    let leftPaddingSet: Bool
    
    init(shouldSetLeftPadding padding:Bool) {
        
        leftPaddingSet = padding
        textField = UITextField()
        textField.borderStyle = .None
        textField.backgroundColor = UIColor.whiteColor()
        textField.textAlignment = .Left
        textField.placeholder = "Title"
        textField.textColor = UIColor.blackColor()

        textField.returnKeyType = .Done
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .Sentences
        textField.clearButtonMode = .WhileEditing

        
        super.init()
    }
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(textField)
    }
    
    override func layout() {
        super.layout()
//        print("HATextField didLoad")
//        print("HATextField textFieldNode.textField.frame \(textField.frame)")
        
        textField.frame = view.bounds
//        print("HATextField layout")
//        print("HATextField textField.frame \(textField.frame)")
        
        if leftPaddingSet {
            // adjust place holder text
            let paddingView = UIView(frame: CGRectMake(0, 0, leftPadding, textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .Always
        }

        
    }
    
//    override func layoutDidFinish() {
//        super.layoutDidFinish()
//        print("HATextField layoutDidFinish")
//        print("HATextField \(textField.frame)")
//    }
//    override func displayDidFinish() {
//        super.displayDidFinish()
//        print("HATextField displayDidFinish")
//        print("HATextField \(textField.frame)")
//    }
}

    