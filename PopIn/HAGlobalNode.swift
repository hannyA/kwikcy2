//
//  HAGlobalNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit


enum TextType {
    case BlackLabel
    case WhiteLabel
    case LightGrayLabel
    case DarkGrayLabel
}

class HAGlobalNode {
    
    
    // Return default Textnode with layered backing
    class func createLayerBackedTextNodeWithString(attributedString: NSAttributedString) -> ASTextNode {
        let textNode = ASTextNode()
        textNode.layerBacked = true
        textNode.attributedText = attributedString
        return textNode
    }
    
    
    // Return default Textnode with layered backing
    class func createBorderedButtonNodeWithString(attributedString: NSAttributedString) -> ASButtonNode {
        let buttonNode = ASButtonNode()
        buttonNode.setAttributedTitle(attributedString, forState: .Normal)
        buttonNode.borderColor = UIColor.blackColor().CGColor
        buttonNode.borderWidth = 2.0
        buttonNode.cornerRadius = 4.0
//        buttonNode.contentEdgeInsets = UIEdgeInsetsMake(10, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        return buttonNode
    }
    // Return default Textnode with layered backing
    class func createButtonNodeWithString(attributedString: NSAttributedString) -> ASButtonNode {
        let buttonNode = ASButtonNode()
        buttonNode.setAttributedTitle(attributedString, forState: .Normal)
//        buttonNode.borderColor = UIColor.blackColor().CGColor
//        buttonNode.borderWidth = 2.0
        return buttonNode
    }
    
    
    
    
    class func titlesAttributedString(string: String, color: UIColor, textSize size: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: color,
                                    NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
    }
    
    
    class func attributedString(string: String, textSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
    }


//    enum TextType {
//        case BlackLabel
//        case WhiteLabel
//        case LightGrayLabel
//        case DarkGrayLabel
//    }
    
    class func attributedString(string: String, font size: CGFloat, text type: TextType) -> NSAttributedString {
        
        switch type {
        case .BlackLabel:
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
        case .WhiteLabel:
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
            
        case .DarkGrayLabel:
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
        case .LightGrayLabel:
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
        }
    }
    
    
//    class func labelAttributedString(string: String, withFontSize size: CGFloat) -> NSAttributedString {
//        return NSAttributedString(string: string, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
//    }
//    
//    class func textAttributedString(string: String, withFontSize size: CGFloat) -> NSAttributedString {
//        return NSAttributedString(string: string, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
//    }
    
    

    
    
        
    class func textColors(attributeColor: AttributeColor) -> (normal: UIColor, highlighted: UIColor, selected: UIColor, disabled: UIColor) {
        
        switch attributeColor {
        case .BlackTextLightBackground:
            return (UIColor.blackColor(), UIColor.darkBlueColor()!, UIColor.darkBlueColor()!, UIColor.lightGrayColor())
        case .WhiteTextDarkBackground:
            return (UIColor.whiteColor(), UIColor.grayColor(), UIColor.grayColor(), UIColor.blackColor())
        case .LightGrayTextDarkBackground:
            return (UIColor.lightGrayColor(), UIColor.darkGrayColor(), UIColor.darkGrayColor(), UIColor.blackColor())
        }
    }
    
    
    class func createBasicButtonNode() -> ASButtonNode {
        
        let button = ASButtonNode()
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.flexGrow = true
        return button
    }
    
    
    class func setButton(button:ASButtonNode, string: String, textSize: CGFloat, attributeType: AttributeColor) {
        
        let colorScheme = textColors(attributeType)
        
        button.setAttributedTitle(NSAttributedString(string: string,
            attributes: [NSForegroundColorAttributeName: colorScheme.normal,
                NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!]), forState: .Normal)

        button.setAttributedTitle(NSAttributedString(string: string,
            attributes: [NSForegroundColorAttributeName: colorScheme.highlighted,
                NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!]), forState: .Highlighted)

        button.setAttributedTitle(NSAttributedString(string: string,
            attributes: [NSForegroundColorAttributeName: colorScheme.selected,
                NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!]), forState: .Selected)

        button.setAttributedTitle(NSAttributedString(string: string,
            attributes: [NSForegroundColorAttributeName: colorScheme.disabled,
                NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!]), forState: .Disabled)
    }
    
    
    
    
    class func attributedString(string: String, textSize: CGFloat, forState state: UIControlState) -> NSAttributedString {
        
        switch state {
        case UIControlState.Normal:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
        case UIControlState.Highlighted:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
            
        case UIControlState.Selected:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
        case UIControlState.Disabled:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.grayColor(),
                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
        default:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: textSize)!])
        }
    }
    
    

    
    class func createButtonWithAllStatesSetWithText(text: String) -> ASButtonNode {
        
        let button = ASButtonNode()
        button.backgroundColor = UIColor.whiteColor()
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        button.flexGrow = true
        
        button.setAttributedTitle(attributedString(text, textSize:kTextSizeXS, forState:.Normal), forState: .Normal)
        button.setAttributedTitle(attributedString(text, textSize:kTextSizeXS, forState:.Disabled), forState: .Disabled)
        button.setAttributedTitle(attributedString(text, textSize:kTextSizeXS, forState:.Highlighted), forState: .Highlighted)
        button.setAttributedTitle(attributedString(text, textSize:kTextSizeXS, forState:.Selected), forState: .Selected)
        return button
    }
    
    
    class func createWhiteBorderedButtonNodeWithString(string: String) -> ASButtonNode {
        let buttonNode = ASButtonNode()
        buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.whiteColor(), textSize: kTextSizeRegular), forState: .Normal)
        buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.lightBlueColor(), textSize: kTextSizeRegular), forState: .Highlighted)
        buttonNode.setAttributedTitle(HAGlobal.titlesAttributedString(string, color: UIColor.lightBlueColor(), textSize: kTextSizeRegular), forState: .Selected)
        
        buttonNode.backgroundColor  = UIColor.clearColor()
        buttonNode.borderColor = UIColor.whiteColor().CGColor
        buttonNode.borderWidth =  1.0
        buttonNode.cornerRadius = 4.0
        return buttonNode
    }
    
    
    
}