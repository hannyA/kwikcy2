//
//  BasicProfileCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//
//  ProfilePageNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit

protocol BasicProfileCNDelegate {
    func showImageOptions()
    func editProfile()
    func showFriends()
//    func editProfile()

    //    func showLargeImage()
}


class BasicProfileCellNode: ASCellNode {
    
    
    var delegate: BasicProfileCNDelegate?
    
    // Set if this is the user's own profile
    let loggedInUser: Bool
    
    // Like points
    let pointLikePoint:CGFloat = 1.0
    let albumLikePOint:CGFloat = 10.0
    
        // Font sizes
    
    let topLabelSize: CGFloat = 14.0
    let topTextSize: CGFloat = 14.0
    let friendButtonSize: CGFloat = 14.0
    
    
    // Variables
    let userProfile: UserSearchModel
    let userPic: ASImageNode // change to ASNetworkImageNode
    
    
    let likePoints: ASTextNode // karma Points
    let likePointsLabel: ASTextNode
    
    //    let publicAlbumsCount: ASTextNode
    //    let publicAlbumsCountLabel: ASTextNode
    
    let followersCount: ASTextNode
    let followersCountLabel: ASTextNode
    
    let followingCount: ASTextNode
    let followingCountLabel: ASTextNode
    
    
    let friendCount: ASButtonNode
//    let friendCountLabel: ASButtonNode
    
    
    
    let friendsButton: ASButtonNode
    let followButton: ASButtonNode
    
    
    let fullnameLabel: ASTextNode
    let verificationImage: ASImageNode
    
    let shortDescription: ASTextNode
    let domainWebLink: ASTextNode
    
