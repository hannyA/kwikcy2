//
//  UserSearchTableNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/21/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class UserSearchTableCN: ASCellNode {
    
    
    let userModel: UserSearchModel
    
    let userAvatarImageView: ASImageNode
    let userNameLabel: ASTextNode
    let userRealnameLabel: ASTextNode
//    let friendsButton: ASButtonNode
    let verificationImage: ASImageNode

    
    let _divider: ASDisplayNode

    
    init(withUserResult userModel: UserSearchModel) {
        
        
        self.userModel = userModel
        
        userAvatarImageView = ASImageNode() //ASNetworkImageNode()
        userAvatarImageView.layerBacked = true
        
        userAvatarImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userAvatarImageView.preferredFrameSize = CGSizeMake(44, 44)
        userAvatarImageView.cornerRadius = 22.0
        
        userAvatarImageView.imageModificationBlock = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            UIBezierPath(roundedRect: rect, cornerRadius: 44.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }

        
        
        
        userNameLabel = ASTextNode()
        userNameLabel.layerBacked = true
        userNameLabel.attributedText = HAGlobal.titlesAttributedString(userModel.userName,
                                                                         color: UIColor.blackColor(),
                                                                         textSize: 18)
        
        userRealnameLabel = ASTextNode()
        userRealnameLabel.layerBacked = true
        
        userRealnameLabel.attributedString = HAGlobal.titlesAttributedString(userModel.fullName,
                                                                             color: UIColor.blackColor(),
                                                                             textSize: 16)
        
        verificationImage = ASImageNode()
        verificationImage.image = UIImage(named: "circle-tick-7.png")
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
        // verificationImage.imageModificationBlock = verificationRoundModBlock
        
        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.layerBacked = true
        
        _divider.backgroundColor = UIColor.lightGrayColor()
        
        
        super.init()

        
        print("UserSearchTableCN avatarImageClosure")
        userModel.avatarImageClosure = { image in
            print("UserSearchTableCN avatarImageClosure 2")

            self.userAvatarImageView.image = image
        }
        
        
        if userAvatarImageView.image == nil {
            print("UserSearchTableCN userAvatarImageView.image 3")

            if let downloadedFile = userModel.downloadFileURL {
                print("UserSearchTableCN userAvatarImageView.image 4")

                if let data = NSData(contentsOfURL: downloadedFile) {
                    userAvatarImageView.image = UIImage(data: data)
                }
            }
        }
        
        
        addSubnode(userAvatarImageView)
        addSubnode(userNameLabel)
        addSubnode(userRealnameLabel)
        addSubnode(verificationImage)
        addSubnode(_divider)
    }
    
    
    
    override func layout() {
        super.layout()
        
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
        
        let widthParts = calculatedSize.width/5
        let width = widthParts * 4
        let halfSide = widthParts/2
        
        _divider.frame = CGRectMake(halfSide, 0, width, pixelHeight)
    }
    

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var nameContents: [ASDisplayNode] = [userNameLabel]
        
//        if let verified = userModel.verified {
//            if verified {
//                nameContents.append(verificationImage)
//            }
//        }

        
        let usernameStack = ASStackLayoutSpec(direction: .Horizontal,
                                             spacing: 5,
                                             justifyContent: .Start,
                                             alignItems: .Center,
                                             children: nameContents)
        
        let userNameStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Start,
                                          children: [usernameStack, userRealnameLabel])
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
                                              spacing: 5,
                                              justifyContent: .Start,
                                              alignItems: .Center,
                                              children: [userAvatarImageView, userNameStack])
        
        let fullStackWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 10, 20), child: fullStack)
        
        return fullStackWithInset
    }
    
    
}