//
//  MyAlbumCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftIconFont

protocol MyAlbumCNDelegate {
    func showOptionsForAlbum(album: AlbumModel)
    func uploadAlbum(album: AlbumModel)
    func retryUploadingMediaToAlbum(album: AlbumModel)
}

class MyAlbumCN: HAAlbumCN {
    
    
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
    var delegate:MyAlbumCNDelegate?
    
    let albumImageView: ASButtonNode
    let photoTimeIntervalSincePostLabel: ASTextNode
    let photoTitleLabel: ASTextNode
    
    let checkImage: ASImageNode
    var isUserSelected = false
    
    let moreOptionButton: ASButtonNode
    let _divider: ASDisplayNode

    let activityIndicatorView: UIActivityIndicatorView
    let albumWidth:CGFloat = 66.0

    
    
    init(withAlbumObject albumModel: AlbumModel, isSelectable selectionEnabled: Bool, hasTopDivider: Bool) {
        
        print("MyAlbumCN didLoad init ")
 
        album = albumModel
        
        albumImageView = ASButtonNode()
        
        albumImageView.backgroundImageNode.image = UIImage(named: "DefaultProfileImage")

        if let coverImage = album.coverPhotoImage {
            albumImageView.backgroundImageNode.image = coverImage
        }
        
        
        
        albumImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        albumImageView.preferredFrameSize = CGSizeMake(albumWidth, albumWidth)
        albumImageView.cornerRadius = albumWidth/2
        
        albumImageView.flexShrink = false
        
        
        
        photoTimeIntervalSincePostLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.timeAttributedStringWithFontSize(AlbumTimeFontSize))
        
        
        photoTitleLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.titleAttributedStringWithFontSize(AlbumTitleFontSize))
        photoTitleLabel.maximumNumberOfLines = 1
        photoTitleLabel.flexShrink = true
        //        photoTitleLabel.truncationMode = .ByWordWrapping
        photoTitleLabel.truncationMode = .ByClipping
        
        
        
        
        checkImage = ASImageNode()
        checkImage.layerBacked = true
        checkImage.preferredFrameSize = CGSizeMake(40, 40)
        checkImage.cornerRadius = 15.0
        
        
        moreOptionButton = ASButtonNode()
        
        
        
        moreOptionButton.imageNodeIcon(from: .MaterialIcon,
                                       code: "more.vert",
                                       imageSize: CGSizeMake(40, 40),
                                       ofSize: 40, color: UIColor.redColor(),
                                       forState: .Normal)
        
        moreOptionButton.imageNodeIcon(from: .MaterialIcon,
                                       code: "more.vert",
                                       imageSize: CGSizeMake(40, 40),
                                       ofSize: 40, color:UIColor(red: 1.0, green: 0.1, blue: 3.0, alpha: 1.0),
                                       forState: .Highlighted)
        
        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        

        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.blackColor()

       
        super.init()
        
        
        albumImageView.backgroundImageNode.imageModificationBlock = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            UIBezierPath(roundedRect: rect, cornerRadius: self.albumWidth).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }

        addSubnode(albumImageView)
        addSubnode(photoTimeIntervalSincePostLabel)
        addSubnode(photoTitleLabel)
        if selectionEnabled {
            addSubnode(checkImage)
        }
        addSubnode(moreOptionButton)
        if hasTopDivider {
            addSubnode(_divider)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        print(" MyAlbumCN didLoad")
        
        
        albumImageView.backgroundImageNode.hidden = true
        albumImageView.titleNode.hidden = true
    
        albumImageView.titleNodeIcon(from: .FontAwesome,
                            code: "repeat",
                            ofSize: albumWidth*(4/5),
                            color: UIColor.redColor(),
                            forState: .Normal)
        
        
        albumImageView.addTarget(self, action: #selector(retryCreatingAlbumOrUploadingMedia), forControlEvents: .TouchUpInside)
        moreOptionButton.addTarget(self, action: #selector(showMoreOptionsMenu), forControlEvents: .TouchUpInside)
        
        userSelected(false)

        view.addSubview(activityIndicatorView)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(uploadSuccessful),
                                                         name:kAlbumCreateNotification,
                                                         object: album)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(mediaUploadSuccessful),
                                                         name: kAlbumMediaUploadNotification,
                                                         object: album)
        
        hideSpinningWheel()
        hideRetryButton()

        if album.isUploading {
            print(" MyAlbumCN didLoad isUploading")
            showSpinningWheel()
        } else {
            print(" MyAlbumCN didLoad is not Uploading")
        }
    }
    
    
    override func layout() {
        super.layout()
        
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
        
        let widthParts = calculatedSize.width/10
        let width = widthParts * 8
        let leftInset = widthParts*1.5
        _divider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
        
        activityIndicatorView.center = albumImageView.view.center
    }
    
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kAlbumCreateNotification, object: album)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kAlbumMediaUploadNotification, object: album)
    }
    
    
    func replaceTitle() {
        photoTitleLabel.attributedText =  album.titleAttributedStringWithFontSize(AlbumTitleFontSize)
        setNeedsLayout()
    }

    
    
    
    
    func userSelected(selected:Bool) {
                
        isUserSelected = selected
        if isUserSelected {
//            checkImage.borderColor = UIColor.clearColor().CGColor
//            checkImage.backgroundColor =  UIColor.greenColor()
            
            
            checkImage.icon(from: .Ionicon,
                            code: "ios-checkmark-outline",
                            imageSize: CGSizeMake(40, 40),
                            ofSize: 40,
                            color: UIColor.greenColor())
        } else {
            
            checkImage.image = nil
//            checkImage.icon(from: .Ionicon,
//                            code: "ios-circle-outline",
//                            imageSize: CGSizeMake(40, 40),
//                            ofSize: 40,
//                            color: UIColor.lightBlueColor())
            
        }
    }
    
    

    
    
    
    
    func showMoreOptionsMenu() {
        delegate?.showOptionsForAlbum(album)
    }

    
    
    func mediaUploadSuccessful(notification : NSNotification) {
        
        hideSpinningWheel()
        
        if let userInfo = notification.userInfo {
            
            if let successful = userInfo["success"] as? Bool {
                if successful {
                    NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                        name: kAlbumMediaUploadNotification,
                                                                        object: album)
                } else {
                    print("MyAlbumCN showRetryButton")
                    showRetryButton()
                }
            }
        }
    }

    func uploadSuccessful(notification : NSNotification) {
        
        hideSpinningWheel()

        if let userInfo = notification.userInfo {
            
            if let successful = userInfo["success"] as? Bool {
                if successful {
                    NSNotificationCenter.defaultCenter().removeObserver(self, name: kAlbumCreateNotification, object: album)
                } else {
                    print("MyAlbumCN showRetryButton")
                    showRetryButton()
                }
            }
        }
    }
    
    func showRetryButton() {
        albumImageView.titleNode.alpha = 1.0
        albumImageView.userInteractionEnabled = true
    }
    
    func hideRetryButton() {
        albumImageView.userInteractionEnabled = false
        albumImageView.titleNode.alpha = 0.0
    }
    
    
    func retryCreatingAlbumOrUploadingMedia() {
        print("retryCreatingAlbum")
        print("albumImageView.titleNode.alpha: \(albumImageView.titleNode.alpha )")
        print("albumImageView.titleNode.hidden: \(albumImageView.titleNode.hidden )")
        
        
        if !album.isUploading && (albumImageView.titleNode.alpha == 1.0 || albumImageView.titleNode.hidden == false)
        {
            hideRetryButton()
            showSpinningWheel()
            
            if album.id == nil {
                delegate?.uploadAlbum(album)
            } else if !album.lastUploadSuccessful {
                delegate?.retryUploadingMediaToAlbum(album)
            }
        }
    }
    

    func showSpinningWheel() {
        userInteractionEnabled = false
        activityIndicatorView.startAnimating()
        changeCellNodeAlpha(0.3)
    }
    
    func hideSpinningWheel() {
        print(" uploadAlbum hideSpinningWheel")
        userInteractionEnabled = true
        activityIndicatorView.stopAnimating()
        changeCellNodeAlpha(1.0)
    }
    
    
    func changeCellNodeAlpha(alpha: CGFloat) {

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: { 
            
            self.albumImageView.alpha = alpha
            self.photoTimeIntervalSincePostLabel.alpha = alpha
            self.photoTitleLabel.alpha = alpha
            self.moreOptionButton.alpha = alpha
            
        }, completion: nil)
    }
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        // Album photo and title - vertical stack
        
        
//        let albumImageWithInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: albumImageView)
        
        
        let albumDetailStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Start,
                                          children: [photoTitleLabel, photoTimeIntervalSincePostLabel])
        

        
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        moreOptionButton.preferredFrameSize = CGSizeMake(40, 40)
        
        moreOptionButton.borderWidth = 1.0
        moreOptionButton.borderColor = UIColor.redColor().CGColor
        moreOptionButton.cornerRadius = 20
        
        
        
        
        let albumStack = ASStackLayoutSpec(direction: .Horizontal,
                                                        spacing: 10,
                                                        justifyContent: .Start,
                                                        alignItems: .Center ,
                                                        children: [albumImageView, albumDetailStack, spacer, checkImage, moreOptionButton])
        
//        (8,15,8,15)
//        let f = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 15, 8, 15), child: albumStack)
        
        

        
    }
    
}