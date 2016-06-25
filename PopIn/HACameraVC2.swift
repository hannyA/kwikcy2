//
//  HACameraVC2.swift
//  PopIn
//
//  Created by Hanny Aly on 5/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



class HACameraVC2: ASViewController, HACameraNavigationControllerDelegate {

    let topControl: HACameraNavigationController
    let cameraView: UIView
    let cameraPagerVC: HACameraPagerVC
    let pagerButtons: HACameraNavigation
    
    
//    let cameraImageView: UIImageView
    
    init() {
        
        topControl = HACameraNavigationController(leftText: "Cancel", middleText: "Cmaera", rightText: "Next")

        //        cameraView = ASDisplayNode(viewBlock: { () -> UIView in
//            let a =  UIView()
//            a.frame = CGRectMake(0, 0, 375, 375)
//            return a
//        })
//        cameraControlerPager = ASPagerNode()
//        libraryCameraButtons = ASDisplayNode()
        cameraView = UIView()
        cameraPagerVC = HACameraPagerVC()
        pagerButtons = HACameraNavigation()
        
        
        super.init(node: pagerButtons)
        
        
        topControl.delegate = self

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true

        
        
        let topControlFrame = topControl.frame
        print("topControlFrame: \(topControlFrame)")

        let topControlHeight = topControlFrame.height
        print("topControlHeight: \(topControlHeight)")

        let squareFrame = view.bounds
        cameraView.frame = CGRectMake(0, 0, squareFrame.width, squareFrame.width)
        cameraView.backgroundColor = UIColor.yellowColor()
        
//        let assumptionHeight: CGFloat = 112
//        pageViewController.view.frame = CGRectMake(0, assumptionHeight, view.frame.width, view.frame.height - assumptionHeight)
        
        
        view.addSubnode(topControl)
        view.addSubview(cameraView)
        view.addSubview(cameraPagerVC.view)
        view.addSubnode(pagerButtons)
//        view.addSubnode(libraryCameraButtons)
        
//        view.addSubview(pageViewController.view)
        
        
    }

    
    
    // Delegate methods
    
    
    func didCancelCamera() {
        print("didCancelCamera")
        navigationController?.popViewControllerAnimated(true)

    }
    
    func moveToNextVC() {
        print("moveToNextVC")
    }

}
    