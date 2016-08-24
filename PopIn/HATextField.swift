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
    let activityIndicatorView: UIActivityIndicatorView
    let checkMarkImageView: UIImageView
    
    let forVerificationPurposes: Bool

    
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

        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.color = UIColor.whiteColor()

        
        checkMarkImageView = UIImageView()
        
        forVerificationPurposes = false
        super.init()
    }
    

    init(shouldSetLeftPadding padding:Bool, useForVerification: Bool) {
        
        forVerificationPurposes = useForVerification
        
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
        
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.color = UIColor.whiteColor()
        
        checkMarkImageView = UIImageView()
        
        
//        checkMarkImageView.contentMode = .ScaleAspectFit
//        checkMarkImageView.backgroundColor = UIColor.greenColor()
//
//        checkMarkImageView.layer.cornerRadius = checkMarkImageView.frame.width / 2
//        checkMarkImageView.layer.masksToBounds = true
        
        super.init()
    }
    
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(textField)
        
        
        checkMarkImageView.image = UIImage.icon(from: .MaterialIcon,
                                                code: "check.circle",
                                                imageSize: CGSizeMake(30, 30),
                                                ofSize: 30,
                                                color: UIColor.flatGreenColor())

        
        if forVerificationPurposes {
            
            activityIndicatorView.stopAnimating()
            checkMarkImageView.alpha = 0.0
            view.addSubview(activityIndicatorView)
            view.addSubview(checkMarkImageView)
        }
    }
    
    override func layout() {
        super.layout()
        
        
        textField.frame = view.bounds
        
        if leftPaddingSet {
            // adjust place holder text
            let paddingView = UIView(frame: CGRectMake(0, 0, leftPadding, textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .Always
        }
        
        
        if forVerificationPurposes {
            let textFieldWidth = textField.frame.size.width
            let textFieldHeight = textField.frame.size.height
            let activityViewHeight = activityIndicatorView.frame.size.height

                var refreshRect = activityIndicatorView.frame
            refreshRect.origin = CGPointMake( textFieldWidth + 7, (textFieldHeight - activityViewHeight) / 2.0)
            
            activityIndicatorView.frame = refreshRect
            
            checkMarkImageView.frame = refreshRect
        }
    }
    
    
    func userIsTyping() {
        checkMarkImageView.alpha = 0.0
        activityIndicatorView.stopAnimating()
    }
    func userIsDoneTyping() {
        activityIndicatorView.startAnimating()
    }
    
    func userReceivedResultsForValidText(valid: Bool) {
        activityIndicatorView.stopAnimating()
        if valid {
            showCheckMarkImageForValidText()
        }
    }
    
    
    func showCheckMarkImageForValidText() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .CurveEaseOut, animations: { 
            self.checkMarkImageView.alpha = 1.0
        }, completion: nil)
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

    