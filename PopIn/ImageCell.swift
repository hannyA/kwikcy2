//
//  ImageCell.swift
//  PopIn
//
//  Created by Hanny Aly on 6/17/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol ImageCellDelegate {
    func scrollToMe()
}

class ImageCell: ASCellNode {
    
    let userAvatarImageView: ASImageNode
    
    var delegate: ImageCellDelegate?
//    var isSelected: Bool
    let elementSize: CGSize
    let panGesture: UIPanGestureRecognizer
    
    init(withImage image: UIImage?, size: CGSize, gesture: UIPanGestureRecognizer, forUser model: UserUploadFriendModel) {
        
        elementSize = size
        userAvatarImageView = ASImageNode()
        panGesture = gesture
    
        super.init()

        
        userAvatarImageView.image = image
        userAvatarImageView.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        userAvatarImageView.preferredFrameSize = elementSize
        userAvatarImageView.cornerRadius = 25.0
        userAvatarImageView.imageModificationBlock = { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            UIBezierPath(roundedRect: rect, cornerRadius: self.elementSize.width).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        
        
        print("ImageCell For horizontal ImageNode 1")
        model.albumHorizontalImageClosure = { image in
            print("ImageCell For horizontal ImageNode 2")
            self.userAvatarImageView.image = image
        }

        
        if userAvatarImageView.image == nil {
            print("ImageCell For horizontal ImageNode 3")
            
            if let downloadedFile = model.downloadFileURL {
                print("ImageCell For horizontal ImageNode 4")
                
                if let data = NSData(contentsOfURL: downloadedFile) {
                    userAvatarImageView.image = UIImage(data: data)
                }
            }
        }

        
        addSubnode(userAvatarImageView)

    }
    
    
    
    
    override func didLoad() {
        super.didLoad()
        
        userAvatarImageView.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)
        view.addGestureRecognizer(panGesture)
    }
    
    func buttonTapped() {
        
        userAvatarImageView.selected = !userAvatarImageView.selected

        if userAvatarImageView.selected {
            print("userAvatarImageView Selected")

        } else {
            print("Not Selected")
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        userAvatarImageView.preferredFrameSize = CGSizeMake(elementSize.width, elementSize.height)
        return ASStaticLayoutSpec(children: [userAvatarImageView])
    }
    
}


