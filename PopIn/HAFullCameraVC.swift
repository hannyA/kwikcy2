//
//  HAFullCameraViC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit



class HAFullCameraVC: ASViewController, HAFullCameraDelegate {
    
    let fullCameraDisplay: HAFullCameraNode
        
    init() {
        fullCameraDisplay = HAFullCameraNode(leftText: "Cancel", middleText: "Camera", rightText: "Next")
        super.init(node: fullCameraDisplay)
        fullCameraDisplay.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        view.addSubnode(fullCameraDisplay)
    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        print("viewDidLayoutSubviews")
//        fullCameraDisplay.showFirstControls()
//
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        print("viewWillAppear")
////        fullCameraDisplay.showFirstControls()
//    }
//    
    // Delegate methods
    
    
    func didCancelCamera() {
        print("didCancelCamera")
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func moveToNextVC() {
        print("moveToNextVC")
    }
    
}
    