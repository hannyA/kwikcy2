//
//  FullPage.swift
//  PopIn
//
//  Created by Hanny Aly on 5/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import pop


class FullPage: ASDisplayNode, POPAnimatorDelegate {
    
    
    func animatorWillAnimate(animator: POPAnimator!) {
        
        print("animatorWillAnimate")
        
    }
    func animatorDidAnimate(animator: POPAnimator!) {
        print("animatorDidAnimate")
    
    }
    
    
    

    
    
    //MARK: Constants
    let peopleTitle = "PEOPLE"
    let groupsTitle = "GROUPS"
    let eventsTitle = "EVENTS"
    
    var pagerNodeOriginY: CGFloat?
    let kPageButtonHeightFraction: CGFloat = 11
    let kPageButtonWidthFraction: CGFloat = 3

    
    let kUnderBarHeight:CGFloat = 3
    let kNumberOfButtons:CGFloat = 3

    
    //MARK: Properties
    let searchBarNode: ASDisplayNode
    
    let peopleButton: ASButtonNode
    let groupButton: ASButtonNode
    let eventsButton: ASButtonNode
    
    var currentButton: ASButtonNode?
    let underBar: ASDisplayNode

    let pagerNode: ASPagerNode // Each page will contain a TableView
    
    
    var currentPageNumber = 0
    
    
    
    init(withSearchTerm: String) {
        
        searchBarNode = ASDisplayNode(viewBlock: { () -> UIView in
            let searchbar = UISearchBar()
            searchbar.placeholder = "Search"
//            searchbar.searchBarStyle = .Minimal
//            searchbar.barStyle = .Default
            searchbar.barTintColor = UIColor.whiteColor()
            searchbar.tintColor = UIColor.blackColor()
            searchbar.showsCancelButton = true
            
            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
            return searchbar
        })
        
        
        peopleButton = ASButtonNode()
        groupButton = ASButtonNode()
        eventsButton = ASButtonNode()
        
        let buttonDictionary = [peopleTitle: peopleButton,
                                groupsTitle: groupButton,
                                eventsTitle: eventsButton]

        
        pagerNode = ASPagerNode()
        underBar = ASDisplayNode()
        super.init()
        
        backgroundColor = UIColor.whiteColor()
        
        pagerNode.backgroundColor = UIColor.greenColor()
        
        for (title, button) in buttonDictionary {
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
            setAttributesForButton(button, withTitle: title)
            button.addTarget(self, action: #selector(changeToPageForButtonType), forControlEvents: .TouchUpInside)
        }
        
        currentPageNumber = 1
        peopleButton.view.tag = 1
        groupButton.view.tag = 2
        eventsButton.view.tag = 3
        
        peopleButton.backgroundColor = UIColor.blueColor()
        groupButton.backgroundColor = UIColor.redColor()
        eventsButton.backgroundColor = UIColor.greenColor()
        
        
        underBar.backgroundColor = UIColor.blueColor()
//        underBar.underButton = 1 // Default 1

        usesImplicitHierarchyManagement = true
    }
    
    
    
    
    
    
    
    
    func setAttributesForButton(button: ASButtonNode, withTitle title: String) {
        button.setAttributedTitle(attributedString(title, forState: .Normal), forState: .Normal)
        button.setAttributedTitle(attributedString(title, forState: .Highlighted), forState: .Highlighted)
        button.setAttributedTitle(attributedString(title, forState: .Selected), forState: .Selected)
    }
    
    
    
    
    
    
    
    override func animateLayoutTransition(context: ASContextTransitioning!) {
        
        let buttonPosition = currentButton?.view.tag
        
        
        var initialFrame = context.initialFrameForNode(underBar)
        initialFrame.origin.x += (initialFrame.size.width * 2)
        underBar.frame = initialFrame
        
        
        UIView.animateWithDuration(0.4, animations: { 
            self.underBar.frame = context.finalFrameForNode(self.underBar)
            
            }) { (finished) in
                context.completeTransition(finished)
        }
//        // POPBasicAnimation
//        let basicanimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
//        basicanimation.timingFunction  = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        basicanimation.toValue = toCenterPosition(currentButton!.view.tag)
//        basicanimation.name = "SlideUnderBar"
//        basicanimation.delegate = self
//        basicanimation.completionBlock = {(animation, finished) in
//            //Code goes here
//            print("completionBlock")
//            context.completeTransition(finished)
//            
//        }
//        underBar.pop_addAnimation(basicanimation, forKey: "slideKey")
    }
    

    
    
    func changeToPageForButtonType(button: ASButtonNode) {
        
        currentButton = button
        transitionLayoutWithAnimation(true, shouldMeasureAsync: false, measurementCompletion: nil)

        //        if underBar.isNotUnderButton(button) {
//            underBar
//        }
        
        
        
//        
//        if currentPageNumber ==  button.view.tag {
//            return
//        }
//        else {
//            
//        }
//        if button.view.tag == 1 {
//            
//        } else if button.view.tag == 2 {
//            
//        } else if button.view.tag == 3 {
//        
//        }
//        
//        if button.titleNode.attributedString?.string == peopleTitle {
//
//        } else if button.titleNode.attributedString?.string == groupsTitle {
//
//        } else if button.titleNode.attributedString?.string == eventsTitle {
//
//        }

    }
    
    
    func toCenterPosition(buttonTag: Int) -> CGFloat{
        
        let width = view.frame.width/kNumberOfButtons
        
        let xPosition = ( CGFloat(buttonTag - 1) * width) + (width/2)
        return xPosition
    }
    
    
    
    
    
    
    override func didLoad() {
        super.didLoad()
       
        underBar.view.frame = CGRectMake(0, 0, view.frame.width / kNumberOfButtons, kUnderBarHeight)
        
    }
    
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        searchBarNode.flexGrow = true
        
        // vertical stack
        let cellWidth: CGFloat = constrainedSize.max.width
        let cellHeight: CGFloat = constrainedSize.max.height/15 // Magic number

        searchBarNode.preferredFrameSize = CGSizeMake(cellWidth, cellHeight)              // constrain photo frame size

        let topInsetForStatusBar = UIApplication.sharedApplication().statusBarFrame.height
        
        let searchBarInset = UIEdgeInsetsMake(topInsetForStatusBar, 0, 0, 0)

        let barStack = ASStackLayoutSpec(direction: .Horizontal,
                                                       spacing: 0,
                                                       justifyContent: .Start,
                                                       alignItems: .Start,
                                                       children: [searchBarNode])
        barStack.flexGrow = true

        let searchBarWithInset = ASInsetLayoutSpec(insets: searchBarInset, child: barStack)

        
        
        peopleButton.flexGrow  = true
        groupButton.flexGrow  = true
        eventsButton.flexGrow  = true
        
        
        //MARK: Untested
        let buttonWidth: CGFloat = constrainedSize.max.width / kNumberOfButtons
        let buttonHeight: CGFloat = constrainedSize.max.height/15 // Magic number
       
        peopleButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size
        groupButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size
        eventsButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size

        
        
        
        
        
        
        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .Center,
                                               alignItems: .Start,
                                               children: [peopleButton, groupButton, eventsButton])
//        pageButtonsNodeStack.flexGrow = true
        
        
        

        
        
        
        
//        let searchbarVerticalStack = ASStackLayoutSpec(direction: .Vertical,
//                                              spacing: 10,
//                                              justifyContent: .Start,
//                                              alignItems: .Stretch,
//                                              children: [searchBarWithInset, pageButtonsNodeStack])
//        searchbarVerticalStack.flexShrink = true
//
//        //MARK: Works up to here
//        return searchbarVerticalStack
        
        
        
        
//        underBar.flexGrow = true
        
