//
//  File.swift
//  PopIn
//
//  Created by Hanny Aly on 6/20/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class FakeVC: ASViewController {
    
   let albumTableNodeDisplay: FakeDisplay
    
    
    init() {

        
        albumTableNodeDisplay = FakeDisplay()
        super.init(node: albumTableNodeDisplay)

        title = "Sunflower"
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("FakeVC viewDidLoad")
//        print("FakeVC textFieldNode.frame \(albumTableNodeDisplay.textFieldNode.frame)")
//        print("FakeVC textFieldNode.textField.frame \(albumTableNodeDisplay.textFieldNode.textField.frame)")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("FakeVC viewWillAppear")
//        print("FakeVC textFieldNode.frame \(albumTableNodeDisplay.textFieldNode.frame)")
//        print("FakeVC textFieldNode.textField.frame \(albumTableNodeDisplay.textFieldNode.textField.frame)")

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print("FakeVC viewDidAppear")
//        print("FakeVC textFieldNode.frame \(albumTableNodeDisplay.textFieldNode.frame)")
//        print("FakeVC textFieldNode.textField.frame \(albumTableNodeDisplay.textFieldNode.textField.frame)")

    }
    
}