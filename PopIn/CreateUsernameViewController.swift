//
//  CreateUsernameViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CreateUsernameViewController: ASViewController {

    let createUser: CreateUserNode
    
    init() {
        createUser = CreateUserNode()
        super.init(node: createUser)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view.
        
//        let button = UIButton(frame:  ()
        
//        let button = UIButton(frame: CGRectMake(0, 0, 200, 200))
//        button.setTitle("Press button", forState: .Normal)
//        button.addTarget(self, action: #selector(run), forControlEvents: .TouchUpInside)
//        view.addSubview(button)
    }

    
    func run() {
        
        print("Button pressed ")
        
        let alertView = UIAlertController(title: "Title", message: "a message", preferredStyle: .Alert)

        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print("You've pressed okay")
        }

        alertView.addAction(OKAction)

        presentViewController(alertView, animated: true, completion: nil)
        

    }
}
