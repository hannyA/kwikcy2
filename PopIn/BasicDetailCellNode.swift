//
//  ProfilePageNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class BasicDetailCellNode: ASCellNode {
    
    
    // Like points
    let pointLikePoint:CGFloat = 1.0
    let albumLikePOint:CGFloat = 10.0
    
    
    // Font sizes
    
    
    let topLabelSize: CGFloat = 14.0
    let topTextSize: CGFloat = 14.0
    let friendButtonSize: CGFloat = 14.0
    
    
    
    
    
    
    // Variables
    let userProfile: ProfileModel
    let userPic: ASImageNode // change to ASNetworkImageNode

    
    let likePoints: ASTextNode // karma Points
    let likePointsLabel: ASTextNode

//    let publicAlbumsCount: ASTextNode
//    let publicAlbumsCountLabel: ASTextNode
    
    let followersCount: ASTextNode
    let followersCountLabel: ASTextNode

    let followingCount: ASTextNode
    let followingCountLabel: ASTextNode
    
    let friendsButton: ASButtonNode
    let followButton: ASButtonNode
    

    let fullnameLabel: ASTextNode
    let verificationImage: ASImageNode
    
    let shortDescription: ASTextNode
    let domainWebLink: ASTextNode
    
    let publicAlbumsAvailable = false
    
    
    init(withProfileModel profile: ProfileModel) {
        
        
        // Internal Functions for pre init variabels
        func createLayerBackedTextNodeWithString(attributedString: NSAttributedString) -> ASTextNode {
            let textNode = ASTextNode()
            textNode.layerBacked = true
            textNode.attributedString = attributedString
            return textNode
        }
        
        
//        func highlightedTextAttributedString(string: String, withFontSize size: CGFloat) -> NSAttributedString {
//            return NSAttributedString(string: string, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
//        }
//    
        
        
        
        userProfile = profile
        
        
        // Make images round
        let smallRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 88.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        userPic = ASImageNode()
        userPic.image = UIImage(named: profile.user.userTestPic!)
        userPic.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userPic.preferredFrameSize = CGSizeMake(88, 88)
        userPic.cornerRadius = 44.0
        userPic.flexShrink = true
        userPic.imageModificationBlock = smallRoundModBlock

        
        
//        #if DEV_PUBLIC_ALBUMS
//            print("DEV_PUBLIC_ALBUMS")
//        #elseif DEV_FOLLOWERS
//            print("DEV_FOLLOWERS")
//        #endif
//        
//        #if DEV_FOLLOWERS
//            print("DEV_FOLLOWERS 2")
//        #endif

        
        
        
        
        
//        totalPublicAlbumsCountLabel
//        totalPublicAlbumsCount = createLayerBackedTextNodeWithString(labelDetailAttributedString(profile.publicAlbums.count, withFontSize: 20))
        
//        totalPublicAlbumsCount.attributedString = labelDetailAttributedString(<#T##string: String##String#>, withFontSize: <#T##CGFloat#>)
      
        
//        publicAlbumsCountLabel = createLayerBackedTextNodeWithString(labelAttributedString( "Albums",  withFontSize: 20))
//        publicAlbumsCount = createLayerBackedTextNodeWithString(labelAttributedString("Albums", withFontSize: 20))
      
        
        
        let likePointsText = HAGlobalNode.attributedString("24.5K", font: topTextSize, text: .BlackLabel)
        likePoints = createLayerBackedTextNodeWithString(likePointsText)
        
        let likePointsLabelText = HAGlobalNode.attributedString("Karma", font: topLabelSize, text: .LightGrayLabel)
        likePointsLabel = createLayerBackedTextNodeWithString(likePointsLabelText)

        
        
        // Following Labels and Texts
        
        let followingsCount = profile.user.followingCount ?? 0

        // Variable Count
        let followingCountText = HAGlobalNode.attributedString(String(followingsCount), font: topTextSize, text: .BlackLabel)

        followingCount = createLayerBackedTextNodeWithString(followingCountText)
        followingCount.preferredFrameSize = CGSizeMake(50, 50)
       
        // Label
        let followingCountLabelText = HAGlobalNode.attributedString("Following", font: topLabelSize, text: .LightGrayLabel)

        followingCountLabel = createLayerBackedTextNodeWithString(followingCountLabelText)
        followingCountLabel.preferredFrameSize = CGSizeMake(50, 50)

        
        
        // Followers Labels and Texts

        let followCount = profile.user.followersCount ?? 0

        let followersCountText = HAGlobalNode.attributedString(String(followCount), font: topTextSize, text: .BlackLabel)

        followersCount = createLayerBackedTextNodeWithString(followersCountText)
        followersCount.preferredFrameSize = CGSizeMake(50, 50)
       
        
        let followersCountLabelText = HAGlobalNode.attributedString("Followers", font: topLabelSize, text: .LightGrayLabel)

        followersCountLabel = createLayerBackedTextNodeWithString(followersCountLabelText)
        followersCountLabel.preferredFrameSize = CGSizeMake(50, 50)

        
        
        // Friends Labels and Texts

        
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
        
        
        
        
        
        // Follow button

        followButton = ASButtonNode()
        let followButtonText = HAGlobalNode.attributedString("+ Follow", font: friendButtonSize, text: .BlackLabel)

        followButton.setAttributedTitle(followButtonText, forState: .Normal)
        followButton.backgroundColor = UIColor.greenColor()
        followButton.preferredFrameSize = CGSizeMake(100, 50)

        
        followButton.borderColor = UIColor.lightGrayColor().CGColor
        followButton.borderWidth = 2.0
        followButton.cornerRadius = 2.0
        
        let fullnameLabelText = HAGlobalNode.attributedString(profile.user.fullName!, font: kTextSizeXS, text: .BlackLabel)
        
        fullnameLabel = createLayerBackedTextNodeWithString(fullnameLabelText)
        fullnameLabel.preferredFrameSize = CGSizeMake(100, 50)

        
        
        verificationImage = ASImageNode()
        verificationImage.image = UIImage(named: "circle-tick-7.png")
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        

        
        
        let shortDescriptionText = HAGlobalNode.attributedString(profile.user.about!, font: 14, text: .BlackLabel)

        shortDescription = createLayerBackedTextNodeWithString(shortDescriptionText)
        let domainWebLinkText = HAGlobalNode.attributedString(profile.user.domain!, font: 14, text: .BlackLabel)

        domainWebLink = createLayerBackedTextNodeWithString(domainWebLinkText)
        
        
        super.init()
        usesImplicitHierarchyManagement = true

        friendsButton.addTarget(self, action: #selector(addFriend), forControlEvents: .TouchUpInside)

        
    }
    
    func addFriend() {
        
     
        print("Addfriend")
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
//        let userPic: ASImageNode // change to ASNetworkImageNode
//        
//        let publicAlbumsCount: ASTextNode
//        let publicAlbumsCountLabel: ASTextNode
//        
//        let followersCount: ASTextNode
//        let followersCountLabel: ASTextNode
//        
//        let followingCount: ASTextNode
//        let followingCountLabel: ASTextNode
//        
//        let friendsButton: ASButtonNode
//        let followButton: ASButtonNode
//
//        let fullnameLabel: ASTextNode
//        let verificationImage: ASImageNode
//        
//        let shortDescription: ASTextNode
//        let userWebLink: ASTextNode
        
        
        
        
        
        //        #if DEV_PUBLIC_ALBUMS
        //            print("DEV_PUBLIC_ALBUMS")
        //        #elseif DEV_FOLLOWERS
        //            print("DEV_FOLLOWERS")
        //        #endif
        //
        //        #if DEV_FOLLOWERS
        //            print("DEV_FOLLOWERS 2")
        //        #endif

        
        
        
        
        
        var fullRowContents = [ASLayoutable]()
        fullRowContents.append(userPic)
        
        var rightSideContents = [ASLayoutable]()
        
        
        
#if DEV_PUBLIC_ALBUMS
        
        let likeInfoStack = ASStackLayoutSpec(direction: .Vertical,
                                            spacing: 0,
                                            justifyContent: .Start,
                                            alignItems: .Center,
                                            children: [likePoints, likePointsLabel])
        // Add space to the left side of the top row (karma, etc.)
        likeInfoStack.spacingBefore = 20
        rightSideContents.append(likeInfoStack)
    
#endif
        
     
#if DEV_FOLLOWERS
    

    
        let followerStack = ASStackLayoutSpec(direction: .Vertical,
                                              spacing: 0,
                                              justifyContent: .Start,
                                              alignItems: .Center,
                                              children: [followersCount, followersCountLabel])
    
//        followerStack.spacingBefore = 30
        rightSideContents.append(followerStack)
    

    
        let followingStack = ASStackLayoutSpec(direction: .Vertical,
                                               spacing: 0,
                                               justifyContent: .Start,
                                               alignItems: .Center,
                                               children: [followingCount, followingCountLabel])
        rightSideContents.append(followingStack)
    
    
#endif

//        rightStack.spacingBefore = 30.0
//        
////        return rightStack
////        
////        
//        
//        
//        
//        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                spacing: 5,
//                                                justifyContent: .Start,
//                                                alignItems: .Center,
//                                                children: [userPic, rightStack])
//        
//        let fullStackWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 15, 10, 15), child: fullStack)
//        
//        return fullStackWithInset
        
        
        

        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
//
        
        if rightSideContents.count > 1 {
            
            
            
            let topRowStack = ASStackLayoutSpec(direction: .Horizontal,
                                                   spacing: 20,
                                                   justifyContent: .SpaceBetween ,
                                                   alignItems: .Center,
                                                   children: rightSideContents)
            topRowStack.alignSelf = .Stretch
//            topRowStack.spacingBefore = 80
            
            let bottomRowStack = ASStackLayoutSpec(direction: .Horizontal,
                                                spacing: 0,
                                                justifyContent: .Start,
                                                alignItems: .End,
                                                children: [ friendsButton])
            bottomRowStack.alignSelf = .Stretch
            
            
            let rightSideFullStack = ASStackLayoutSpec(direction: .Vertical,
                                                spacing: 5,
                                                justifyContent: .Start,
                                                alignItems: .Start,
                                                children: [topRowStack, bottomRowStack] )
            
            rightSideFullStack.spacingBefore = 20.0
            fullRowContents.append(rightSideFullStack)
            
            

        } else {
            rightSideContents.append(spacer)
            rightSideContents.append(friendsButton)
            
            let singleRowStack = ASStackLayoutSpec(direction: .Horizontal,
                                                spacing: 5,
                                                justifyContent: .Start,
                                                alignItems: .Stretch,
                                                children: rightSideContents)
            fullRowContents.append(singleRowStack)
        }
        
        
        
        let topFullstack = ASStackLayoutSpec(direction: .Horizontal,
                                                  spacing: 0,
                                                  justifyContent: .Start ,
                                                  alignItems: .Center,
                                                  children: fullRowContents)
       
        
        
        
        
        
        
        
        
        
        
        
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
        
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 15, 10, 0), child: fullStack)
        
        
        
        

