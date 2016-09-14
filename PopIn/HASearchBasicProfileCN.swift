//
//  HASearchBasicProfileCN.swift
//  PopIn
//
//  Created by Hanny Aly on 7/12/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



protocol HASearchBasicProfileCNDelegate {
    func showErrorMessage(messsage: String)
}

class HASearchBasicProfileCN: ASCellNode {
    
    
    
    var delegate: HASearchBasicProfileCNDelegate?
    // Font sizes
    
    
    let topLabelSize: CGFloat = 14.0
    let topTextSize: CGFloat = 14.0
    let friendButtonSize: CGFloat = 14.0
    
    
    // Variables
    let userProfile         : UserSearchModel
//    let userPic             : ASImageNode
    
    
    let friendsCountNode    : HADoubleLabelButton
    
    let friendsButton       : ASButtonNode

    
    let fullnameLabel       : ASTextNode
    let verificationImage   : ASImageNode
    
    let shortDescription    : ASTextNode
    let domainWebLink       : ASTextNode
    
    let activityIndicatorView: UIActivityIndicatorView
    
    
    init(withProfileModel profile: UserSearchModel) {
        
        userProfile = profile
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.color = UIColor.whiteColor()
        
        
        
        print("finsihed coffee 2")

        
        var friendCount = "0"
       
        if let count = profile.friendsCount {
            print("Friend count is not null")
            friendCount = "\(count)"
        }
        
        
//        let friendsCountLabelText = HAGlobalNode.attributedString(friendCount, textSize: kTextSizeXS)
        
        friendsCountNode = HADoubleLabelButton(withTitle: friendCount, andLabel: "friends")
        
        
        // Friends Labels and Texts
        
        friendsButton = ASButtonNode()
        
        friendsButton.cornerRadius = 4.0
        friendsButton.contentEdgeInsets = UIEdgeInsetsMake(8, 45, 8, 45)
        friendsButton.flexGrow = true
        

        
        
        let fullnameLabelText = HAGlobalNode.attributedString(userProfile.fullName ?? "",
                                                              font: kTextSizeRegular,
                                                              text: .BlackLabel)
        
        fullnameLabel = HAGlobalNode.createLayerBackedTextNodeWithString( fullnameLabelText )
        
        
        
        
        verificationImage = ASImageNode()
        verificationImage.layerBacked = true

        verificationImage.icon(from: .MaterialIcon,
                               code: "verified.user",
                               imageSize: CGSizeMake(12, 12),
                               ofSize: 12,
                               color: UIColor.flatSkyBlueColor())
        
        
        
        let shortDescriptionText = HAGlobalNode.attributedString(userProfile.about ?? "",
                                                                 font: 14,
                                                                 text: .BlackLabel)
        
        shortDescription = HAGlobalNode.createLayerBackedTextNodeWithString(shortDescriptionText)
        
        
        
        let domainWebLinkText = HAGlobalNode.attributedString(userProfile.domain ?? "",
                                                              font: 14,
                                                              text: .BlackLabel)
        domainWebLink = HAGlobalNode.createLayerBackedTextNodeWithString(domainWebLinkText)
    
        super.init()
        
        
        addSubnode(friendsCountNode)
        addSubnode(friendsButton)
        addSubnode(fullnameLabel)
        addSubnode(verificationImage)
        addSubnode(shortDescription)
        addSubnode(domainWebLink)
    }
    
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    

