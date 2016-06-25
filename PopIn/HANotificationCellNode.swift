//
//  HANotificationCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

protocol HANotificationCellNodeDelegate {
    func showUserProfile(userModel: UserModel)
}


class HANotificationCellNode: ASCellNode {
    
    var delegate: HANotificationCellNodeDelegate?

    let kAvatarCornerRadius: CGFloat = 44.0
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 7.0
    
    
    let userAvatarImageView: ASImageNode// ASNetworkImageNode
    let messageLabel: ASTextNode
    let acceptButton: ASButtonNode
    let _divider: ASDisplayNode
    
    
    let notificationModel: NotificationModel
    var acceptButtonHighlighted = false
    var friendshipStatus: NotificationModel.FriendshipStatus
    var notificationType: NotificationModel.NotificationType

    
    
    init(withNotificationObject notificationModel: NotificationModel) {
        
        
        self.notificationModel = notificationModel
        friendshipStatus = notificationModel.friendshipStatus
        notificationType = notificationModel.notificationType
        
        
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
        userAvatarImageView.image = UIImage(named: notificationModel.user.userTestPic! )
        userAvatarImageView.backgroundColor = UIColor.whiteColor()
        userAvatarImageView.preferredFrameSize = CGSizeMake(44, 44)
        userAvatarImageView.imageModificationBlock = smallRoundModBlock

        
        
        
        let attributedMessage = HAGlobal.titlesAttributedString(notificationModel.message,
                                                          color: UIColor.blackColor(),
                                                          textSize: kTextSizeXXS)
            
        
        
        let attributedTimestamp = HAGlobal.titlesAttributedString(notificationModel.timeStamp,
                                                            color: UIColor.lightGrayColor(),
                                                            textSize: kTextSizeXXS)
        
        let result = NSMutableAttributedString()
        result.appendAttributedString(attributedMessage)
        result.appendAttributedString(attributedTimestamp)
        
        
        
        
        messageLabel = HAGlobalNode.createLayerBackedTextNodeWithString(result)
        messageLabel.maximumNumberOfLines = 3
      

//
//        let timestampAttr = HAGlobal.titlesAttributedString(notificationModel.timeStamp,
//                                                            color: UIColor.lightGrayColor(),
//                                                            textSize: kTextSizeXXS)
//        
//        timeIntervalSinceRequestLabel = HAGlobalNode.createLayerBackedTextNodeWithString(timestampAttr)
        
        
        
        acceptButton = ASButtonNode()
        acceptButton.contentEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 10)
        acceptButton.cornerRadius = 4.0
        acceptButton.clipsToBounds = true

        let normalTitle = HAGlobal.titlesAttributedString("Accept",
                                                          color: UIColor.blackColor(),
                                                          textSize: kTextSizeXS)
        acceptButton.borderColor = UIColor.blackColor().CGColor
        acceptButton.borderWidth = 1.0
        acceptButton.setAttributedTitle(normalTitle, forState: .Normal)


        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        
        
        super.init()
        
        addSubnode(userAvatarImageView)
        addSubnode(messageLabel)
        addSubnode(acceptButton)

        addSubnode(_divider)
    }
    
    override func didLoad() {
        super.didLoad()

        userAvatarImageView.addTarget(self, action: #selector(showUserProfile), forControlEvents: .TouchUpInside)
        
        acceptButton.addTarget(self, action: #selector(acceptButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func showUserProfile() {
        delegate?.showUserProfile(notificationModel.user)
    }
    
    
//    func shouldShowButton() {
//
//        if notificationType == .FriendRequest {
//            
//            if friendshipStatus == .Nil {
//                
//                let normalTitle = HAGlobal.titlesAttributedString("Accept",
//                                                                  color: UIColor.blackColor(),
//                                                                  textSize: kTextSizeXS)
//                acceptButton.borderColor = UIColor.blackColor().CGColor
//                acceptButton.borderWidth = 1.0
//                acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//
//            } else if friendshipStatus == .Friends {
//                acceptButton.hidden = true
//            }
//        
//        }
//        
    
    
//        if notificationType == .Nil {
//            
//            let normalTitle = HAGlobal.titlesAttributedString("+ Friend", color: fontColor, textSize: kTextSizeXS)
//            acceptButton.backgroundColor = UIColor.whiteColor()
//            
//            acceptButton.borderColor = UIColor.blackColor().CGColor
//            acceptButton.borderWidth = borderWidth
//            acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//
//        } else if notificationModel.friendshipStatus == .Pending {
//            
//            let normalTitle = HAGlobal.titlesAttributedString("Pending", color: fontColor, textSize: kTextSizeXS)
//            
//            acceptButton.backgroundColor = UIColor.yellowColor()
//            acceptButton.borderWidth = 0.0
//            acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//
//        } else if notificationModel.friendshipStatus == .Friends {
//            
//            let normalTitle = HAGlobal.titlesAttributedString("Friends", color: fontColor, textSize: kTextSizeXS)
//            
//            acceptButton.backgroundColor = UIColor.greenColor()
//            acceptButton.borderWidth = 0.0
//            acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//
//            
//        } else { // Unfriended
//            
//            let normalTitle = HAGlobal.titlesAttributedString("+ Friend", color: fontColor, textSize: kTextSizeXS)
//            
//            acceptButton.backgroundColor = UIColor.redColor()
//            acceptButton.borderWidth = 0.0
//            acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//        }
//    }
    
    
    func acceptButtonPressed() {
        

        if notificationType == .FriendRequest {

            if friendshipStatus == .Nil {
               
                friendshipStatus = .Friends
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                    
                    let normalTitle = HAGlobal.titlesAttributedString("FRIENDS",
                        color: UIColor.blackColor(),
                        textSize: kTextSizeXS)
                    
                    self.acceptButton.backgroundColor = UIColor.greenColor()
                    self.acceptButton.borderColor = UIColor.whiteColor().CGColor
                    self.acceptButton.borderWidth = 1.0
                    self.acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
                    
                }, completion: nil)
                
            } else if friendshipStatus == .Friends {
//                friendshipStatus = .Nil
//                UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
//                    
//
//                    let normalTitle = HAGlobal.titlesAttributedString("Accept",
//                                                                      color: UIColor.blackColor(),
//                                                                      textSize: kTextSizeXS)
//                    self.acceptButton.borderColor = UIColor.blackColor().CGColor
//                    self.acceptButton.borderWidth = 1.0
//                    self.acceptButton.setAttributedTitle(normalTitle, forState: .Normal)
//                    
//                }, completion: nil)


            }
            
        }
        
        
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

        
        let buttonWidth = constrainedSize.max.width/6
        
        userAvatarImageView.spacingAfter = 8.0

        
        acceptButton.preferredFrameSize = CGSizeMake(buttonWidth, 28)
        acceptButton.alignSelf = .End
        
        
        
        let messageNodeWidth = constrainedSize.max.width - buttonWidth - 44 - 40
        
        messageLabel.preferredFrameSize = CGSizeMake(messageNodeWidth, 40)
        messageLabel.spacingAfter = 8.0
        messageLabel.flexShrink = true
        

//        let staticMessageLabelSpec = ASStaticLayoutSpec(children: [messageLabel])

        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
            
        
        var contents:[ASLayoutable] = [userAvatarImageView, messageLabel ]

        
        if notificationType == .FriendRequest {

            if friendshipStatus == .Nil {
                contents.append(spacer)
                contents.append(acceptButton)

            }
        }

        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
                                              spacing: 0,
                                              justifyContent: .Start,
                                              alignItems: .Center,
                                              children: contents)
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides), child: fullStack)
        
    
    }
    
}
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
