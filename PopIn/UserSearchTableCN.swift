//
//  UserSearchTableNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/21/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class UserSearchTableCN: ASCellNode {
    
    
    let userModel: UserModel
    
    let userAvatarImageView: ASImageNode
    let userNameLabel: ASTextNode
    let userRealnameLabel: ASTextNode
//    let friendsButton: ASButtonNode
    let verificationImage: ASImageNode

    
    let _divider: ASDisplayNode

    
    init(withUserModel model: UserModel) {
    
        userModel = model
        
        // Make images round
        let smallRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 44.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        userAvatarImageView = ASImageNode() //ASNetworkImageNode()
        userAvatarImageView.layerBacked = true
        userAvatarImageView.image = userModel.userPic
        userAvatarImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userAvatarImageView.preferredFrameSize = CGSizeMake(44, 44)
        userAvatarImageView.cornerRadius = 22.0
        
        userAvatarImageView.imageModificationBlock = smallRoundModBlock
        
        
//        func
        
        userNameLabel = ASTextNode()
        userNameLabel.layerBacked = true

        userNameLabel.attributedString = userModel.usernameAttributedStringWithFontSize(18)
        
        
        userRealnameLabel = ASTextNode()
        userRealnameLabel.layerBacked = true

        userRealnameLabel.attributedString = userModel.fullNameAttributedStringWithFontSize(16)
        
//        friendsButton = ASButtonNode()
//        friendsButton.setTitle("Friends", withFont: UIFont(name:"HelveticaNeue", size: 18 ) , withColor: UIColor.blackColor(), forState: .Normal)
        

        // Make images round
        let verificationRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 6.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        
        verificationImage = ASImageNode()
        verificationImage.image = UIImage(named: "circle-tick-7.png")
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
//        verificationImage.imageModificationBlock = verificationRoundModBlock

        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.layerBacked = true

        _divider.backgroundColor = UIColor.lightGrayColor()
        

        super.init()

        
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
        
        
        
        
//        let userAvatarImageView: ASImageNode
//        let userNameLabel: ASTextNode
//        let userRealnameLabel: ASTextNode
//        let friendsButton: ASButtonNode
    
        
        var nameContents: [ASDisplayNode] = [userNameLabel]
        
        if let verified = userModel.verified {
            if verified {
                nameContents.append(verificationImage)
            }
        }

        
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