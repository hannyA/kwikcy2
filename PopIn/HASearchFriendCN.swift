//
//  HASearchFriendCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HASearchFriendCN: ASCellNode {
    
    
    let userModel: UserModel
    
    let userAvatarImageView: ASImageNode
    let userNameLabel: ASTextNode
    let userRealnameLabel: ASTextNode
    let verificationImage: ASImageNode

    let checkImage: ASImageNode
    let _divider: ASDisplayNode
    let hasTopDivider:Bool
    var isSelected = false
    
    init(withUserModel model: UserModel, hasDivider:Bool) {
        
        userModel = model
        hasTopDivider = hasDivider
        
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
        userAvatarImageView.image = userModel.userPic
        userAvatarImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userAvatarImageView.preferredFrameSize = CGSizeMake(44, 44)
        userAvatarImageView.cornerRadius = 22.0
        userAvatarImageView.layerBacked = true
        userAvatarImageView.imageModificationBlock = smallRoundModBlock
        
        
        //        func
        
        userNameLabel = ASTextNode()
        userNameLabel.attributedString = userModel.usernameAttributedStringWithFontSize(18)
        userNameLabel.layerBacked = true
        
        userRealnameLabel = ASTextNode()
        userRealnameLabel.attributedString = userModel.fullNameAttributedStringWithFontSize(16)
        userRealnameLabel.layerBacked = true

        //        friendsButton = ASButtonNode()
        //        friendsButton.setTitle("Friends", withFont: UIFont(name:"HelveticaNeue", size: 18 ) , withColor: UIColor.blackColor(), forState: .Normal)
        
        
//        // Make images round
//        let verificationRoundModBlock: asimagenode_modification_block_t = { image in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: 6.0).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
        
        
        verificationImage = ASImageNode()
        verificationImage.image = UIImage(named: "circle-tick-7.png")
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
        //        verificationImage.imageModificationBlock = verificationRoundModBlock
        verificationImage.layerBacked = true

        
//        // Make images round
//        let tickRoundModBlock: asimagenode_modification_block_t = { image in
//            var modifiedImage: UIImage
//            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//            
//            
//            UIBezierPath(roundedRect: rect, cornerRadius: 6.0).addClip()
//            
//            image.drawInRect(rect)
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return modifiedImage
//        }
        
        
        
        
        checkImage = ASImageNode()
        checkImage.layerBacked = true

        
        checkImage.preferredFrameSize = CGSizeMake(30, 30)
        checkImage.cornerRadius = 15.0
//        chooseButton.imageModificationBlock = tickRoundModBlock
        
        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        
        
        super.init()
        
        
        addSubnode(userAvatarImageView)
        addSubnode(userNameLabel)
        addSubnode(userRealnameLabel)
        addSubnode(verificationImage)
        addSubnode(_divider)
        addSubnode(checkImage)
    }
    
    override func didLoad() {
        super.didLoad()
        
        userSelected(isSelected)

    }
    
    
    func userSelected(selected:Bool) {

        print("userSelected")
        isSelected = selected
        if isSelected {
            print("isSelected")

            checkImage.borderColor = UIColor.clearColor().CGColor
            checkImage.image = UIImage(named: "circle-tick-7.png")
            checkImage.backgroundColor =  UIColor.greenColor()
        } else {
            print("is not Selected")

            checkImage.borderColor = UIColor.lightGrayColor().CGColor
            checkImage.image = nil
            checkImage.backgroundColor =  UIColor.whiteColor()
        }
    }
    
    
    
    
    override func layout() {
        super.layout()
        
        if hasTopDivider {
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            let widthParts = calculatedSize.width/5
            let width = widthParts * 4
            let halfSide = widthParts/2
            _divider.frame = CGRectMake(halfSide, 0, width, pixelHeight)
        }
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
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
                                          children: [userAvatarImageView, userNameStack, spacer, checkImage])
        
        let fullStackWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 10, 20), child: fullStack)
        
        
        
        return fullStackWithInset
        
        
    }
}

