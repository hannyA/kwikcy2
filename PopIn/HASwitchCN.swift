//
//  HASwitchCN.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class HASwitchCN: ASCellNode {
    
    let topHeaderInset:CGFloat = 25
    let topCellInset:CGFloat = 12.0
    
    let leftInset:CGFloat = 15
    let rightInset:CGFloat = 10.0
    let bottomInset:CGFloat = 12.0
    
    
    let textNode: ASTextNode
//    let switchNode: HASwitchNode
    
    let isHeader: Bool
    let hasDivider: Bool
    
    let topDivider: ASDisplayNode
    let bottomDivider: ASDisplayNode
    
    let switchView: UISwitch

    
    
    init(withTitle title: String, isHeader header: Bool, hasDivider _divider: Bool) {
        
        switchView = UISwitch()
        
        switchView.onTintColor = UIColor.greenColor()
        isHeader = header
        hasDivider = _divider
        
        
        textNode = ASTextNode()
        textNode.layerBacked = true
        
        
        
        if isHeader {
            textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                        color: UIColor.lightGrayColor(),
                                                                        textSize: kTextSizeXS)
            
        } else {
            textNode.attributedString = HAGlobal.titlesAttributedString(title,
                                                                        color: UIColor.blackColor(),
                                                                        textSize: kTextSizeXS)
        }
        
//        switchNode = HASwitchNode()
        
        // Hairline cell separator
        topDivider = ASDisplayNode()
        topDivider.layerBacked = true
        topDivider.backgroundColor = UIColor.lightGrayColor()
        // Hairline cell separator
        bottomDivider = ASDisplayNode()
        bottomDivider.layerBacked = true
        bottomDivider.backgroundColor = UIColor.lightGrayColor()
        
        
        
        super.init()
        
//        addSubnode(switchNode)
        addSubnode(textNode)
        
        addSubnode(topDivider)
        addSubnode(bottomDivider)
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        view.addSubview(switchView)

        switchView.setOn(true, animated: false)
    }
    
    
    
    override func layout() {
        super.layout()
        
        let switchFrame = switchView.frame
        let viewFrame = view.frame
        
        print("viewFrame: \(frame)")
        print("switchFrame: \(switchFrame)")
        
        
        let switchOrginY = (viewFrame.height - switchFrame.height)/2

        
        let leftSideInset = calculatedSize.width - switchFrame.width - 15
        switchView.frame = CGRectMake(leftSideInset, switchOrginY, switchFrame.width, switchFrame.height)
        
        
        if isHeader {
            // Manually layout the divider.
            let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
            let width = calculatedSize.width
            topDivider.frame = CGRectMake(0, 0, width, pixelHeight)
            if hasDivider {
                bottomDivider.frame = CGRectMake(0, calculatedSize.height-1, width, pixelHeight)
            }
        } else  {
            if hasDivider {
                
                // Manually layout the divider.
                let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
                
                let widthParts = calculatedSize.width/10
                let width = widthParts * 8
                //        let leftInset = widthParts*1.5
                topDivider.frame = CGRectMake(leftInset, 0, width, pixelHeight)
            }
        }
    }
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        
        let switchHeight = switchView.frame.height
        let switchWidth = switchView.frame.width
        
        
        textNode.preferredFrameSize = CGSizeMake(100, 50)
        let statNodee = ASStaticLayoutSpec(children: [textNode])
        
        
        let topInset: CGFloat
        
        if !isHeader {
            topInset = topCellInset
        } else {
            topInset = topHeaderInset
        }
        
        let nodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 0,
                                          justifyContent: .Start,
                                          alignItems: .Center,
                                          children: [textNode])
        
        
        let insets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        
        let textWrapper = ASInsetLayoutSpec(insets: insets, child: nodeStack)
        //        textWrapper.flexGrow = true
        
        return textWrapper
    }
    
    
    
    
}