//
//  CreateUser.swift
//  PopIn
//
//  Created by Hanny Aly on 5/2/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CreateUserNode: ASDisplayNode, ASEditableTextNodeDelegate {

    
    enum StringAttributeType {
        case AddPhotoTitle
        case BackgroundColor
        case UsernameText
        case UsernameTextWithPlaceHolder
        case UsernameTextBackground
        case DisabledNextButton
        case EnabledNextButton
    }
    
    
    let kRedBackground: CGFloat   = 1.0
    let kGreenBackground: CGFloat = 0.65
    let kBlueBackground: CGFloat  = 0.65
    let kAlphaBackground: CGFloat = 0.5

    let kbackgroundColor = UIColor.whiteColor()
    
    
    
    
    
    
    let userPhotoButton: ASButtonNode
    let usernameTextNode: ASEditableTextNode
    let nextButton: HAPaddedButton
    
//    let photoImageNode: ASImageNode
    
    override init() {
        userPhotoButton = ASButtonNode()
        usernameTextNode = ASEditableTextNode()
        nextButton = HAPaddedButton()
        
        super.init()
                
        setup()
        
        
        /* For testing purposes */
//        userPhotoButton.borderColor = UIColor.blackColor().CGColor
//        usernameTextNode.borderColor = UIColor.blackColor().CGColor
//        nextButton.borderColor = UIColor.blackColor().CGColor
//        userPhotoButton.borderWidth = 2
//        usernameTextNode.borderWidth = 2
//        nextButton.borderWidth = 2
        
        
        addSubnode(userPhotoButton)
        addSubnode(usernameTextNode)
        addSubnode(nextButton)
    }
    
    
    
    
//    override func didLoad() {
//        super.didLoad()
//
//        print(userPhotoButton.view.frame)
//        
//        //        let diameter = min(frame.size.height, frame.size.width)
//        //        //        let diameter = min(bounds.size.height, bounds.size.width)
//        //        view.frame = CGRectMake(0, 0, diameter, diameter)
//        //        view.clipsToBounds = true
//        //        view.layer.cornerRadius = 50
//        //        view.layer.borderColor = UIColor.blueColor().CGColor
//        //        view.layer.borderWidth = 2
//        //
//        
//    }

    
    
    func setup() {
        
        userPhotoButton.flexGrow = true
        usernameTextNode.flexGrow = true
        nextButton.flexGrow = true

        backgroundColor = colorForType(.BackgroundColor)

        // Setup Add Photo Button

        //        userPhotoButton.backgroundImageNode.image = UIImage(named: "mad-men-1")
//        userPhotoButton.imageNode.image  = UIImage(named: "circle")
//        userPhotoButton.imageNode.contentMode = .ScaleAspectFit
        
        // Setup button image
        userPhotoButton.setBackgroundImage(UIImage(named: "circle"), forState: .Normal)
//        userPhotoButton.setBackgroundImage(UIImage(named: "circle"), forState: .Selected)
        
        
        userPhotoButton.backgroundImageNode.contentMode = .ScaleAspectFit

        // Set button title
        let photoAttributedTitle = NSAttributedString(string: "PHOTO",
                                                      attributes: stringAttributesForType(.AddPhotoTitle) )
        userPhotoButton.setAttributedTitle(photoAttributedTitle, forState: .Normal)
        userPhotoButton.titleNode.contentMode = .ScaleAspectFit
        
        
        
        
//        photoButton.backgroundImageNode.contentMode = .ScaleAspectFit
//        photoButton.setBackgroundImage(_image, forState: .Normal)
//        photoButton.titleNode.attributedString = nil
        
        
        
    
        
        userPhotoButton.flexGrow = true
        
        
//        userPhotoButton.imageNode.image = UIImage(named: "mad-men-1")
//        userPhotoButton.imageNode.contentMode = .ScaleAspectFit
   
        
        
    
        
        
        // Setup username Text Field
        
        usernameTextNode.attributedPlaceholderText = NSAttributedString(string: "SELECT USERNAME",
                                                                        attributes: stringAttributesForType(.UsernameTextWithPlaceHolder))
        usernameTextNode.typingAttributes = stringAttributesForType(.UsernameText)
        
        usernameTextNode.backgroundColor = userTextFieldBackground()
        
        usernameTextNode.returnKeyType = .Done
        
        usernameTextNode.textView.autocorrectionType = .No
        usernameTextNode.textView.autocapitalizationType = .None
        
        usernameTextNode.cornerRadius = 5
        usernameTextNode.borderColor = colorForType(.BackgroundColor).CGColor
        usernameTextNode.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        // usernameTextNode.alignSelf = .Center
//        usernameTextNode.flexGrow = true

        
        // NextButton
        
        nextButton.cornerRadius = 7
        nextButton.borderWidth = 3
        setupNextButton()
    }
    
    
    func setupNextButton() {
        attributesForNextButtonEnabled(false)
        
        
        let enabledButton = NSAttributedString(string: "NEXT",
                                               attributes: stringAttributesForType(.EnabledNextButton))
        
        let disabledButton = NSAttributedString(string: "NEXT",
                                                attributes: stringAttributesForType(.DisabledNextButton))
        
        
        nextButton.setAttributedTitle(disabledButton, forState: .Disabled)
        nextButton.setAttributedTitle(enabledButton, forState: .Normal)

        nextButton.enabled = false

    }
    
    func attributesForNextButtonEnabled(enabled: Bool) {
        
        if enabled {
            let color: UIColor = colorForType(.EnabledNextButton)
            nextButton.borderColor = color.CGColor
            nextButton.enabled = true
            print("Next button should be enabled")
        } else {
            let color: UIColor = colorForType(.DisabledNextButton)
            nextButton.borderColor = color.CGColor
            nextButton.enabled = false

        }
    }

    
    
    
    func userTextFieldBackground() -> UIColor {
        return colorForType(.UsernameTextBackground)
    }
    
