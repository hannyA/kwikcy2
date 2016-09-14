//
//  SwiftIconExtension.swift
//  PopIn
//
//  Created by Hanny Aly on 8/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import SwiftIconFont
import AsyncDisplayKit



public extension UIImage
{
    public static func icon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat, color: UIColor) -> UIImage
    {
        let drawText = String.getIcon(from: font, code: code)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        drawText!.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height), withAttributes: [NSFontAttributeName : UIFont.icon(from: font, ofSize: size), NSForegroundColorAttributeName: color])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

public extension NSAttributedString {
    
    static func titleNodeIcon(from font: Fonts, code: String, ofSize size: CGFloat, color: UIColor) -> NSAttributedString {
        let textAttributes: [String: AnyObject] = [NSFontAttributeName: UIFont.icon(from: font, ofSize: size),
                                                   NSForegroundColorAttributeName: color]
        
        return NSAttributedString(string: String.getIcon(from: font, code: code)!,
                                  attributes: textAttributes)
    }
}

public extension ASButtonNode {

    // Titlenode
    func titleNodeIcon(from font: Fonts, code: String, ofSize size: CGFloat, color: UIColor, forState state: ASControlState){
        let textAttributes: [String: AnyObject] = [NSFontAttributeName: UIFont.icon(from: font, ofSize: size),
                                                   NSForegroundColorAttributeName: color]
        
        let attributeTitle = NSAttributedString(string: String.getIcon(from: font, code: code)!,
                                         attributes: textAttributes)
        self.setAttributedTitle(attributeTitle, forState: state)
    }

   
    
    
    
    // ImageNode Funcs
    
    func imageNodeIcon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat, color: UIColor, forState state: ASControlState) {
        self.setImage(UIImage.icon(from: font, code: code, imageSize: imageSize, ofSize: size, color: color),
                      forState: state)
    }
    
    func imageNodeIcon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat, color: UIColor) {
        self.imageNode.image = UIImage.icon(from: font, code: code, imageSize: imageSize, ofSize: size, color: color)
    }
    
    
    func backgroundImageNodeIcon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat, color: UIColor) {
        self.backgroundImageNode.image = UIImage.icon(from: font, code: code, imageSize: imageSize, ofSize: size)
    }
    
    
}


public extension ASImageNode {
    
    func icon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat) {
        self.image = UIImage.icon(from: font, code: code, imageSize: imageSize, ofSize: size)
    }
    
    func icon(from font: Fonts, code: String, imageSize: CGSize, ofSize size: CGFloat, color: UIColor) {
        self.image = UIImage.icon(from: font, code: code, imageSize: imageSize, ofSize: size, color: color)
    }
}




