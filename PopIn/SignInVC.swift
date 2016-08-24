//
//  SigninVC.swift
//  PopIn
//
//  Created by Hanny Aly on 4/25/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSMobileHubHelper
import AsyncDisplayKit
import KeychainAccess


class SignInVC: ASViewController  {
    
    var signInDisplayNode: SignInDisplayNode
    var didSignInObserver: AnyObject!

    
    init() {
        signInDisplayNode = SignInDisplayNode()
        super.init(node: signInDisplayNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Sign In Loading.")

        didSignInObserver =  NSNotificationCenter.defaultCenter().addObserverForName(AWSIdentityManagerDidSignInNotification, object: AWSIdentityManager.defaultIdentityManager(),
                                                    queue: NSOperationQueue.mainQueue(),
                                                    usingBlock: {(note: NSNotification) -> Void in
                                                        
            // perform successful login actions here
            
            print("SignInVC didSignInObserver")
        })
        
        signInDisplayNode.signinButton.addTarget(self, action: #selector(handleFacebookLogin), forControlEvents: .TouchUpInside)
        
        
        signInDisplayNode.signinButton.userInteractionEnabled = true
        signInDisplayNode.hideSpinningWheel()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(didSignInObserver)

    }
    
    
    
    /*  
        *** Called Twice ***
     
        viewWillAppear and viewDidAppear will get called twice, the second time occurs after
        returning from the facebook login website
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.view.alpha = 0.0
        }
    }
    
    /*
    
     *** Called Twice **
   
     */
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.view.alpha = 1.0
                }, completion: nil)
        }
    }
    
    
    
    func dismissVC() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
            self.view.alpha = 0.0
        }) { (completed) in
            self.navigationController?.popViewControllerAnimated(false)
//            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
    
    
    /*
     Other screens just faded in, especially when background is plain white
     Learn more - next screep slid over
     You're on messenger - screen slid in from right
     Main screen - no sliding - - just faded in
     
     
     When click on Next button - replace Next with spinning wheel
     */
    
    
    // MARK: - Utility Methods
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        
        print("Logging into facebook through AWS")
        print("1) Is Main Thread: \(NSThread.isMainThread()), ASSERT to true")

        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            
            // If no error reported by SignInProvider
            print("Logged into facebook through AWS")
            print("2) Is Main Thread: \(NSThread.isMainThread()), ASSERT to true")

            
            if error == nil {
                
                print("Logging into \(AppName)")
                
                self.signInDisplayNode.signinButton.userInteractionEnabled = false
                self.signInDisplayNode.showSpinningWheel()
            
                // Lambda function does userId exist?
                
                AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaLogin,
                    withParameters: nil) { (result: AnyObject?, error: NSError?) in

                        print("3) Is Main Thread: \(NSThread.isMainThread()), ASSERT to false")

                    if let result = result {
                        print("Logged into App: \(AppName)")
                        dispatch_async(dispatch_get_main_queue(), {
                            print("4) Is Main Thread: \(NSThread.isMainThread()), ASSERT to true")

                            print("CloudLogicViewController: Result: \(result)")
                           
                            self.signInDisplayNode.hideSpinningWheel()

                            if let userDetails = LambdaLoginResponse(response: result) {
                                
                                if userDetails.userExists {
                                    
                                    if userDetails.hasOneProfile() {
                                        
                                        Me.saveGuid((userDetails.profiles.first?.guid)!)
                                        Me.saveAcctid((userDetails.profiles.first?.acctId)!)
                                        Me.saveUsername((userDetails.profiles.first?.username)!)
                                        
                                    } else {
                                        // Show Multi profile user selection.
                                        // Let user pick Profile and save info then
                                        
                                    }
                                    
                                    // aslso get username and profilephoto
                                    self.dismissVC()

                                } else {
                                    // User does not exist
                                    let vc = RegisterUserVC()
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }
                            } else {
                                // User does not exist
                                self.serverError(AppName)
                            }
                        })
                    }
                    
                    if let _ = AWSConstants.errorMessage(error) {
                        dispatch_async(dispatch_get_main_queue(), {
                            print("Error occurred in invoking Lambda Function: \(error)")
                            
                            self.serverError(AppName)
                        })
                    }
                }
            } else { // error
                self.serverError("Facebook")
            }
            print("result = \(result), error = \(error)")
        })
    }
    
    
    func serverError(type: String) {
        
        signInDisplayNode.signinButton.userInteractionEnabled = true
        signInDisplayNode.hideSpinningWheel()
        

        
        if type == "Facebook" {
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                                              comment: "Title bar for error alert."),
                                              message: "Could not Login through Facebook at this time",
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                              comment: "Button on alert dialog."),
                                              style: .Default,
                                              handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
       
        } else if type == AppName {
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                comment: "Title bar for error alert."),
                                              message: "Could not login to \(AppName) at this time. Please try again shortly.",
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                comment: "Button on alert dialog."),
                style: .Default,
                handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        } else {
            
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                comment: "Title bar for error alert."),
                                              message: AWSErrorBackend,
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                comment: "Button on alert dialog."),
                style: .Default,
                handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
     
            
        }
    }


//    func showErrorDialog(loginProviderName: String, withError error: NSError) {
//        print("\(loginProviderName) failed to sign in w/ error: \(error)")
//        
//        let alertController = UIAlertController(title: NSLocalizedString("Sign-in Provider Sign-In Error",
//                                                comment: "Sign-in error for sign-in failure."),
//                                                message: NSLocalizedString("\(loginProviderName) failed to sign in w/ error: \(error)",
//                                                comment: "Sign-in message structure for sign-in failure."),
//                                                preferredStyle: .Alert)
//        let doneAction = UIAlertAction(title: NSLocalizedString("Cancel",
//                                       comment: "Label to cancel sign-in failure."),
//                                       style: .Cancel,
//                                       handler: nil)
//        alertController.addAction(doneAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    
    
    
    // MARK: - IBActions
    func handleFacebookLogin() {
        
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    
}


