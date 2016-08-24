//
//  HAProfilePhoto.swift
//  PopIn
//
//  Created by Hanny Aly on 8/13/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit
import Toucan

class HAProfilePhotoCN: ASCellNode {
    
    // Variables
    let userProfile         : UserSearchModel
    let userPic             : ASImageNode
    let verificationImage   : ASImageNode
    
    init(withProfileModel profile: UserSearchModel) {
        
        userProfile = profile
        
        userPic = ASImageNode()
        userPic.placeholderColor = ASDisplayNodeDefaultPlaceholderColor()
        userPic.contentMode = .ScaleAspectFill

                
        verificationImage = ASImageNode()
        verificationImage.layerBacked = true
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)

        
        
        verificationImage.icon(from: .MaterialIcon,
                               code: "verified.user",
                               imageSize: CGSizeMake(12, 12),
                               ofSize: 12,
                               color: UIColor.flatSkyBlueColor())
        super.init()
        
        
        userProfile.avatarImageClosure = { image in
            self.setImage(image!)
        }
        
        
        if userPic.image == nil {
            if let downloadedFile = userProfile.downloadFileURL {
                if let data = NSData(contentsOfURL: downloadedFile) {
                    self.setImage(UIImage(data: data)!)
                }
            }
        }
        
        addSubnode(userPic)
        addSubnode(verificationImage)
    }
    
    override func layout() {
        super.layout()
        
        let maxWidth = calculatedSize.width * (4.0 / 5)
        
        userPic.imageModificationBlock = { (image) -> UIImage? in
            
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: maxWidth).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
    }
    
    func setImage(image: UIImage) {
        userPic.image = image
    }
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let maxWidth   = constrainedSize.max.width
        let imageWidth = maxWidth * (4.0/5)

        let edgeInset = (maxWidth - imageWidth) / 2
        
    
        userPic.preferredFrameSize = CGSizeMake(imageWidth, imageWidth)
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(4, edgeInset, edgeInset, edgeInset),
                                      child: userPic)
        return inset
        
//        let wholeStack = ASStackLayoutSpec(direction: .Vertical,
//                                           spacing: 20,
//                                           justifyContent: .SpaceBetween ,
//                                           alignItems: .Stretch ,
//                                           children: [userPic])
//        return wholeStack
    }
}