//        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 15, 10, 0), child: topFullstack)

        
        
        
        
        
        
        
        
        
//        if tooManyThingsInTopRow {
//            
//            
//            let folowingInfoStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                      spacing: 5,
//                                                      justifyContent: .Start,
//                                                      alignItems: .Start,
//                                                      children: [followingStack, followStack])
//            
//            infoContents.append(folowingInfoStack)
//            
//            
//            let imageFriendStack = ASStackLayoutSpec(direction: .Vertical,
//                                                     spacing: 5,
//                                                     justifyContent: .Start,
//                                                     alignItems: .Center,
//                                                     children: [userPic, spacer, friendsButton])
//        }
        
            
            
        
       
            let imageFriendStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: [userPic, spacer, friendsButton])
        
        imageFriendStack.flexGrow = true
        imageFriendStack.alignSelf = .Stretch
        
        
//        var nameContents: [ASDisplayNode] = [fullnameLabel]
//        
//        if let verified = userProfile.user.verified {
//            if verified {
//                nameContents.append(verificationImage)
//            }
//        }
//        
//        
//        let nameStack = ASStackLayoutSpec(direction: .Horizontal,
//                                          spacing: 5,
//                                          justifyContent: .Start,
//                                          alignItems: .Center,
//                                          children: nameContents)
//        
//
//        
//        var mainContents: [ASLayoutable] = [imageFriendStack, nameStack]
//        
//        if userProfile.user.about != nil {
//            mainContents.append(shortDescription)
//        }
//        
//        if userProfile.user.domain != nil {
//            mainContents.append(domainWebLink)
//        }
//        
//        
//        
//        
//        
//        let fullStack = ASStackLayoutSpec(direction: .Vertical,
//                                                 spacing: 0,
//                                                 justifyContent: .Start,
//                                                 alignItems: .Start,
//                                                 children: mainContents)
//        
//
//        
//        
//        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 15, 10, 15), child: fullStack)
        
        
        
//
//        let spacer = ASLayoutSpec()
//        spacer.flexGrow = true
//        
//        
//        
//        
//        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
//                                          spacing: 5,
//                                          justifyContent: .Start,
//                                          alignItems: .Center,
//                                          children: [userAvatarImageView, userNameStack, spacer, friendsButton])
//        
//        //        let a = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
//        let fullStackWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 20), child: fullStack)
//        
        

        
        
        
    }
    
    
        
}