//
//  HABasicUserDetailsCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

class HABasicUserDetailsCN: ASCellNode {
    
    
    
    // Font sizes
    
    
    let topLabelSize: CGFloat = 14.0
    let topTextSize: CGFloat = 14.0
    let friendButtonSize: CGFloat = 14.0
    
    
    
    
    // Variables
    let userProfile: ProfileModel
    let userPic: ASImageNode // change to ASNetworkImageNode
    
    
    let friendsCountNode: HADoubleLabelButton

    let friendsButton: ASButtonNode
    
    let fullnameLabel: ASTextNode
    let verificationImage: ASImageNode
    
    let shortDescription: ASTextNode
    let domainWebLink: ASTextNode
    
    
    init(withProfileModel profile: ProfileModel) {
        
        userProfile = profile
        
        
        // Make images round
        let smallRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 128).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        userPic = ASImageNode()
        userPic.image = UIImage(named: profile.user.userTestPic!)
        userPic.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userPic.preferredFrameSize = CGSizeMake(128, 128)
        userPic.cornerRadius = 64
        userPic.flexShrink = true
        userPic.imageModificationBlock = smallRoundModBlock
        
        
        
//        let friendsCountLabelText = HAGlobalNode.attributedString("289", textSize: kTextSizeXS)

        friendsCountNode = HADoubleLabelButton(withTitle: "289", andLabel: "Friends")
//        friendsCountNode.layerBacked = true

        
        // Friends Labels and Texts
        
        print("finsihed coffee")
        
        friendsButton = ASButtonNode()
        
        let friendsButtonText = HAGlobalNode.attributedString("+ FRIEND", font: friendButtonSize, text: .BlackLabel)

        friendsButton.setAttributedTitle(friendsButtonText, forState: .Normal)
        
        friendsButton.backgroundColor = UIColor.whiteColor()
        friendsButton.preferredFrameSize = CGSizeMake(200, 50)
        friendsButton.borderColor = UIColor.redColor().CGColor
        friendsButton.borderWidth = 1.0
        friendsButton.cornerRadius = 3.0
        friendsButton.contentEdgeInsets = UIEdgeInsetsMake(6, 45, 6, 45)
        friendsButton.flexGrow = true
        
        
        let fullnameLabelText = HAGlobalNode.attributedString(profile.user.fullName,
                                                              font: kTextSizeXS,
                                                              text: .BlackLabel)

        fullnameLabel = HAGlobalNode.createLayerBackedTextNodeWithString( fullnameLabelText )
        fullnameLabel.preferredFrameSize = CGSizeMake(100, 50)
        
        
        
        verificationImage = ASImageNode()
        verificationImage.layerBacked = true
        verificationImage.image = UIImage(named: "circle-tick-7.png")
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        
        
        let shortDescriptionText = HAGlobalNode.attributedString(profile.user.about!, font: 14, text: .BlackLabel)

        shortDescription = HAGlobalNode.createLayerBackedTextNodeWithString(shortDescriptionText)
        shortDescription.layerBacked = true
        
        let domainWebLinkText = HAGlobalNode.attributedString(profile.user.domain!, font: 14, text: .BlackLabel)
        domainWebLink = HAGlobalNode.createLayerBackedTextNodeWithString(domainWebLinkText)
        
        
        super.init()
        usesImplicitHierarchyManagement = true
        
        friendsButton.addTarget(self, action: #selector(addFriend), forControlEvents: .TouchUpInside)
    }
    
    func addFriend() {
        
        print("Addfriend")
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        var fullRowContents = [ASLayoutable]()
        fullRowContents.append(userPic)
        
        friendsButton.alignSelf = .Stretch
//        friendsButton.preferredFrameSize =
        let leftStack = ASStackLayoutSpec(direction: .Vertical,
                                            spacing: 20,
                                            justifyContent: .SpaceBetween ,
                                            alignItems: .Stretch ,
                                            children: [friendsCountNode, friendsButton])

        leftStack.flexGrow = true
//        leftStack.alignSelf = .Stretch

        
        
        
        let topFullstack = ASStackLayoutSpec(direction: .Horizontal,
                                            spacing: 20,
                                            justifyContent: .SpaceBetween ,
                                            alignItems: .Center,
                                            children: [userPic, leftStack ])
        
        topFullstack.flexGrow = true
        topFullstack.alignSelf = .Stretch
        
//        
//        if rightSideContents.count > 1 {
//            
//            
//            
//            let topRowStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                spacing: 20,
//                                                justifyContent: .SpaceBetween ,
//                                                alignItems: .Center,
//                                                children: rightSideContents)
//            topRowStack.alignSelf = .Stretch
//            //            topRowStack.spacingBefore = 80
//            
//            let bottomRowStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                   spacing: 0,
//                                                   justifyContent: .Start,
//                                                   alignItems: .End,
//                                                   children: [ friendsButton])
//            bottomRowStack.alignSelf = .Stretch
//            
//            
//            let rightSideFullStack = ASStackLayoutSpec(direction: .Vertical,
//                                                       spacing: 5,
//                                                       justifyContent: .Start,
//                                                       alignItems: .Start,
//                                                       children: [topRowStack, bottomRowStack] )
//            
//            rightSideFullStack.spacingBefore = 20.0
//            fullRowContents.append(rightSideFullStack)
        
            
//            
//        } else {
//            rightSideContents.append(spacer)
//            rightSideContents.append(friendsButton)
//            
//            let singleRowStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                   spacing: 5,
//                                                   justifyContent: .Start,
//                                                   alignItems: .Stretch,
//                                                   children: rightSideContents)
//            fullRowContents.append(singleRowStack)
//        }
        
        
        
//        let topFullstack = ASStackLayoutSpec(direction: .Horizontal,
//                                             spacing: 0,
//                                             justifyContent: .Start ,
//                                             alignItems: .Center,
//                                             children: fullRowContents)
        
        
        var nameContents: [ASLayoutable] = [fullnameLabel]
        
        if let verified = userProfile.user.verified {
            if verified {
                nameContents.append(verificationImage)
            }
        }
        
        
        let nameStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: nameContents)
        nameStack.spacingBefore = 10.0
        
        
        var mainContents: [ASLayoutable] = [topFullstack, nameStack]
        
        if userProfile.user.about != nil {
            mainContents.append(shortDescription)
        }
        
        if userProfile.user.domain != nil {
            mainContents.append(domainWebLink)
        }
        
        
        
        
        
        let fullStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Start,
                                          children: mainContents)
        
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 15, 10, 15), child: fullStack)
        
        
        
    }
    
    
    
}