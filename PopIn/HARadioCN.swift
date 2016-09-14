//
//  HANotificationsCN.swift
//  PopIn
//
//  Created by Hanny Aly on 8/23/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//
//

import AsyncDisplayKit


class HARadioCN: ASCellNode {
    
    let leftImageNode: ASImageNode
    let textNode: ASTextNode
    var rightImageNode: ASImageNode
    
    var hasTopDivider: Bool
    var hasBottomDivider: Bool
    
    let topDivider   : ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    
    let spiningWheel: UIActivityIndicatorView
    
    
    convenience init(withTitle title: String, isHeader header: Bool, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        self.init(withLeftImage: nil, title: title, rightImage: nil, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    convenience init(withTitle title: String, rightImage: UIImage, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool)  {
        
        self.init(withLeftImage: nil, title: title, rightImage: rightImage, hasTopDivider: _topDivider, hasBottomDivider: _bottomDivider)
    }
    
    
    
    init(withLeftImage leftImage: UIImage?, title: String, rightImage: UIImage?, hasTopDivider _topDivider: Bool, hasBottomDivider _bottomDivider: Bool) {
        
        hasTopDivider    = _topDivider
        hasBottomDivider = _bottomDivider
        
        
        leftImageNode = ASImageNode()
        leftImageNode.image = leftImage // ?? UIImage()
        leftImageNode.layerBacked = true
        
        textNode = ASTextNode()
        textNode.layerBacked = true
        
        textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                    color: UIColor.blackColor(),
                                                                    textSize: kTextSizeXS)
        
        
        rightImageNode = ASImageNode()
        rightImageNode.image = rightImage // ?? UIImage()
        
        rightImageNode.borderColor = UIColor.grayColor().CGColor
        rightImageNode.borderWidth = 2.0
        rightImageNode.cornerRadius = 35.0/2
//        rightImageNode.layerBacked = true
        
        // Hairline cell separator
        topDivider = ASDisplayNode()
        topDivider.layerBacked = true
        topDivider.backgroundColor = UIColor.lightGrayColor()
        
        // Hairline cell separator
        bottomDivider = ASDisplayNode()
        bottomDivider.layerBacked = true
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        
        spiningWheel = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spiningWheel.color = UIColor.blackColor()
        
        
        super.init()
        
        if let _  = leftImage {
            addSubnode(leftImageNode)
        }
        addSubnode(textNode)
        
        if let _  = rightImage {
            addSubnode(rightImageNode)
        }
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    
    func resetRightImage(image: UIImage?, color: UIColor) {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveLinear, animations: {
            
            self.rightImageNode.borderColor = color.CGColor
            
            self.rightImageNode.image = image
            
            }, completion: nil)
    }
    
    
    
    
    override func didLoad() {
        super.didLoad()
        view.addSubview(spiningWheel)
    }
    
    
    
    override func layout() {
        super.layout()
        
        spiningWheel.center = rightImageNode.view.center

        if hasTopDivider {
            
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            
            let widthParts = calculatedSize.width/10
            let width = widthParts * 8
            //        let leftInset = widthParts*1.5
            topDivider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
        }
    }
    
    
    func isNotMakeingNetworkCall() -> Bool {
        
        return userInteractionEnabled
    }
    
    func makingNetworkCall() {
        userInteractionEnabled = false
        spiningWheel.startAnimating()
        changeCellNodeAlpha(0.3)
    }
    
    func returnedNetworkCall() {
        userInteractionEnabled = true
        spiningWheel.stopAnimating()
        changeCellNodeAlpha(1.0)
    }
    
    
    
    func changeCellNodeAlpha(alpha: CGFloat) {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            
            self.leftImageNode.alpha  = alpha
            self.textNode.alpha       = alpha
            self.rightImageNode.alpha = alpha
        }, completion: nil)
    }
    
    
    
    
    
    let topInset    :CGFloat = 10.0
    let leftInset   :CGFloat = 15
    let rightInset  :CGFloat = 10.0
    let bottomInset :CGFloat = 7
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        
        var contents = [ASLayoutable]()
        
        if let _ = leftImageNode.image {
            contents.append(leftImageNode)
        }
        contents.append(textNode)
        
        if let _ = rightImageNode.image {
            contents.append(spacer)
            contents.append(rightImageNode)
        }
        
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: contents)
        
        
        let insets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
        
        return textWrapper
    }
    
    
    
    
}