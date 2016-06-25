//
//  HAChitChatVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HAChitChatVC: ASViewController, ASCollectionDelegate {

    let pageNavigator: PageNavigation
    let pageViewController: PageViewController

    
    let twoFifths: CGFloat = 2.0 / 5
    var buttonDictionary = [String: ASButtonNode]()
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
        
        pageNavigator.underbarOffsetPercent = percentage
        
        pageNavigator.transitionLayoutWithAnimation(true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")}
    
    
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        print("scrollViewShouldScrollToTop")
        
        return true
    }

    
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging, is there deceleration? \(decelerate)")
        
        /*
            Percentages of each page
            First page  0.00
            Second page 0.333...
            Third page 0.666...
 
         
         */
        func pageScrollIsalmostThere(percentage: CGFloat, whichThird third: CGFloat) -> Bool {
            print("pageScrollIsalmostThere")

            print(percentage)
            print(third * twoFifths)
            print( third/2)
            if percentage > (third * twoFifths) && (percentage < third/2) {
                print("heehaw true")

                return true
            }
            return false
        }
//
//        
//        let aThird:CGFloat = 1.0 / 3
//
////        let firstCenterPoint = buttonDictionary.count
//        
//        let percentage: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
//
//        print("Tag is \(pageNavigator.currentButton?.view.tag)")
//        
//        if pageNavigator.currentButton?.view.tag == 1 && pageScrollIsalmostThere(percentage, whichThird: aThird)  {
//            changeToPageForButtonType(pageNavigator.groupButton)
//            print("heehaw")
//        }
//        
//        
        
        
//        if pageNavigator.currentButton?.view.tag == 2 && pageScrollIsalmostThere(<#T##percentage: CGFloat##CGFloat#>, whichThird: <#T##CGFloat#>)
//        if (percentage < (0.333/2)) {
//            changeToPageForButtonType(pageNavigator.peopleButton)
//        } else if (percentage < (0.666/2)) {
//            changeToPageForButtonType(pageNavigator.groupButton)
//        } else {
//            changeToPageForButtonType(pageNavigator.eventsButton)
//        }
    }
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    init() {
        pageViewController = PageViewController()
        pageNavigator = PageNavigation(withSearchTerm: "Search")
        
        super.init(node: pageNavigator)
        
        pageViewController.pagerNode.delegate = self
        
        pageNavigator.underBar.shadowColor = UIColor.redColor().CGColor
        pageNavigator.underBar.shadowRadius = 20
        pageNavigator.underBar.shadowOpacity = 1.0
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ChitChat"
        
        let assumptionHeight: CGFloat = 112
        pageViewController.view.frame = CGRectMake(0, assumptionHeight, view.frame.width, view.frame.height - assumptionHeight)
        
        navigationController?.navigationBarHidden = true
        
        view.addSubnode(pageNavigator)
        view.addSubview(pageViewController.view)
        
        buttonDictionary[pageNavigator.peopleTitle] = pageNavigator.peopleButton
        buttonDictionary[pageNavigator.groupsTitle] = pageNavigator.groupButton
        buttonDictionary[pageNavigator.eventsTitle] = pageNavigator.eventsButton
        
        
    
        for (_, button) in buttonDictionary {
            button.addTarget(self, action: #selector(changeToPageForButtonType), forControlEvents: .TouchUpInside)
        }
    }
    
    

    
    
    
    
    
    func changeToPageForButtonType(button: ASButtonNode) {
        
        
        pageViewController.pagerNode.scrollToPageAtIndex(button.view.tag-1, animated: true)

        pageNavigator.currentButton = button
        
        switch button.view.tag {
        case 1:
            pageNavigator.underBarPosition = .First
        case 2:
            pageNavigator.underBarPosition = .Second
        case 3:
            pageNavigator.underBarPosition = .Third
            
        default:
            break
        }
        
        pageNavigator.transitionLayoutWithAnimation(true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
}