    func disableFriendButton() {
        
        friendsButton.userInteractionEnabled = false
        friendsButton.alpha = 0.5
    }
    
    
    func enableFriendButton() {
        
        friendsButton.userInteractionEnabled = true
        friendsButton.alpha = 1.0
    }
    

    
    func actionJackson() {
        
        print("Action Jackson Pressed")
        
        disableFriendButton()
        showSpinningWheel()
        
        
        let shouldTestOut = false
        
        if shouldTestOut && self.userProfile.friendStatus == .ReceivedFriendRequest {
            
            self.delay(5.0) {
                self.delegate?.showErrorMessage("Never gonna give you up")
                
                self.enableFriendButton()
                self.hideSpinningWheel()
                return
            }
        }
        
            
        self.userProfile.changeFriendshipStatus { (success, errorMessage,  newStatus) in
           
            self.hideSpinningWheel()
            
            if let errorMessage  = errorMessage {
                self.delegate?.showErrorMessage(errorMessage)
                self.enableFriendButton()

            } else {
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                    
                    print("will setupFriendButton")
                    
                    self.setupFriendButton()

                    }, completion: { (done) in
                        self.enableFriendButton()
                })
            }
        }
    
    }
    
    
    
    // Bubble chat, action jackson
    
    
    override func didLoad() {
        super.didLoad()
        
        friendsButton.addTarget(self, action: #selector(actionJackson), forControlEvents: .TouchUpInside)
        setupFriendButton()
        view.addSubview(activityIndicatorView)
    }
    
    
    override func layout() {
        super.layout()
        activityIndicatorView.center = friendsButton.view.center
    }
    

    func showSpinningWheel() {
        activityIndicatorView.startAnimating()
    }
    
    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
    }
    
    
    
    func setupFriendButton() {
    
        print("setupFriendButton")
        print("friendStatus == \(userProfile.friendStatus)")
    
        
        switch userProfile.friendStatus {
        case .SentFriendRequest:
            print("friendStatus == SentFriendRequest ")
            
            
            
            
            let backgroundColor      = UIColor.flatSkyBlueColor()
            let borderColor          = UIColor.clearColor()
            let textColor            = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor,
                                               isFlat: true)
            let textColorHighlighted = UIColor(complementaryFlatColorOf: textColor)
            
            
            let normalTitle = HAGlobal.titlesAttributedString("Request Sent",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            let highlightedTitle = HAGlobal.titlesAttributedString("Request Sent",
                                                              color: textColorHighlighted,
                                                              textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            
            let activityWheelColor = UIColor(complementaryFlatColorOf: textColor)

            activityIndicatorView.color = activityWheelColor
            

            
            
        case .NoneExist:
        
            print("friendStatus == .NoneExist")
            
            
            let backgroundColor      = UIColor.flatWhiteColor()
            let borderColor          = UIColor.flatBlackColor()
           
            let textColor            = UIColor.flatBlackColor()
            let textColorHighlighted = UIColor.flatGrayColorDark()
            
            
            let normalTitle = HAGlobal.titlesAttributedString("+ FRIEND",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            
            let highlightedTitle = HAGlobal.titlesAttributedString("+ FRIEND",
                                                                color: textColorHighlighted,
                                                                textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
        
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            let activityWheelColor = UIColor(complementaryFlatColorOf: textColor)

            activityIndicatorView.color = activityWheelColor
            
            
            
            
        case .Blocking:
            print("friendStatus == .BLOCKING")
            
            
            let backgroundColor      = UIColor.flatRedColor()
            let borderColor          = UIColor.clearColor()
            let textColor            = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor,
                                               isFlat: true)
            let textColorHighlighted = UIColor(complementaryFlatColorOf: textColor)
            
            
            let normalTitle = HAGlobal.titlesAttributedString("User Blocked",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            let highlightedTitle = HAGlobal.titlesAttributedString("User Blocked",
                                                                color: textColorHighlighted,
                                                                textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            
            let activityWheelColor = UIColor(complementaryFlatColorOf: textColor)
            activityIndicatorView.color = activityWheelColor
            
            
            
        case .Friends:

            print("friendStatus == .FRIENDS")
            
            let backgroundColor      = UIColor.flatGreenColor()
            let borderColor          = UIColor.clearColor()
            let textColor            = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor,
                                               isFlat: true)
            let textColorHighlighted = UIColor(complementaryFlatColorOf: textColor)
            
            
            let normalTitle = HAGlobal.titlesAttributedString("Friends",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            let highlightedTitle = HAGlobal.titlesAttributedString("Friends",
                                                                color: textColorHighlighted,
                                                                textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            let activityWheelColor = UIColor(complementaryFlatColorOf: textColor)

            activityIndicatorView.color = activityWheelColor
            
            friendsButton.userInteractionEnabled = false

            
        case .ReceivedFriendRequest:
            print("friendStatus == .RECEIVED_FRIEND_REQUEST")
            
            let backgroundColor      = UIColor.flatYellowColor()
            let borderColor          = UIColor.clearColor()
            let textColor            = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor,
                                               isFlat: true)
            let textColorHighlighted = UIColor(complementaryFlatColorOf: textColor)
            
            
            let normalTitle = HAGlobal.titlesAttributedString("Accept Request",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            let highlightedTitle = HAGlobal.titlesAttributedString("Accept Request",
                                                                color: textColorHighlighted,
                                                                textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            let activityWheelColor = UIColor(complementaryFlatColorOf: textColor)
            
            
            activityIndicatorView.color = activityWheelColor
            
        case .Unknown:
            print("friendStatus == .UNKNOWN")
            
            friendsButton.hidden = true
            
            let backgroundColor      = UIColor.flatOrangeColor()
            let borderColor          = UIColor.clearColor()
            let textColor            = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor,
                                               isFlat: true)
            let textColorHighlighted = UIColor(complementaryFlatColorOf: textColor)
            
            
            let normalTitle = HAGlobal.titlesAttributedString("Error",
                                                              color: textColor,
                                                              textSize: kTextSizeXS)
            
            let highlightedTitle = HAGlobal.titlesAttributedString("Error",
                                                                color: textColorHighlighted,
                                                                textSize: kTextSizeXS)
            
            friendsButton.setAttributedTitle(normalTitle,       forState: .Normal)
            friendsButton.setAttributedTitle(highlightedTitle,  forState: .Highlighted)
            friendsButton.setAttributedTitle(normalTitle,       forState: .Selected)
            
            friendsButton.backgroundColor = backgroundColor
            friendsButton.borderColor = borderColor.CGColor
            friendsButton.borderWidth = 1.0
            
            let activityWheelColor = UIColor(contrastingBlackOrWhiteColorOn: textColor,
                                             isFlat: true)
            activityIndicatorView.color = activityWheelColor
            
            
            // Nothing we can do with it
            friendsButton.userInteractionEnabled = false
            
        }
    }
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let maxWidth = constrainedSize.max.width
      
        verificationImage.preferredFrameSize = CGSizeMake(12, 12)
//        fullnameLabel.preferredFrameSize = CGSizeMake(100, 50)

        
        // 1) Setup first row - Name, verification, friends count
        var nameContents: [ASLayoutable] = [ fullnameLabel ]
        
        if let verified = userProfile.verified {
            if verified {
                verificationImage.spacingBefore = 3.0
                nameContents.append(verificationImage)
            }
        }
        
        friendsCountNode.spacingBefore = 10.0
        nameContents.append(friendsCountNode)
        
        
        let nameStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing:0,
                                          justifyContent: .Start,
                                          alignItems: .End,
                                          children: nameContents)
        nameStack.spacingBefore = 10.0
        
        
        
        /* 2) Setup vertical items - FirstRow,
         *                           website,
         *                           bio,
         *                           friend button
         * 
         */
        var mainContents: [ASLayoutable] = [ nameStack ]
        
        if userProfile.domain != nil {
            mainContents.append(domainWebLink)
        }
        
        if userProfile.about != nil {
            mainContents.append(shortDescription)
        }
        
        if let myGuid = Me.sharedInstance.guid() {
            if userProfile.guid != myGuid {
                friendsButton.spacingBefore = 10.0
                friendsButton.preferredFrameSize = CGSizeMake(maxWidth - 50, 50)

                mainContents.append(friendsButton)
            }
        }
        
        
        
        
        let mainContentStack = ASStackLayoutSpec(direction: .Vertical,
                                                 spacing: 2,
                                                 justifyContent: .Start,
                                                 alignItems: .Center,
                                                 children: mainContents)
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 4, 15),
                                                     child: mainContentStack)

        
        return ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 20,
                                           justifyContent: .SpaceBetween ,
                                           alignItems: .Stretch ,
                                           children: [ inset])
       
        
        
        
        
        var lowerHalfStack:[ASLayoutable] = []
        
        if let myGuid = Me.sharedInstance.guid() {
            if userProfile.guid != myGuid {
                lowerHalfStack.append(friendsButton)
            }
        }
        
        
        let friendInfoStack = ASStackLayoutSpec(direction: .Vertical,
                                                spacing: 10,
                                                justifyContent: .SpaceBetween ,
                                                alignItems: .Stretch ,
                                                children: lowerHalfStack)
        friendInfoStack.flexGrow = true
        
        let friendInfoStackInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 2, 15), child: friendInfoStack)
        
        let bottomStackInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 2, 15), child: mainContentStack)
    
        let wholeStack = ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 20,
                                           justifyContent: .SpaceBetween ,
                                           alignItems: .Stretch ,
                                           children: [ bottomStackInset, friendInfoStackInset])
        return wholeStack
        
    }
    
    
    
}