//    func colorForUsernameTextFieldType(type: TextFieldType) -> UIColor {
//        
//        switch type {
//        case .Text:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
    func colorForType(type: StringAttributeType) -> UIColor {
        
        switch type {
        case .BackgroundColor:
            return UIColor.blackColor()
//            return UIColor(red: kRedBackground, green: kGreenBackground, blue: kBlueBackground, alpha: kAlphaBackground)
        case .AddPhotoTitle:
            return UIColor.whiteColor()
        case .UsernameText:
            return UIColor.blackColor()
        case .UsernameTextWithPlaceHolder:
            return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
            // return UIColor(red: kRedBackground, green: kGreenBackground, blue: kBlueBackground, alpha: kAlphaBackground)
        case .UsernameTextBackground:
            return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
        case .DisabledNextButton:
            return UIColor(red: kRedBackground, green: kGreenBackground, blue: kBlueBackground, alpha: kAlphaBackground)
        case .EnabledNextButton:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        }
    }
    
    
    func stringAttributesForType(type: StringAttributeType) -> [String: AnyObject] {
        
        switch type {
        case .AddPhotoTitle:
            return [NSForegroundColorAttributeName: colorForType(.AddPhotoTitle),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 28)!]
        case .UsernameText:
            return [NSForegroundColorAttributeName: colorForType(.UsernameText),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!]
        case .UsernameTextWithPlaceHolder:
            return [NSForegroundColorAttributeName: colorForType(.UsernameTextWithPlaceHolder),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!]
//                  NSFontAttributeName: UIFont.systemFontOfSize(20)
        case .DisabledNextButton:
            return [NSForegroundColorAttributeName: colorForType(.DisabledNextButton),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 22)!]
        case .EnabledNextButton:
            return [NSForegroundColorAttributeName: colorForType(.EnabledNextButton),
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 22)!]
        default:
            return [NSForegroundColorAttributeName: UIColor.blackColor(),
             NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 22)!]
        }
    }
    
    
    

    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
//        userPhotoButton.preferredFrameSize = CGSizeMake(100, 100);              // constrain photo frame size

        
//        userPhotoButton.preferredFrameSize  = CGSizeMake(photoDiameter, photoDiameter);     // constrain avatar image frame size

        
//        let cellWidth: CGFloat = constrainedSize.max.width/2
//        userPhotoButton.preferredFrameSize = CGSizeMake(cellWidth, cellWidth)
//        
//        userPhotoButton.preferredFrameSize = CGSizeMake(cellWidth, cellWidth)
//        userPhotoButton.imageNode.preferredFrameSize = CGSizeMake(cellWidth, cellWidth)


//        userPhotoButton.borderColor = UIColor.whiteColor().CGColor
//        userPhotoButton.borderWidth = 3
        
        //Top Title
        let kInsetTitleTop: CGFloat = 50.0
        let kInsetTitleBottom: CGFloat = 0.0
        let kInsetTitleSides: CGFloat = 0
        
        
        // Photo image
        
        let userPhotoRatio = ASRatioLayoutSpec(ratio: 0.6, child: userPhotoButton)
        
        let photoInsets = UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides)
        
        let photoInsetWrapper = ASInsetLayoutSpec(insets: photoInsets, child: userPhotoRatio)
        
        
        
        
    
        
        //Bottom half
        
        let kInsetLowerTop: CGFloat = 10.0
        let kInsetLowerBottom: CGFloat = 230.0
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
                                           children: [ photoInsetWrapper, verticalLowerHalfWrapper])
        return fullStack
    }
    
    
    
    
    
    
    // MARK: helper methods
    
    
    
    
    
    
    
    //MARK: Action Methods

    
    func dismissAllObjects() {
        
        print("dismiss all objects")
    }
}


//extension UIImage {
//  
//    func makeCircularImageWithSize(size: CGSize) -> UIImage {
//        
//        // make a CGRect with the image's size
//        let circleRect = CGRect(origin: CGPointZero, size: size)
//        
//        // begin the image context since we're not in a drawRect:
//        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
//        
//        // create a UIBezierPath circle
//        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width/2)
//        
//        // clip to the circle
//        circle.addClip()
//        
//        // draw the image in the circleRect *AFTER* the context is clipped
//        drawInRect(circleRect)
//        
//        // create a border (for white background pictures)
//        #if StrokeRoundedImages
//            circle.lineWidth = 1;
//            UIColor.blackColor().set()
//            circle.stroke()
//        #endif
//        
//        // get an image from the image context
//        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        // end the image context since we're not in a drawRect:
//        UIGraphicsEndImageContext()
//        
//        return roundedImage
//    }
//}

extension UIBezierPath {
    
    /** Returns an image of the path drawn using a stroke */
    func strokeMyImageWithColor() -> UIImage {
        
        // get your bounds
        let bounds: CGRect = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(bounds.size.width + self.lineWidth * 2, bounds.size.width + self.lineWidth * 2), false, UIScreen.mainScreen().scale)
        
        // get reference to the graphics context
        let reference: CGContextRef = UIGraphicsGetCurrentContext()!
        
        // translate matrix so that path will be centered in bounds
        CGContextTranslateCTM(reference, self.lineWidth, self.lineWidth)
        
        let strokeColor = UIColor.whiteColor()

        let fillColor = UIColor.redColor()
      
        
        // set the color
        strokeColor.setStroke()
        fillColor.setFill()
        
        
        // draw the path
        fill()
        stroke()
        
        
        // grab an image of the context
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
}