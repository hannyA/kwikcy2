//
//  AlbumCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/14/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class AlbumCellNode: ASCellNode {
    
    
    
    let DEBUG_PHOTOCELL_LAYOUT = 0
    
    let HEADER_HEIGHT       = 50
    let USER_IMAGE_HEIGHT   = 30
    let HORIZONTAL_BUFFER   = 10
    let VERTICAL_BUFFER     = 5
    
    let AlbumTitleFontSize:  CGFloat = 14
    let AlbumTimeFontSize:   CGFloat = 10
    let UsernameFontSize:    CGFloat = 10
    let UserRealnameFontSize:CGFloat = 10
    let FONT_SIZE:           CGFloat = 14
    
    
    let album: AlbumModel
    let userAvatarImageView: ASImageNode// ASNetworkImageNode
    let albumImageView: ASImageNode //SNetworkImageNode
    let userNameLabel: ASTextNode
    let userRealNameLabel: ASTextNode
    let photoTimeIntervalSincePostLabel: ASTextNode
    let photoTitleLabel: ASTextNode

    
    let _divider: ASDisplayNode

    
    init(withAlbumObject albumModel: AlbumModel) {
        
        album = albumModel
        
        
        // Make images round
        let smallRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 34.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        
        
        let largeRoundModBlock: asimagenode_modification_block_t = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: 66.0).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        
        
        
        
        userAvatarImageView = ASImageNode() //ASNetworkImageNode()
//        userAvatarImageView.URL = album.ownerProfile!.userPicURL
        userAvatarImageView.layerBacked = true
        userAvatarImageView.image = UIImage(named: (album.ownerProfile?.userTestPic)!)
        
        userAvatarImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userAvatarImageView.preferredFrameSize = CGSizeMake(34, 34)
        userAvatarImageView.cornerRadius = 17.0
        
        userAvatarImageView.imageModificationBlock = smallRoundModBlock
        
        
        
        // userAvatarImageView: make round
//        userAvatarImageView.imageModificationBlock
//        
//        // FIXME: autocomplete for this line seems broken
//        [userAvatarImageView  setImageModificationBlock:^UIImage *(UIImage *image) {
//        CGSize profileImageSize = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
//        return [image makeCircularImageWithSize:profileImageSize];
//        }];
        
        
        albumImageView = ASImageNode()
        albumImageView.layerBacked = true
        albumImageView.image = UIImage(named: album.coverPhoto!) // album.coverPhotoURL
        albumImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        albumImageView.preferredFrameSize = CGSizeMake(66, 66)
        albumImageView.cornerRadius = 33.0
        
        albumImageView.flexShrink = false

        albumImageView.imageModificationBlock = largeRoundModBlock
        
        
        
        // User pic
//        _avatarNode = [[ASNetworkImageNode alloc] init];
//        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
//        _avatarNode.preferredFrameSize = CGSizeMake(44, 44);
//        _avatarNode.cornerRadius = 22.0;
//        _avatarNode.URL = [NSURL URLWithString:_post.photo];
//        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
//            
//            UIImage *modifiedImage;
//            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            
//            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
//            
//            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:44.0] addClip];
//            [image drawInRect:rect];
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
//            
//            UIGraphicsEndImageContext();
//            
//            return modifiedImage;
//            
//        };
//        [self addSubnode:_avatarNode];
        
        
        
        
        
        
        userNameLabel = ASTextNode()
        userNameLabel.attributedString = album.ownerProfile?.usernameAttributedStringWithFontSize(FONT_SIZE)
        userNameLabel.flexShrink = true
        userNameLabel.layerBacked = true


        userRealNameLabel = ASTextNode()
        userRealNameLabel.attributedString = album.ownerProfile?.fullNameAttributedStringWithFontSize(FONT_SIZE)
        userRealNameLabel.layerBacked = true
        
        
        photoTimeIntervalSincePostLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.timeAttributedStringWithFontSize(AlbumTimeFontSize))
        
        
        
        photoTitleLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.titleAttributedStringWithFontSize(AlbumTitleFontSize))
        photoTitleLabel.maximumNumberOfLines = 1
        photoTitleLabel.flexShrink = true
