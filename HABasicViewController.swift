//
//  HABasicViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 6/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//
import AsyncDisplayKit


class HABasicViewController: ASViewController {
    
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }

    
    
    func makeClearViewController(viewController: UIViewController) {
        
        viewController.view.alpha = 0
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.navigationBarHidden = true
        
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    func showClearViewController() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.alpha = 1.0
            
        }) { (complete) in
            
        }
    }
    
    func clearAndDismissViewController() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut , animations: {
            
            self.view.alpha = 0.0
            
        }) { (complete) in
            
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
}