        underBar.preferredFrameSize = CGSizeMake( (constrainedSize.max.width / kNumberOfButtons), kUnderBarHeight)
        
        
//        let spacer = ASLayoutSpec()
//        spacer.flexGrow = true
        
        let underbarHorizontalStack = ASStackLayoutSpec(direction: .Horizontal,
                                                       spacing: 0,
                                                       justifyContent: .Start,
                                                       alignItems: .Start,
                                                       children: [underBar])
        underbarHorizontalStack.flexGrow = true
        
        let fullPageControlStack = ASStackLayoutSpec(direction: .Vertical,
                                                        spacing: 2,
                                                        justifyContent: .Start,
                                                        alignItems: .Stretch,
                                                        children: [searchBarWithInset, pageButtonsNodeStack, underbarHorizontalStack ])
        
        fullPageControlStack.flexGrow = true
        
        
        return fullPageControlStack
        
//        underbarHorizontalStack
//        underbarHorizontalStack.flex = true
        
        
        
        
        
        
        
        
        
        let searchbarVerticalStack = ASStackLayoutSpec(direction: .Vertical,
                                                       spacing: 10,
                                                       justifyContent: .Start,
                                                       alignItems: .Stretch,
                                                       children: [searchBarWithInset, pageButtonsNodeStack, underbarHorizontalStack])
        searchbarVerticalStack.flexShrink = true

        return searchbarVerticalStack
        
        
        
        
        
        
        let pageStack = ASStackLayoutSpec(direction: .Horizontal,
                                                       spacing: 0,
                                                       justifyContent: .Start,
                                                       alignItems: .Center,
                                                       children: [pagerNode])
        
        
        
        let verticalStack = ASStackLayoutSpec(direction: .Vertical,
                                              spacing: 0,
                                              justifyContent: .Start,
                                              alignItems: .Stretch,
                                              children: [ pageButtonsNodeStack, pageStack])
        
        return verticalStack
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func layout() {
        super.layout()
        print("layout")

//        print(searchBarNode.view.frame)
//        searchBarNode.view.frame
    }
    
    
    override func displayDidFinish() {
        super.displayDidFinish()
        print("displayDidFinish")

//        print(searchBarNode.view.frame)
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        print("layoutDidFinish")
//        print(searchBarNode.view.frame)
//        
//        
//        print(peopleButton.view.frame)
//        print(groupButton.view.frame)
        print(underBar.view.frame)


    }
    
    
    
    //MARK: Helper 
    
    func attributedString(string: String, forState state: UIControlState) -> NSAttributedString {
        
        switch state {
        case UIControlState.Normal:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        case UIControlState.Highlighted:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
            
        case UIControlState.Selected:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        default:
            return NSAttributedString(string: string,
                                      attributes: [NSForegroundColorAttributeName: UIColor.blackColor(),
                                        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!])
        }
    }
    
    
}