//        photoTitleLabel.truncationMode = .ByWordWrapping
        photoTitleLabel.truncationMode = .ByClipping
        
        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        _divider.layerBacked = true

        
        super.init()
        
        
       
        
        addSubnode(userAvatarImageView)
        addSubnode(albumImageView)
        addSubnode(userNameLabel)
        addSubnode(userRealNameLabel)
        addSubnode(photoTimeIntervalSincePostLabel)
        addSubnode(photoTitleLabel)
        addSubnode(_divider)
    }
    
    
    
    
    
    override func layout() {
        super.layout()
        
//        // Manually layout the divider.
//        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
//        
//        let widthParts = calculatedSize.width/5
//        let width = widthParts * 4
//        let halfSide = widthParts/2
//        
//        _divider.frame = CGRectMake(halfSide, 0, width, pixelHeight)

        
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
        
        let widthParts = calculatedSize.width/10
        let width = widthParts * 8
        let leftInset = widthParts*1.5
        
        
        _divider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
        
        
        
        
        
    }

    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
    
        // Album photo and title - vertical stack
        
        
        let albumImageWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: albumImageView)

        
        
        let avatarTimeSameLineStack = ASStackLayoutSpec(direction: .Horizontal,
                                                         spacing: 40,
                                                         justifyContent: .Start,
                                                         alignItems: .BaselineLast ,
                                                         children: [userAvatarImageView, photoTimeIntervalSincePostLabel])
        

        
        
        let userStack = ASStackLayoutSpec(direction: .Vertical,
                                                 spacing: 0,
                                                 justifyContent: .Start,
                                                 alignItems: .Start,
                                                 children: [avatarTimeSameLineStack, userNameLabel])
    
        
        
        
        let avatarTitleSpacer = ASLayoutSpec()
        avatarTitleSpacer.flexGrow = true
        

        let mainContentStack = ASStackLayoutSpec(direction: .Vertical,
                                            spacing: 5,
                                            justifyContent: .Start,
                                            alignItems: .Start,
                                            children: [photoTitleLabel, avatarTitleSpacer, userStack])
        
        
//        
//        let timeStack = ASStackLayoutSpec(direction: .Vertical,
//                                                 spacing: 5,
//                                                 justifyContent: .Start,
//                                                 alignItems: .Start,
//                                                 children: [photoTimeIntervalSincePostLabel])
        
//        return albumStack
//        let albumStackWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5,5,5,5), child: albumStack)

        
        
//        userAvatarImageView.flexShrink = false
//        let userAvatarWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(1, 1, 1,1), child: userAvatarImageView)
//
//        userAvatarWithInset.flexShrink = false
        
        
//        photoTimeIntervalSincePostLabel.alignSelf = .End
        
        
        
        
        
        let smaple = ASStackLayoutSpec(direction: .Horizontal,
                                         spacing: 10,
                                         justifyContent: .Start,
                                         alignItems: .Center,
                                         children: [albumImageWithInset, mainContentStack])

        return  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8,15,8,15), child: smaple)

        
        

        
        
        
        
        
//        
//        let middleStack = ASStackLayoutSpec(direction: .Vertical,
//                                          spacing: 0,
//                                          justifyContent: .Start,
//                                          alignItems: .End,
//                                          children: [userAvatarImageView, userNameLabel, userRealNameLabel])
//        
//        
//        
//        let rightStack = ASStackLayoutSpec(direction: .Vertical,
//                                            spacing: 0,
//                                            justifyContent: .Start,
//                                            alignItems: .Center,
//                                            children: [photoTimeIntervalSincePostLabel])
//        
//        
//        
//        let cellNode = ASStackLayoutSpec(direction: .Horizontal,
//                                          spacing: 0,
//                                          justifyContent: .Start,
//                                          alignItems: .Start,
//                                          children: [albumStack, middleStack, rightStack])
//                
//        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: cellNode)

        
        
        
    }
    
    
}