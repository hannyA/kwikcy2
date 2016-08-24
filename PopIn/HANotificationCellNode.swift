//
//  HANotificationCellNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import pop
import SwiftyDrop
import ChameleonFramework



protocol HANotificationCellNodeDelegate {
    func showUserProfile(userModel: UserSearchModel)
    func deleteRowForNotification(notif: HANotificationModel)
    func showErrorMessage(messsage: String)
}


class HANotificationCellNode: ASCellNode, UserSearchModelDelegate {
    
    var delegate: HANotificationCellNodeDelegate?

    let kAvatarCornerRadius: CGFloat = 44.0
    
    let kInsetTitleTop:     CGFloat = 10.0
    let kInsetTitleBottom:  CGFloat = 10.0
    let kInsetTitleSides:   CGFloat = 7.0
    
    let actionButtonBorder: CGFloat = 1.0

    
    let userAvatarImageView: ASImageNode
    let messageLabel: ASTextNode

    let actionButton: ASButtonNode
    let _divider: ASDisplayNode
    
    
    let notificationModel: HANotificationModel
    var acceptButtonHighlighted = false
    
    let activityIndicatorView: UIActivityIndicatorView
    
    init(withNotificationObject notificationModel: HANotificationModel) {
        
        self.notificationModel = notificationModel

        userAvatarImageView = ASImageNode()
        userAvatarImageView.backgroundColor = UIColor.whiteColor()
        
        
        
        let attributedMessage = notificationModel.attributedMessageString()
            
//        maybe try imageNode = "block" image
//            backgroundImageNode = "person"
//        
        // winner is block
        // report problem, error, warning, cancel, do not disturn, do not disturn on\
        // thumb down
        
        // person add
        
        messageLabel = HAGlobalNode.createLayerBackedTextNodeWithString(attributedMessage)
        messageLabel.maximumNumberOfLines = 2
      
        
        actionButton = ASButtonNode()
        actionButton.cornerRadius = 4.0
        actionButton.clipsToBounds = true

        let actionButtonInfo = notificationModel.imageForNotificationType()
        
        actionButton.contentSpacing = 0.0
        actionButton.setAttributedTitle(actionButtonInfo.title, forState: .Normal)
        actionButton.setImage(actionButtonInfo.image, forState: .Normal)
        actionButton.setBackgroundImage(actionButtonInfo.backgroundImage, forState: .Normal)
        
        actionButton.borderColor = actionButtonInfo.borderColor.CGColor
        actionButton.backgroundColor = actionButtonInfo.backgroundColor
        actionButton.borderWidth = 1.0

        
        // Hairline cell separator
        _divider = ASDisplayNode()
        _divider.backgroundColor = UIColor.lightGrayColor()
        
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.blackColor()
        
        
        
        super.init()
        

        self.notificationModel.otherUser.delegate = self

        
        notificationModel.otherUser.avatarImageClosure = { image in
            self.userAvatarImageView.image = image
        }
                
        if userAvatarImageView.image == nil {
            print("userAvatarImageView.image")
            
            if let downloadedFile = notificationModel.otherUser.downloadFileURL {
                if let data = NSData(contentsOfURL: downloadedFile) {
                    userAvatarImageView.image = UIImage(data: data)
                }
            }
        }
        
        addSubnode(userAvatarImageView)
        addSubnode(messageLabel)
        addSubnode(actionButton)
        addSubnode(_divider)
    }
    
    
    
    
    override func didLoad() {
        super.didLoad()
        
        userAvatarImageView.addTarget(self, action: #selector(showUserProfile), forControlEvents: .TouchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), forControlEvents: .TouchUpInside)
        
        view.addSubview(activityIndicatorView)
    
    }
    
    override func layout() {
        super.layout()
        
        // Manually layout the divider.
        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale
        
        let width = calculatedSize.width * (4.0/5)
        let origin = (calculatedSize.width - width ) / 2
        
        _divider.frame = CGRectMake(origin, 0, width, pixelHeight)
        
        activityIndicatorView.center = actionButton.view.center
    }
    
    

    
    func didUpdateFriendStatus() {
        changeButtonForSuccessfulFriendStatusUpdate()
    }
    
    func showUserProfile() {
        delegate?.showUserProfile(notificationModel.otherUser)
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func disableCellNode() {
        userInteractionEnabled = false
        view.alpha = 0.5

    }
    
    func enableCellNode() {
        userInteractionEnabled = true
        view.alpha = 1.0
    }
    
    func showSpinningWheel() {
        
        activityIndicatorView.startAnimating()
    }
    
    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
    }
    
    
    
    
    func actionButtonPressed() {
        
        print("action button pressed")
        
        switch notificationModel.type {

        case .SentFriendRequest: // We canceled
            
            disableCellNode()
            showSpinningWheel()
            
            let action = HANotificationModel.NotificationResponseActionType.Cancel.rawValue
            let id = notificationModel.id
            
            print("SentFriendRequest action: \(action), id: \(id)")

            notificationModel.otherUser.lambdaNotificationAction(action, notificationId: id, completionClosure: { (successful, errorMessage, friendStatus) in
                
                self.hideSpinningWheel()

                if successful { // We canceled and will delete row
                    
                    UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                       
                        self.changeButtonForSuccessfulFriendStatusUpdate()
                        
                        }, completion: { (success) in
                            self.delay(0.2, closure: {
                                self.delegate?.deleteRowForNotification(self.notificationModel)
                            })
                        }
                    )
                } else {
                    self.enableCellNode()
                    self.delegate?.showErrorMessage("Couldn't cancel request at this time. Try again shortyly")
                }
            })
            

        case .ReceivedFriendRequest: // We accept
            
            if notificationModel.otherUser.friendStatus == .ReceivedFriendRequest ||
                notificationModel.otherUser.friendStatus == .Blocking {
                
                print("notificationModel.otherUser.friendStatus: \(notificationModel.otherUser.friendStatus)")

                // Change button from checkmark to Friends or + Friends to Friends
                // Do we delete? Or let user option to block?
                
                self.disableCellNode()
                self.showSpinningWheel()
                
                let action = HANotificationModel.NotificationResponseActionType.AcceptFriendRequest.rawValue
                let id = notificationModel.id
                
                notificationModel.otherUser.lambdaNotificationAction(action, notificationId: id, completionClosure: { (successful, errorMessage, friendStatus) in
                    
                    self.enableCellNode()
                    self.hideSpinningWheel()
                    
                    if successful {
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            self.changeButtonForSuccessfulFriendStatusUpdate()

                            
                        }, completion: nil)
                    }
                    else {
                        //TODO: Report an error to the user
                        self.delegate?.showErrorMessage("Unable to accept \(self.notificationModel.otherUser.userName)'s friend request. Try again shortly")
                    }
                })
            } else {
                print("notificationModel.otherUser.friendStatus: \(notificationModel.otherUser.friendStatus)")

                return ;
                
                print("Blocked user")
                
                self.disableCellNode()
                self.showSpinningWheel()
                
                let action = HANotificationModel.NotificationResponseActionType.BlockUser.rawValue
                let id = notificationModel.id
                
                notificationModel.otherUser.lambdaNotificationAction(action, notificationId: id, completionClosure: { (successful, errorMessage, friendStatus) in
                    
                    self.enableCellNode()
                    self.hideSpinningWheel()
                    
                    if successful {
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                            
                            self.changeButtonForSuccessfulFriendStatusUpdate()
                            
                            }, completion: nil)
                    }
                    else {
                        self.delegate?.showErrorMessage("You've blocked \(self.notificationModel.otherUser.userName)")
                    }
                })
            }

            
        case .FriendAcceptedRequest: // We do nothing... Maybe later we let users to unfriend or block
            
            return // for now, later we can let user block from here
                
            print("FriendAcceptedRequest button pressed")

            // Should allow user the option to open camera there? Maybe not
            // Let user press OK and clear out message
            
            
            self.disableCellNode()
            self.showSpinningWheel()
            
            let action = HANotificationModel.NotificationResponseActionType.BlockUser.rawValue
            let id = notificationModel.id
            
            
            notificationModel.otherUser.lambdaNotificationAction(action, notificationId: id, completionClosure: { (successful, errorMessage, friendStatus) in

                
                self.enableCellNode()
                self.hideSpinningWheel()
                
                
                if successful {
                    
                    UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                        
                        self.changeButtonForSuccessfulFriendStatusUpdate()

                    }, completion: nil)
                    
                } else {
                    
                    //TODO: Report an error to the user
                    print("Somehow report an error")
                }
            })
        }
    }
    
    
    
    func changeButtonForSuccessfulFriendStatusUpdate() {
        
        switch notificationModel.type {
        case .SentFriendRequest:
            
            let newColor = UIColor.flatRedColorDark()
            
            self.actionButton.imageNodeIcon(from: .MaterialIcon,
                                            code: "do.not.disturb.on",
                                            imageSize: CGSizeMake(30, 30),
                                            ofSize: 30,
                                            color: newColor,
                                            forState: .Normal)
            
            self.actionButton.borderColor = newColor.CGColor
            
            self.actionButton.borderWidth = self.actionButtonBorder
            
        case .ReceivedFriendRequest:
            
            self.actionButton.contentSpacing = 0.0

            if notificationModel.otherUser.friendStatus == .Friends {
                self.actionButton.contentSpacing = 0.0
                
                self.actionButton.titleNodeIcon(from: .MaterialIcon,
                                                code: "person",
                                                ofSize: 35,
                                                color: UIColor.flatWhiteColor(),
                                                forState: .Normal)
                
                self.actionButton.imageNodeIcon(from: .MaterialIcon,
                                                code: "check",
                                                imageSize: CGSizeMake(10, 10),
                                                ofSize: 10,
                                                color: UIColor.flatWhiteColor(),
                                                forState: .Normal)
                
                self.actionButton.setBackgroundImage(nil, forState: .Normal)
                
                self.actionButton.backgroundColor = UIColor.flatGreenColor()
                self.actionButton.borderColor = UIColor.clearColor().CGColor
          
            } else {
            
                self.actionButton.titleNodeIcon(from: .MaterialIcon,
                                                code: "block",
                                                ofSize: 30,
                                                color: UIColor.flatRedColor(),
                                                forState: .Normal)
                
                self.actionButton.backgroundImageNodeIcon(from: .MaterialIcon,
                                                          code: "person",
                                                          imageSize: CGSizeMake(30, 30),
                                                          ofSize: 30,
                                                          color: UIColor.flatBlackColor())
                
                self.actionButton.backgroundImageNode.contentMode = .ScaleAspectFit
                self.actionButton.setImage(nil, forState: .Normal)
                
                
                self.actionButton.backgroundColor = UIColor.whiteColor()
                self.actionButton.borderColor = UIColor.clearColor().CGColor
            }
            
        case .FriendAcceptedRequest:
            
            break
        }
        
    }
    

    
    
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let maxWidth = constrainedSize.max.width
        
        let avatarWidth = maxWidth / 7
        let buttonWidth = maxWidth / 7

        
        // Make images round
        userAvatarImageView.imageModificationBlock =  { image in
            var modifiedImage: UIImage
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
            
            
            UIBezierPath(roundedRect: rect, cornerRadius: avatarWidth).addClip()
            
            image.drawInRect(rect)
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return modifiedImage
        }

        
        
        let spaceAfterViews: CGFloat = 8.0
        
        
        userAvatarImageView.preferredFrameSize = CGSizeMake(avatarWidth, avatarWidth)
        userAvatarImageView.spacingAfter = spaceAfterViews
        
        
        let extraSpace: CGFloat = avatarWidth + buttonWidth + (2 * spaceAfterViews) + (2 * kInsetTitleSides) + (2 * actionButtonBorder)

        
        let messageNodeWidth:CGFloat = maxWidth - extraSpace //40

        messageLabel.preferredFrameSize = CGSizeMake(messageNodeWidth, 40)
        messageLabel.spacingAfter = spaceAfterViews
        messageLabel.flexShrink = true
        
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        actionButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonWidth * (3/5))  // was 40
        actionButton.alignSelf = .End
        
        
        let fullStack = ASStackLayoutSpec(direction: .Horizontal,
                                              spacing: 0,
                                              justifyContent: .Start,
                                              alignItems: .Center,
                                              children: [userAvatarImageView, messageLabel, spacer, actionButton ])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(kInsetTitleTop, kInsetTitleSides, kInsetTitleBottom, kInsetTitleSides), child: fullStack)
    }
}
