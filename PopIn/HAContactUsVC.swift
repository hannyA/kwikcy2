//
//  HAContactUsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit

class HAContactUsVC: ASViewController, ASEditableTextNodeDelegate {
    
    
    let headline: String
    let message: String
    
    let displayNode: HAContactFormDisplay
    
    init(headline: String, message: String) {

              
        self.headline = headline
        self.message = message

        displayNode = HAContactFormDisplay(headline: headline, message: message)
        

        super.init(node: displayNode)
        navigationItem.title = "Feedback"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .Done, target: self, action: #selector(sendMessage))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: #selector(dimissMessageVC))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.translucent = false
        displayNode.textNode.delegate = self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayNode.textNode.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        displayNode.textNode.resignFirstResponder()

    }
    
    
    func sendMessage() {
        
        let message = displayNode.textNode.textView.text
        if !message.characters.isEmpty {
            
            print("Sending message: \(displayNode.textNode.textView.text)")
        }
        dimissMessageVC()
    }
    
    
    
    func dimissMessageVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}