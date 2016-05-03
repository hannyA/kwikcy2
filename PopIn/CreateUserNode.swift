//
//  CreateUser.swift
//  PopIn
//
//  Created by Hanny Aly on 5/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CreateUserNode: ASDisplayNode {

    
    let kRedBackground: CGFloat   = 1.0
    let kGreenBackground: CGFloat = 0.65
    let kBlueBackground: CGFloat  = 0.65
    let kAlphaBackground: CGFloat = 0.5

    
    let userPhotoButton: ASButtonNode
    let addPhotoTitle: ASTextNode
    
    
//    let titleLabel: ASTextNode
    let usernameTextNode: ASEditableTextNode
    let nextButton: HAPaddedButton
    
    
    override init() {
        
        userPhotoButton = ASButtonNode()
        addPhotoTitle = ASTextNode()
        
//        titleLabel = ASTextNode()
        usernameTextNode = ASEditableTextNode()
        nextButton = HAPaddedButton()
        
        super.init()
        
        
        
        
        setup()
        
        
        userPhotoButton.borderColor = UIColor.blackColor().CGColor
        addPhotoTitle.borderColor = UIColor.blackColor().CGColor
        usernameTextNode.borderColor = UIColor.blackColor().CGColor
        nextButton.borderColor = UIColor.blackColor().CGColor
        
        
        

        userPhotoButton.borderWidth = 2
        addPhotoTitle.borderWidth = 2
        usernameTextNode.borderWidth = 2
        nextButton.borderWidth = 2
        
        
        
        
//        addSubnode(titleLabel)
        addSubnode(userPhotoButton)
        addSubnode(addPhotoTitle)
        addSubnode(usernameTextNode)
        addSubnode(nextButton)
    }
    
    
    func setup() {
        
        // Setup Add Photo Button
        
        userPhotoButton.imageNode.image = UIImage(named: "mad-men-1")
        userPhotoButton.imageNode.contentMode = .ScaleAspectFit
        userPhotoButton.flexGrow = true
        //        addUserPhotoButton.setImage(UIImage(named: "mad-men-1"), forState: .Normal)
        //        addUserPhotoButton.setBackgroundImage(UIImage(named: "mad-men-1"), forState: .Normal)
        userPhotoButton.addTarget(self, action: #selector(selectPhoto), forControlEvents: .TouchUpInside)
        
        //        userPhotoButton.titleNode.attributedString = signinAttributedString(false)
        //        addUserPhotoButton.placeholderImage() = UIImage(named: "mad-men-1")
        
        
        
        
        // Setup "Add a Photo" String
        
        let stringAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 28)!]
        addPhotoTitle.attributedString = NSAttributedString(string: "Add a photo",
                                                            attributes: stringAttributes)
        
        
        
        // Setup username Text Field
        
        usernameTextNode.attributedPlaceholderText = NSAttributedString(string: "Select username", attributes: typingAttributesForStringType(placeHolder: true))
        
        usernameTextNode.typingAttributes = typingAttributesForStringType(placeHolder: false)
        usernameTextNode.backgroundColor = backgroundBorderColor()
        
        usernameTextNode.returnKeyType = .Done
        
        
        usernameTextNode.cornerRadius = 5
        usernameTextNode.borderColor = backgroundBorderColor().CGColor
        usernameTextNode.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        // usernameTextNode.alignSelf = .Center
//        usernameTextNode.flexGrow = true

//        usernameTextNode.bou
        
        setupNextButton()
        
//        nextButton.flexGrow = true

    }
    
    
    func setupNextButton() {
        
        nextButton.cornerRadius = 7
        nextButton.borderWidth = 3
        
        enableNextButton(false)
    }
    
    func backgroundBorderColor() -> UIColor {
        return UIColor(red: kRedBackground, green: kGreenBackground, blue: kBlueBackground, alpha: kAlphaBackground)
    }
    
    func enableNextButton(enabled: Bool) {
        
        let color: UIColor
        if enabled {
            color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        } else {
            color = UIColor(red: kRedBackground, green: kGreenBackground, blue: kBlueBackground, alpha: kAlphaBackground)
        }
        
        
        nextButton.borderColor = color.CGColor
        let stringAttributes = [NSForegroundColorAttributeName: color,
                              NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 22)!]
        nextButton.titleNode.attributedString = NSAttributedString(string: "Next", attributes: stringAttributes)

    }
    
    
    
    
    func doneButtonCanBeSelected( selected: Bool) {
        
        
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        userPhotoButton.flexGrow = true
        addPhotoTitle.flexGrow = true
        usernameTextNode.flexGrow = true
        nextButton.flexGrow = true
        
        
        //Top Title
        let kInsetTitleTop: CGFloat = 100.0
        let kInsetTitleBottom: CGFloat = 20.0
        let kInsetTitleSides: CGFloat = 25.0
        
        
        // Photo image
        
        let userPhotoRatio = ASRatioLayoutSpec(ratio: 0.3, child: userPhotoButton)

        
        let addPhotoVerticalStack = ASStackLayoutSpec(direction: .Vertical,
                                                    spacing: 20,
                                                    justifyContent: .SpaceBetween,
                                                    alignItems: .Center,
                                                    children: [userPhotoRatio, addPhotoTitle])
        
        
        let textInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides)
        
        
        
        let verticalAddPhotoWrapper = ASInsetLayoutSpec(insets: textInsets, child: addPhotoVerticalStack)
        
        
        
        
    
        
        //Bottom half
        
        let kInsetLowerTop: CGFloat = 10.0
        let kInsetLowerBottom: CGFloat = 240.0
        let kInsetLowerSides: CGFloat = 40.0
        
        
        let bottomInsets = UIEdgeInsetsMake(kInsetLowerTop, kInsetLowerSides, kInsetLowerBottom, kInsetLowerSides)
        
        
        
        //User selects username box

