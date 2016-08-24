//
//  HAGlobal.swift
//  PopIn
//
//  Created by Hanny Aly on 6/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



class HAGlobal {
    
//    class func titlesAttributedString(string: String, forState state: UIControlState) -> NSAttributedString {
//        
//        switch state {
//        case UIControlState.Normal:
//            let lightGray = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
//            return NSAttributedString(string: string,
//                                      attributes: [NSForegroundColorAttributeName: lightGray,
//                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeRegular)!])
//        case UIControlState.Highlighted:
//            return NSAttributedString(string: string,
//                                      attributes: [NSForegroundColorAttributeName: UIColor.blueColor(),
//                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeRegular)!])
//            
//        case UIControlState.Selected:
//            return NSAttributedString(string: string,
//                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
//                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeRegular)!])
//        default:
//            return NSAttributedString(string: string,
//                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
//                                        NSFontAttributeName: UIFont(name: kAppMainFont, size: kTextSizeRegular)!])
//        }
//    }
    
    
    
    class func titlesAttributedString(string: String, color: UIColor, textSize size: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: string,
                                  attributes: [NSForegroundColorAttributeName: color,
                                               NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
    }
    
    
    class func centerTitleAttributedString(string: String, color: UIColor, textSize size: CGFloat) -> NSAttributedString {
        
        let paragraph = NSMutableParagraphStyle()
//        paragraph.maximumLineHeight = kTextSizeRegular
        paragraph.alignment = .Center

        
        return NSAttributedString(string: string,
                                  attributes:[NSForegroundColorAttributeName: color,
                                              NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!,
                                  NSParagraphStyleAttributeName :paragraph])
    }
    
    
    
    
    
    class func boldenFirstWord(firstWord: String, withRestOfAttributedString string: String?, withColor color: UIColor, andTextSize size: CGFloat) -> NSMutableAttributedString {
        

        
//        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
//        let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
//        let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
//        
//        
//        let boldAttributes = [NSFontAttributeName : boldFont]
//        
//        let a = UIFont(
        
        
        
        let boldFirstWord =  NSMutableAttributedString(string: firstWord,
                                                       attributes: [NSForegroundColorAttributeName: color,
                                                                    NSFontAttributeName: UIFont(name: kAppMainFontBold,
                                                                        size: size)!])
        if let theRest = string {
            
            let restOfString = NSMutableAttributedString(string: theRest,
                                                         attributes: [NSForegroundColorAttributeName: color,
                                                            NSFontAttributeName: UIFont(name: kAppMainFont,
                                                                size: size)!])
            
            boldFirstWord.appendAttributedString(restOfString)
        }
        
        return boldFirstWord
    }
    
    
    
    class func largeCenterDotWithColor(color: UIColor, andSize size: CGFloat) -> NSMutableAttributedString {
        
        
        let dotString = NSMutableAttributedString(string: " · ",
                                              attributes: [NSForegroundColorAttributeName: color,
                                                NSFontAttributeName: UIFont(name: kAppMainFont, size: size)!])
        
        return dotString
        
    }
}





