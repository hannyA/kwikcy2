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


class PageNavigation: ASDisplayNode {
    
 
    enum UnderbarPosition {
        case First
        case Second
        case Third
    }
    
    
    
    var totalHeight = 0
    
    
    //MARK: Constants
    let peopleTitle = "PEOPLE"
    let groupsTitle = "GROUPS"
    let eventsTitle = "EVENTS"
    
    
    //MARK: Button stuff
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
    
    
    let underBar: ASDisplayNode//Underbar
    var underBarPosition: UnderbarPosition
    var underbarOffsetPercent: CGFloat = 0.0
    
    var currentPageNumber = 0
    
    
    
    
    
    
    
    
    // Initializer
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
        
        
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.minimumInteritemSpacing  = 1
        _flowLayout.minimumLineSpacing       = 1
        
        underBar = ASDisplayNode()
        underBarPosition = .First
        
        super.init()
    
        
        backgroundColor = UIColor.whiteColor()
        
        for (title, button) in buttonDictionary {
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
            setAttributesForButton(button, withTitle: title)
        }
        
        currentPageNumber = 1
        underBarPosition = .First
        
        peopleButton.view.tag = 1
        groupButton.view.tag = 2
        eventsButton.view.tag = 3
        
        currentButton = peopleButton

        peopleButton.backgroundColor = UIColor.redColor()
        groupButton.backgroundColor = UIColor.blueColor()
        eventsButton.backgroundColor = UIColor.yellowColor()
        
        
        underBar.backgroundColor = UIColor.blueColor()
        //        underBar.underButton = 1 // Default 1
        
        usesImplicitHierarchyManagement = true
        
    }
    
    
    
    
    
    // Resets the button title text attributes. Used in layoutSpecThatFits
    // when a button is pressed
    func resetButtonAttributes() {
        setAttributesForButton(peopleButton, withTitle: peopleTitle)
        setAttributesForButton(groupButton, withTitle: groupsTitle)
        setAttributesForButton(eventsButton, withTitle: eventsTitle)
    }
    
    
    func setAttributesForButton(button: ASButtonNode, withTitle title: String) {
        button.setAttributedTitle(attributedString(title, forState: .Normal), forState: .Normal)
        button.setAttributedTitle(attributedString(title, forState: .Highlighted), forState: .Highlighted)
        button.setAttributedTitle(attributedString(title, forState: .Selected), forState: .Selected)
    }
    
    
    
    
    // Setup offset from the posiiton
    
    
    override func animateLayoutTransition(context: ASContextTransitioning!) {
        
        
        
        let initialFrame = context.initialFrameForNode(underBar)

        underBar.frame = initialFrame
        
        UIView.animateWithDuration(0.1, animations: {
            self.underBar.frame = context.finalFrameForNode(self.underBar)
            
        }) { (finished) in
            context.completeTransition(finished)
        }
    }
    
    
    
    // This is called first, changeToPageForButtonType uh duhhh
    // 2) layoutSpecThatFits
    // 3) animateLayoutTransition
    func changeToPageForButtonType(button: ASButtonNode) {
        
        currentButton = button
        
        switch button.view.tag {
        case 1:
            underBarPosition = .First
        case 2:
            underBarPosition = .Second
        case 3:
            underBarPosition = .Third

        default:
            break
        }
        
        transitionLayoutWithAnimation(true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    
    func toCenterPosition(buttonTag: Int) -> CGFloat{
        
        let width = view.frame.width/kNumberOfButtons
        
        let xPosition = ( CGFloat(buttonTag - 1) * width) + (width/2)
        return xPosition
    }
    

    
    
    
    
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        var mainStack = [ASLayoutable]()
        
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
        
        let searchBarWithInset = ASInsetLayoutSpec(insets: searchBarInset, child: barStack)
        
        
        mainStack.append(searchBarWithInset)
        
        peopleButton.flexGrow  = true
        groupButton.flexGrow  = true
        eventsButton.flexGrow  = true
        
        
        //MARK: Untested
        let buttonWidth: CGFloat = constrainedSize.max.width / kNumberOfButtons
        let buttonHeight: CGFloat = constrainedSize.max.height/15 // Magic number
        
        peopleButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size
        groupButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size
        eventsButton.preferredFrameSize = CGSizeMake(buttonWidth, buttonHeight)              // constrain photo frame size
        
        
        // For some reason the title text moves to the left on button press
        resetButtonAttributes()
    
        
        let pageButtonsNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                                     spacing: 0,
                                                     justifyContent: .Center,
                                                     alignItems: .Start,
                                                     children: [peopleButton, groupButton, eventsButton])
        
//        pageButtonsNodeStack.flexGrow = true
        
        
        mainStack.append(pageButtonsNodeStack)
        
        // Underbar
        
        underBar.preferredFrameSize = CGSizeMake( (constrainedSize.max.width / kNumberOfButtons), kUnderBarHeight)
        let underBarOffset = underbarOffsetPercent * constrainedSize.max.width

        underBar.spacingBefore = underBarOffset
        let underbarHorizontalStack = ASStackLayoutSpec(direction: .Horizontal,
                                                    spacing: 0,
                                                    justifyContent: .Start,
                                                    alignItems: .Start,
                                                    children: [underBar])
        
        
        underbarHorizontalStack.flexGrow = true
        
        mainStack.append(underbarHorizontalStack)
        
        
//        let underbarHorizontalStack: ASStackLayoutSpec?
//        switch underBarPosition {
//        case .First:
//            underBar.spacingBefore = underBarOffset
//            underbarHorizontalStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                        spacing: 0,
//                                                        justifyContent: .Start,
//                                                        alignItems: .Start,
//                                                        children: [underBar])
//        case .Second:
//            underbarHorizontalStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                        spacing: 0,
//                                                        justifyContent: .Center,
//                                                        alignItems: .Start,
//                                                        children: [underBar])
//        case .Third:
//            underbarHorizontalStack = ASStackLayoutSpec(direction: .Horizontal,
//                                                        spacing: 0,
//                                                        justifyContent: .End,
//                                                        alignItems: .Start,
//                                                        children: [underBar])
//        }
        
//        underbarHorizontalStack!.flexGrow = true
//        
//        mainStack.append(underbarHorizontalStack!)
        
        
        let fullPageControlStack = ASStackLayoutSpec(direction: .Vertical,
                                                     spacing: 2,
                                                     justifyContent: .Center,
                                                     alignItems: .Stretch,
                                                     children: mainStack)
        
        
//        fullPageControlStack.flexGrow = true
        
        
        
        
        
        return fullPageControlStack
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    override func layout() {
//        super.layout()
//        print("layout")
//        
//        //        print(searchBarNode.view.frame)
//        //        searchBarNode.view.frame
//    }
//    
//    
//    override func displayDidFinish() {
//        super.displayDidFinish()
//        print("displayDidFinish")
//        
//        //        print(searchBarNode.view.frame)
//    }
//    
//    override func layoutDidFinish() {
//        super.layoutDidFinish()
//        print("layoutDidFinish")
//        //        print(searchBarNode.view.frame)
//        //
//        //
//        //        print(peopleButton.view.frame)
//        //        print(groupButton.view.frame)
//        print(underBar.view.frame)
//        
//        
//    }
    
    
    
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
