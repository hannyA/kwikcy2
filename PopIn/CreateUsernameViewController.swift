//
//  CreateUsernameViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 5/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CreateUsernameViewController: ASViewController, ASEditableTextNodeDelegate {

    let createUser: CreateUserNode
    
    let photoButton: ASButtonNode
    let textViewNode: ASEditableTextNode
    let nextButton: HAPaddedButton
    
    init() {
        createUser = CreateUserNode()
        photoButton = createUser.userPhotoButton
        textViewNode = createUser.usernameTextNode
        nextButton = createUser.nextButton
        
        super.init(node: createUser)
        textViewNode.delegate = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        photoButton.addTarget(self, action: #selector(selectPhoto), forControlEvents: .TouchUpInside)
        nextButton.addTarget(self, action: #selector(continueToNextView), forControlEvents: .TouchUpInside)
        
//        view.backgroundColor = UIColor.whiteColor()
        
        
        // Do any additional setup after loading the view.
        
//        let button = UIButton(frame:  ()
        
//        let button = UIButton(frame: CGRectMake(0, 0, 200, 200))
//        button.setTitle("Press button", forState: .Normal)
//        button.addTarget(self, action: #selector(run), forControlEvents: .TouchUpInside)
//        view.addSubview(button)
    }

    func continueToNextView() {
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        activityIndicatorView.center = nextButton.view.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        
        
        
        let attributedString = NSAttributedString(string: " ",
                                                  attributes:[ NSFontAttributeName : UIFont.systemFontOfSize(15),
                                                    NSForegroundColorAttributeName : UIColor.blackColor()
            ])
        
        nextButton.setAttributedTitle(attributedString, forState: .Normal)


//        nextButton.view.addSubview(activityIndicatorView)
//        nextButton.setAttributedTitle(NSAttributedString(attributedString, forState: .Normal)


//        activityIndicatorView.sizeToFit()
//        let refreshRect: CGRect = activityIndicatorView.frame;
//
//        let nextButtonFrame = nextButton.frame
//        activityIndicatorView.frame = nextButtonFrame
//        view.addSubview(activityIndicatorView)
        
//        CGSize boundSize = self.view.bounds.size;
//        
//        [_activityIndicatorView sizeToFit];
//        CGRect refreshRect = _activityIndicatorView.frame;
//        refreshRect.origin = CGPointMake((boundSize.width - _activityIndicatorView.frame.size.width) / 2.0,
//                                         (boundSize.height - _activityIndicatorView.frame.size.height) / 2.0);
//        _activityIndicatorView.frame = refreshRect;
//        
//        [self.view addSubview:_activityIndicatorView];
        
        
        
//        var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//        
//        activityView.center = self.view.center
//        
//        activityView.startAnimating()
//        
//        self.view.addSubview(activityView)
//        nextButton.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, forState: <#T##ASControlState#>)
        
        
        
        
     
        
        
        
        let tabbar = HATabBarController()
        let tabbarNavCon = UINavigationController(rootViewController: tabbar)
        tabbarNavCon.navigationBarHidden = true
        navigationController?.presentViewController(tabbarNavCon, animated: true, completion: nil)
//        presentViewController(tabbarNavCon, animated: true, completion: nil)
        
    }
    
    
    func setUsersImage(image: UIImage) {
    
        let _image = image.makeCircularImageWithSize(CGSizeMake(80, 80))
        
        photoButton.backgroundImageNode.contentMode = .ScaleAspectFit
        photoButton.setBackgroundImage(_image, forState: .Normal)
        photoButton.titleNode.attributedString = nil
        
        photoButton.setAttributedTitle(nil, forState: .Normal)
    }
    
    
    func selectPhoto() {
        
        print("select photo pressed")
        
        if createUser.usernameTextNode.isFirstResponder() {
            print("usernameTextNode isFirstResponder")

            createUser.usernameTextNode.resignFirstResponder()
        }
        
        
        let attributedString = NSAttributedString(string: "Choose Profile Photo",
                                                  attributes:[ NSFontAttributeName : UIFont.systemFontOfSize(15),
                                                    NSForegroundColorAttributeName : UIColor.blackColor()
                ])
        
        
        
        
        let alertController = UIAlertController(title: "Choose Profile Photo", message: nil, preferredStyle: .ActionSheet)
        
        
        alertController.setValue(attributedString, forKey: "attributedTitle")
        

        // Facebook import
        let facebookAction = UIAlertAction(title: "Import from Facebook", style: .Default) { (action) in

            if let image = UIImage(named: "mad-men-1") {
                self.setUsersImage(image)
            }
            
            //            // Setup button image
//            userPhotoButton.setBackgroundImage(UIImage(named: "circle"), forState: .Normal)
            //        userPhotoButton.setBackgroundImage(UIImage(named: "circle"), forState: .Selected)
            
            
//            userPhotoButton.backgroundImageNode.contentMode = .ScaleAspectFit

            
        }
        alertController.addAction(facebookAction)
        
        // Camera
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            print(action)
        }
        alertController.addAction(cameraAction)
        
        
        // Library
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .Default) { (action) in
            print(action)
        }
        alertController.addAction(libraryAction)
        
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
        

        
        presentViewController(alertController, animated: true, completion: nil)
    }
    



    
    
    
    //MARK: ASEditableTextNode Delegate Methods
    
    func editableTextNodeDidBeginEditing(editableTextNode: ASEditableTextNode) {
        print("editableTextNodeDidBeginEditing")
        
        // Dismiss photo selectio view controller
    }
    
    func editableTextNodeDidFinishEditing(editableTextNode: ASEditableTextNode) {
        print("editableTextNodeDidFinishEditing")
        
        
    }
    
    func editableTextNode(editableTextNode: ASEditableTextNode, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("editableTextNode:shouldChangeTextInRange")
       
        if text == "\n" {
            textViewNode.resignFirstResponder()
            return false
        }
        return true
    }
    
    func editableTextNodeDidUpdateText(editableTextNode: ASEditableTextNode) {
        print("editableTextNodeDidUpdateText")
        
        if textViewNode.textView.text.characters.count > 3 {
            createUser.attributesForNextButtonEnabled(true)
        } else {
            createUser.attributesForNextButtonEnabled(false)
        }
    }
    
    
    func editableTextNodeDidChangeSelection(editableTextNode: ASEditableTextNode, fromSelectedRange: NSRange, toSelectedRange: NSRange, dueToEditing: Bool) {
        print("editableTextNodeDidChangeSelection")
        
    }
}
