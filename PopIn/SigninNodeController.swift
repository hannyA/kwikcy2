//
//  SigninNodeController.swift
//  PopIn
//
//  Created by Hanny Aly on 4/25/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SigninNodeController: ASViewController  {
    
    var welcomeNode: WelcomeNode
    
    
    /*   AsyncDisplay Subclass Node Rules
     http://asyncdisplaykit.org/docs/subclassing.html
        Init - never initialize UIKit objects
        didLoad - Safe to init UIKit objects
     */
    

    init() {
        welcomeNode = WelcomeNode()
        super.init(node: welcomeNode)
        
        welcomeNode.autoresizingMask = .FlexibleWidth
//        imageNode.autoresizingMask = UIViewAutoresizingFlexibleWidth
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(image: UIImage(named: "mad-men-1.png"))
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        welcomeNode.signinButton.addTarget(self, action: #selector(signinThroughFacebook), forControlEvents: .TouchUpInside)
        
    }

    
    /*
 
     
     
     Other screens just faded in, especially when background is plain white
     Learn more - next screep slid over
     You're on messenger - screen slid in from right
     Main screen - no sliding - - just faded in
     
     
     When click on Next button - replace Next with spinning wheel
     
 
     */
    
    
    func signinThroughFacebook() {
        
        
        
        let userSigninBefore = true
        
        if userSigninBefore {
            
            let vc = CreateUsernameViewController()            
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
        }
    }
}


