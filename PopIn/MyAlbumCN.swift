//
//  MyAlbumCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/8/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

protocol MyAlbumCNDelegate {
    func showMoreOptionsForObjectAtIndexPath(indexPath: NSIndexPath)
}

class MyAlbumCN: ASCellNode {
    
    
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
    let indexPath: NSIndexPath
    
    let albumImageView: ASImageNode //SNetworkImageNode
    let photoTimeIntervalSincePostLabel: ASTextNode
    let photoTitleLabel: ASTextNode
    
    let checkImage: ASImageNode
    var isSelected = false
    
    let moreOptionButton: ASButtonNode
    let _divider: ASDisplayNode

    let activityIndicatorView: UIActivityIndicatorView

    var uploadError: Bool?
    
    
    init(withAlbumObject albumModel: AlbumModel, atIndexPath indexPath: NSIndexPath) {
        
        album = albumModel
        
        self.indexPath = indexPath

        // Make images round
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

        
        
        albumImageView = ASImageNode()
        
        if let coverImage = album.coverPhotoImage {
            albumImageView.image = coverImage // album.coverPhotoURL

        } else {
            albumImageView.image = UIImage(named: album.coverPhoto!) // album.coverPhotoURL
        }
        
        albumImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        albumImageView.preferredFrameSize = CGSizeMake(66, 66)
        albumImageView.cornerRadius = 33.0
        
        albumImageView.flexShrink = false
        
        albumImageView.imageModificationBlock = largeRoundModBlock
        
        
        photoTimeIntervalSincePostLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.timeAttributedStringWithFontSize(AlbumTimeFontSize))
        
        
        
        
        photoTitleLabel = HAGlobalNode.createLayerBackedTextNodeWithString(album.titleAttributedStringWithFontSize(AlbumTitleFontSize))
        photoTitleLabel.maximumNumberOfLines = 1
        photoTitleLabel.flexShrink = true
        //        photoTitleLabel.truncationMode = .ByWordWrapping
        photoTitleLabel.truncationMode = .ByClipping
        
        
        
        
        checkImage = ASImageNode()
        checkImage.layerBacked = true
        
        
        checkImage.preferredFrameSize = CGSizeMake(30, 30)
        checkImage.cornerRadius = 15.0
        
        
        
        moreOptionButton = ASButtonNode()
        moreOptionButton.setImage(UIImage(named: "dot-more-7.png"), forState: .Normal)
        
        moreOptionButton.borderWidth = 2.0
        moreOptionButton.borderColor = UIColor.blackColor().CGColor
        moreOptionButton.cornerRadius = 16
        
        
        
        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        

        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.blackColor()

       
        
        super.init()
        

        
        addSubnode(albumImageView)
        addSubnode(photoTimeIntervalSincePostLabel)
        addSubnode(photoTitleLabel)
        addSubnode(checkImage)
        addSubnode(moreOptionButton)
        addSubnode(_divider)
    }
    
    
    
//    override var highlighted: Bool
    
//    override var selected: Bool {
//        
//        willSet {
//            print("changing from \(selected) to \(newValue)")
//        }
//        didSet {
//            print("changed from \(oldValue) to \(selected)")
//        }
//    }
    
    
    
    override func didLoad() {
        super.didLoad()
        
        moreOptionButton.addTarget(self, action: #selector(showMoreOptionsMenu), forControlEvents: .TouchUpInside)
        userSelected(isSelected)

//        albumImageView.view.addSubview(activityIndicatorView)
        view.addSubview(activityIndicatorView)
       
        
        hideSpinningWheel()
        if album.isUploading {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(uploadSuccessful), name:"kAlbumUploadNotification", object: album)
            

            showSpinningWheel()
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
        
        
        
        // ActivityIndicatorView setup
//        let boundSize = albumImageView.bounds.size
//        
//        activityIndicatorView.sizeToFit()
//        var refreshRect = activityIndicatorView.frame
//        
//        refreshRect.origin = CGPointMake((boundSize.width - activityIndicatorView.frame.size.width)/2.0, (boundSize.height - activityIndicatorView.frame.size.height) / 2.0)
//        
//        activityIndicatorView.frame = refreshRect
        
                activityIndicatorView.center = albumImageView.view.center
    }
    
    
    
    
    func userSelected(selected:Bool) {
        
        isSelected = selected
        if isSelected {
            checkImage.borderColor = UIColor.clearColor().CGColor
            checkImage.image = UIImage(named: "circle-tick-7.png")
            checkImage.backgroundColor =  UIColor.greenColor()
        } else {
            checkImage.borderColor = UIColor.lightGrayColor().CGColor
            checkImage.image = nil
            checkImage.backgroundColor =  UIColor.whiteColor()
        }
    }
    
    

    
    func showMoreOptionsMenu() {
        print("showMoreOptionsMenu")
        delegate?.showMoreOptionsForObjectAtIndexPath(indexPath)
    }

    
    
    func uploadSuccessful(successful: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "kAlbumUploadNotification", object: album)
        
        hideSpinningWheel()

        if !successful {
            uploadError = true // = "Could not make album at this time"
        }
    }
    
    func showSpinningWheel() {
        userInteractionEnabled = false
        activityIndicatorView.startAnimating()
        changeCellNodeAlpha(0.3)
    }
    
    func hideSpinningWheel() {
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