//        let usernameTextWrapper = ASInsetLayoutSpec(insets: textInsets, child: usernameTextNode)
//        usernameTextWrapper.flexGrow = true
        
        nextButton.titleNode.alignSelf = .Center
        let nextButtonStack = ASStackLayoutSpec(direction: .Horizontal,
                                                    spacing: 0,
                                                    justifyContent: .Center,
                                                    alignItems: .Center,
                                                    children: [ nextButton])
//        nextButtonStack.flexGrow = true
        
//        nextButton.alignSelf = .Center
        
//        nextButton.titleNode.alignSelf = .Center
//        nextButton.titleNode.flexGrow = true
        
        let verticalLowerHalfStack = ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 20,
                                           justifyContent: .SpaceAround,
                                           alignItems: .Stretch,
                                           children: [usernameTextNode, nextButtonStack])
//        verticalButtonStack.flexGrow = true
        
        
        let verticalLowerHalfWrapper = ASInsetLayoutSpec(insets: bottomInsets, child: verticalLowerHalfStack)

        verticalLowerHalfWrapper.flexGrow = true
        
        
        
        let verticalSpacer = ASLayoutSpec()
        verticalSpacer.flexGrow = true

        
        // Add them all up
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 0,
                                           justifyContent: .Center,
                                           alignItems: .Center,
                                           children: [ verticalAddPhotoWrapper, verticalLowerHalfWrapper])
        return fullStack
    }
    
    
    
    
    func selectPhoto() {
        
        print("select photo pressed")
        dismissAllObjects()
    }
    
    
    
    
    
    // MARK: helper methods
    
    
    
    
    
    func typingAttributesForStringType(placeHolder placeHolder: Bool) -> [String : AnyObject] {
        
        
        if placeHolder {
            let color = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
            return [NSForegroundColorAttributeName: color,
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!]
        } else {
            let color = UIColor.whiteColor()

            return [NSForegroundColorAttributeName: color,
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 26)!]
        }
    }

    
    
    func usernamePlaceHolderAttributedString() -> NSAttributedString {
        
        
        let  multipleAttributes = [
                NSForegroundColorAttributeName: UIColor(
                    red: kRedBackground,
                    green: kGreenBackground,
                    blue: kBlueBackground,
                    alpha: kAlphaBackground),
                NSFontAttributeName: UIFont.systemFontOfSize(20)]
    
        return NSAttributedString(string: "Select username", attributes: multipleAttributes)
    }
    
    
    
    
    
//    func signinAttributedString(selected: Bool) -> NSAttributedString {
//        
//        let multipleAttributes: [ String: AnyObject]
//        if selected {
//            multipleAttributes = [
//                NSForegroundColorAttributeName: UIColor.blackColor(),
//                //            NSBackgroundColorAttributeName: UIColor.darkBlueColor(),
//                // NSFontAttributeName: UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//                NSFontAttributeName: UIFont.systemFontOfSize(30)]
//            
//        } else {
//            multipleAttributes = [
//                NSForegroundColorAttributeName: UIColor.whiteColor(),
//                //            NSBackgroundColorAttributeName: UIColor.darkBlueColor(),
//                // NSFontAttributeName: UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//                NSFontAttributeName: UIFont.systemFontOfSize(30)]
//            
//        }
//        
//        let attrString = NSAttributedString(string: "Front Row", attributes: multipleAttributes)
//        
//        return attrString
//    }
    
    
    
    func dismissAllObjects() {
        
        print("dismiss all objects")
        usernameTextNode.resignFirstResponder()
    }
    
    
    
}