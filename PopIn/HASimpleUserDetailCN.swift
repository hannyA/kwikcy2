//
//  HASimpleUserDetailCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HASimpleUserDetailCN: ASCellNode {
    
    
    
    // Font sizes
    
    
    let topLabelSize: CGFloat = 14.0
    let topTextSize: CGFloat = 14.0
    let friendButtonSize: CGFloat = 14.0
    
    
    
    
    // Variables
    let userProfile: ProfileModel
    let userPic: ASImageNode // change to ASNetworkImageNode
    
    
    let friendsCountNode: HADoubleLabelButton
    
    let friendsButton: ASButtonNode
    var friendStatus: FriendshipStatus?
    
    let fullnameLabel: ASTextNode
    let verificationImage: ASImageNode
    
    let shortDescription: ASTextNode
    let domainWebLink: ASTextNode
    
    let activityIndicatorView: UIActivityIndicatorView

    
    init(withProfileModel profile: ProfileModel) {
        
        userProfile = profile
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.color = UIColor.blackColor()
        

        
        userPic = ASImageNode()
        userPic.image = UIImage(named: profile.user.userTestPic!)
        userPic.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
//        userPic.preferredFrameSize = CGSizeMake(128, 128)
//        userPic.flexShrink = true
//        userPic.cornerRadius = 64
//
        // userPic.imageModificationBlock = smallRoundModBlock
        
        print("finsihed coffee 3")

        
        // let friendsCountLabelText = HAGlobalNode.attributedString("289", textSize: kTextSizeXS)
        
        friendsCountNode = HADoubleLabelButton(withTitle: "289", andLabel: "friends")
        //        friendsCountNode.layerBacked = true
        
        
        // Friends Labels and Texts
        
        
        friendsButton = ASButtonNode()
        
        
        friendsButton.preferredFrameSize = CGSizeMake(200, 50)
        friendsButton.cornerRadius = 4.0
        friendsButton.contentEdgeInsets = UIEdgeInsetsMake(8, 45, 8, 45)
        friendsButton.flexGrow = true
        
        
        let fullnameLabelText = HAGlobalNode.attributedString(profile.user.fullName,
                                                              font: kTextSizeRegular,
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
        
    }
    
    
    
    
    override func didLoad() {
        super.didLoad()
        
        friendsButton.addTarget(self, action: #selector(changeFriendButton), forControlEvents: .TouchUpInside)
               
        view.addSubview(activityIndicatorView)

        friendStatus = randomFriendship()
        setupFriendButton()
    }
    
    
    override func layout() {
        super.layout()
        
        activityIndicatorView.center = friendsButton.view.center
    }

    func showSpinningWheel() {
        
        let normalTitle = HAGlobal.titlesAttributedString(" ", color: UIColor.whiteColor(), textSize: kTextSizeXS)

        friendsButton.setAttributedTitle(normalTitle, forState: .Normal)

        activityIndicatorView.startAnimating()
    }
    
    func hideSpinningWheel() {
        activityIndicatorView.stopAnimating()
    }
    
    
    
    func randomFriendship() -> FriendshipStatus {
        let options: [FriendshipStatus] = [.Nil, .Friends, .Pending, .Blocked]
        let randomNumber = Int(arc4random_uniform(UInt32(options.count)))
        let option = options[randomNumber]
        print("fefe = \(option)")
        return options[randomNumber]
    }

    
    enum FriendshipStatus {
        case Nil
        case Friends
        case Pending
        case Blocked
    }
    

    
    func changeFriendButton() {
        if friendStatus == .Nil {
            friendStatus = .Pending
        } else if friendStatus == .Pending {
            friendStatus = .Nil
        } else if friendStatus == .Friends {
            friendStatus = .Blocked
        } else if friendStatus == .Blocked {
            friendStatus = .Friends
        }
        
        // Server call simulation
        
        showSpinningWheel()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(kWebResponseDelayFast * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            
            
            self.hideSpinningWheel()

            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear , animations: {
                
                self.setupFriendButton()
                
                }, completion: nil)
        
        }
    }
    
    
    func setupFriendButton() {

        print("setupFriendButton")
        print("friendStatus == \(friendStatus)")
        let fontColor = UIColor.blackColor()
        
        if friendStatus == .Nil {
            
            print("friendStatus == .Nil")
            let normalTitle = HAGlobal.titlesAttributedString("+ FRIEND", color: fontColor, textSize: kTextSizeXS)

            friendsButton.backgroundColor = UIColor.whiteColor()
            friendsButton.borderColor = UIColor.redColor().CGColor
            friendsButton.borderWidth = 1.0
            friendsButton.setAttributedTitle(normalTitle, forState: .Normal)

        } else if friendStatus == .Pending {
            print("friendStatus == .Pending")

            let normalTitle = HAGlobal.titlesAttributedString("Pending", color: fontColor, textSize: kTextSizeXS)
            
            friendsButton.backgroundColor = UIColor.yellowColor()
            friendsButton.borderWidth = 1.0
            friendsButton.borderColor = UIColor.whiteColor().CGColor
            friendsButton.setAttributedTitle(normalTitle, forState: .Normal)
            
        }  else if friendStatus == .Friends {
            print("friendStatus == .Friends")

            let normalTitle = HAGlobal.titlesAttributedString("Block User", color: fontColor, textSize: kTextSizeXS)
            
            friendsButton.backgroundColor = UIColor.redColor()
            friendsButton.borderWidth = 1.0
            friendsButton.borderColor = UIColor.blackColor().CGColor
            friendsButton.setAttributedTitle(normalTitle, forState: .Normal)
        
        } else if friendStatus == .Blocked {
            print("friendStatus == .Blocked")

            let normalTitle = HAGlobal.titlesAttributedString("Unblock User", color: fontColor, textSize: kTextSizeXS)
            
            friendsButton.backgroundColor = UIColor.whiteColor()
            friendsButton.borderWidth = 1.0
            friendsButton.borderColor = UIColor.blackColor().CGColor
            friendsButton.setAttributedTitle(normalTitle, forState: .Normal)
        }
    }

    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let maxWidth = constrainedSize.max.width
        
        let picHeight = UIScreen.mainScreen().bounds.height*(2/5)
        userPic.preferredFrameSize = CGSizeMake(maxWidth, picHeight)
        
        let staticImage = ASStaticLayoutSpec(children: [userPic])
        
        
        //fullnameLabel
        
        var nameContents: [ASLayoutable] = [ fullnameLabel ]
        
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
        
        
        var mainContents: [ASLayoutable] = [ nameStack]
        
        if userProfile.user.domain != nil {
            mainContents.append(domainWebLink)
        }
        
        if userProfile.user.about != nil {
            mainContents.append(shortDescription)
        }
        
        let mainContentStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 2,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: mainContents)
        
        
        let friendsButtonInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 25, 0, 25), child: friendsButton)

        
        let friendInfoStack = ASStackLayoutSpec(direction: .Vertical,
                                          spacing: 10,
                                          justifyContent: .SpaceBetween ,
                                          alignItems: .Stretch ,
                                          children: [friendsCountNode, friendsButtonInset])
        
        friendInfoStack.flexGrow = true

        let friendInfoStackInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 2, 15), child: friendInfoStack)

        
        
        
        
        let bottomStackInset = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 15, 2, 15), child: mainContentStack)
        
        
        
        
        
        let wholeStack = ASStackLayoutSpec(direction: .Vertical,
                                           spacing: 20,
                                           justifyContent: .SpaceBetween ,
                                           alignItems: .Stretch ,
                                           children: [staticImage, bottomStackInset, friendInfoStackInset])
        

        return wholeStack
        
    }
    
    
    
}