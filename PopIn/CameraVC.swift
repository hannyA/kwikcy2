//
//  CameraVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/29/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


class CameraVC: ASViewController, CameraDelegate {
    
    let fullCameraDisplay: CameraNode
    
    init() {
        fullCameraDisplay = CameraNode(leftText: "Cancel", middleText: "Camera", rightText: "Next")
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
    
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        let frame = view.frame
//        fullCameraDisplay.initializeCamera(withFrame: frame)
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fullCameraDisplay.initializeCamera(withFrame: view.frame)
    }
    
    
//    
//    override public func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        cameraView.frame = CGRect(origin: CGPointZero, size: cameraShotContainer.frame.size)
//        cameraView.layoutIfNeeded()
//        
//        albumView.initialize()
//        cameraView.initialize()
//    }

    
    
    
    // Delegate methods
    
    
    func didCancelCamera() {
        print("didCancelCamera")
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func moveToNextVC() {
        print("moveToNextVC")
    }
    
}
    