    let publicAlbumsAvailable = false
    
    
    // Internal Functions for pre init variabels
    func createLayerBackedTextNodeWithString(attributedString: NSAttributedString) -> ASTextNode {
        let textNode = ASTextNode()
        textNode.layerBacked = true
        textNode.attributedString = attributedString
        return textNode
    }

    
    init(withProfileModel profile: UserSearchModel, loggedInUser loggedIn: Bool) {
        
        loggedInUser = loggedIn
        userProfile = profile

        
        // Internal Functions for pre init variabels
        func createLayerBackedTextNodeWithString(attributedString: NSAttributedString) -> ASTextNode {
            let textNode = ASTextNode()
            textNode.layerBacked = true
            textNode.attributedString = attributedString
            return textNode
        }
        
        func labelAttributedString(string: String, withFontSize size: CGFloat) -> NSAttributedString {
            return NSAttributedString(string: string, fontSize: size, color: UIColor.lightGrayColor(), firstWordColor: nil)
        }
        
        func textAttributedString(string: String, withFontSize size: CGFloat) -> NSAttributedString {
            return NSAttributedString(string: string, fontSize: size, color: UIColor.blackColor(), firstWordColor: nil)
        }
        
        

        //        friendCount.image
//        friendCount.titleNode.
        userPic = ASImageNode()
        userPic.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userPic.preferredFrameSize = CGSizeMake(88, 88)
        userPic.cornerRadius = 44.0
        userPic.flexShrink = true
        userPic.imageModificationBlock = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 88.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        
        
        
        
        
        //        totalPublicAlbumsCountLabel
        //        totalPublicAlbumsCount = createLayerBackedTextNodeWithString(labelDetailAttributedString(profile.publicAlbums.count, withFontSize: 20))
        
        //        totalPublicAlbumsCount.attributedString = labelDetailAttributedString(<#T##string: String##String#>, withFontSize: <#T##CGFloat#>)
        
        
        //        publicAlbumsCountLabel = createLayerBackedTextNodeWithString(labelAttributedString( "Albums",  withFontSize: 20))
        //        publicAlbumsCount = createLayerBackedTextNodeWithString(labelAttributedString("Albums", withFontSize: 20))
        
        
        
        friendCount = HADoubleLabelButton(withTitle: String(profile.friendsCount ?? 0),
                                          andLabel: "Friends")
        
        
        
        /* ============================================================================================
           ============================================================================================
                    Second Stage variables with public albums
           ============================================================================================
           ============================================================================================
         */
        
         likePoints = createLayerBackedTextNodeWithString(textAttributedString( "24.5K",  withFontSize: topTextSize))
        likePointsLabel = createLayerBackedTextNodeWithString(labelAttributedString( "Karma",  withFontSize: topLabelSize))
        
        
        
        
        // Following Labels and Texts
        
        let followingsCount = profile.friendsCount ?? 0
        
        // Variable Count
        followingCount = createLayerBackedTextNodeWithString(textAttributedString(String(followingsCount),
            withFontSize: topTextSize))
        followingCount.preferredFrameSize = CGSizeMake(50, 50)
        
        // Label
        followingCountLabel = createLayerBackedTextNodeWithString(labelAttributedString("Following",
            withFontSize: topLabelSize))
        followingCountLabel.preferredFrameSize = CGSizeMake(50, 50)
        
        
        
        // Followers Labels and Texts
        
        let followCount = profile.friendsCount ?? 0
        
        followersCount = createLayerBackedTextNodeWithString(textAttributedString(String(followCount),
            withFontSize: topTextSize))
        followersCount.preferredFrameSize = CGSizeMake(50, 50)
        
        
        
        followersCountLabel = createLayerBackedTextNodeWithString(labelAttributedString("Followers",
            withFontSize: topLabelSize))
        followersCountLabel.preferredFrameSize = CGSizeMake(50, 50)
        
        
//        followersCount
        
        // Friends Labels and Texts
        
        
        
        
        /* ============================================================================================
         ============================================================================================
                        END:  Second Stage variables with public albums
         ============================================================================================
         ============================================================================================
         */
        
        
        friendsButton = ASButtonNode()
        
        let attributedString: String

        if loggedInUser {
            attributedString = "Edit Profile"
        } else {
            attributedString = "+ FRIEND"
        }
        
        friendsButton.setAttributedTitle(textAttributedString( attributedString, withFontSize: friendButtonSize), forState: .Normal)
        
        
        friendsButton.backgroundColor = UIColor.whiteColor()
        friendsButton.preferredFrameSize = CGSizeMake(200, 50)
        friendsButton.borderColor = UIColor.redColor().CGColor
        friendsButton.borderWidth = 1.0
        friendsButton.cornerRadius = 3.0
        
        friendsButton.contentEdgeInsets = UIEdgeInsetsMake(6, 45, 6, 45)
        
        friendsButton.flexGrow = true
        
        
        
        
        
        // Follow button
        
        followButton = ASButtonNode()
        followButton.setAttributedTitle(textAttributedString("+ Follow", withFontSize: friendButtonSize), forState: .Normal)
        followButton.backgroundColor = UIColor.greenColor()
        followButton.preferredFrameSize = CGSizeMake(100, 50)
        
        
        followButton.borderColor = UIColor.lightGrayColor().CGColor
        followButton.borderWidth = 2.0
        followButton.cornerRadius = 2.0
        
        
        fullnameLabel = createLayerBackedTextNodeWithString(textAttributedString(profile.fullName , withFontSize: 16))
        fullnameLabel.preferredFrameSize = CGSizeMake(100, 50)
        
        
        
        verificationImage = ASImageNode()
        
        verificationImage.icon(from: .MaterialIcon,
                               code: "verified.user",
                               imageSize: CGSizeMake(12, 12),
                               ofSize: 12,
                               color: UIColor.blueColor())
        
        
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
        verificationImage.cornerRadius = 6.0
        verificationImage.backgroundColor =  UIColor.lightBlueColor()
        
        
        
        shortDescription = createLayerBackedTextNodeWithString(textAttributedString(profile.about ?? "", withFontSize: 14))
        domainWebLink = createLayerBackedTextNodeWithString(textAttributedString(profile.domain ?? "", withFontSize: 14))
        
        
        super.init()
        
        userPic.contentMode = .ScaleAspectFill
        
        userProfile.avatarImageClosure = { image in
            self.userPic.image = image
        }
        
        if userPic.image == nil {
            if let downloadedFile = userProfile.downloadFileURL {
                if let data = NSData(contentsOfURL: downloadedFile) {
                    self.userPic.image = UIImage(data: data)
                }
            }
        }
        
        

        
        addSubnode(userPic)
//        addSubnode(likePoints)
//        addSubnode(likePointsLabel)
//        addSubnode(publicAlbumsCount)
//        addSubnode(publicAlbumsCountLabel)
//        addSubnode(followersCount)
//        addSubnode(followersCountLabel)
//        addSubnode(followingCount)
//        addSubnode(followingCountLabel)
        addSubnode(friendCount)
        
        addSubnode(friendsButton)
        addSubnode(followButton)
        
        addSubnode(fullnameLabel)
        addSubnode(verificationImage)
        addSubnode(shortDescription)
        addSubnode(domainWebLink)
        
        
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        userPic.addTarget(self, action: #selector(showImageOptions), forControlEvents: .TouchUpInside)
        
        friendCount.addTarget(self, action: #selector(openFriendsListVC), forControlEvents: .TouchUpInside)
        
        
        if loggedInUser {
            friendsButton.addTarget(self, action: #selector(editProfile), forControlEvents: .TouchUpInside)
        } else {
            friendsButton.addTarget(self, action: #selector(addFriend), forControlEvents: .TouchUpInside)
        }
    }
    
    func editProfile() {
        delegate?.editProfile()
    }
    
    
    func importImageFromFacebook() {
        print("importImageFromFacebook")
    }
    
    func openCamera() {
        print("openCamera")
    }
    
//    func removePhoto() {
////        if userProfile.deleteImage() {
////            userPic.image = nil
////        }
//    }
    
    
    func showImageOptions() {
        delegate?.showImageOptions()
    }
    
//    func showLargeImage() {
//        delegate?.showLargeImage()
//    }
    
    
    
    func openFriendsListVC() {
        print("openFriendsListVC")
        
        delegate?.showFriends()

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
            friendCount.spacingBefore = 20
            rightSideContents.append(friendCount)
            
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
        
        if let verified = userProfile.verified {
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
        
        if let _ = userProfile.about {
            mainContents.append(shortDescription)
        }
        
        if let _ = userProfile.domain {
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