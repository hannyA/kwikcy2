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
import NVActivityIndicatorView

import AWSCognitoIdentityProvider
import BigBrother
import SwiftyDrop

import FBSDKLoginKit

class SignInVC: ASViewController, RegisterUserVCDelegate  {
    
    
    
    var signInDisplayNode: SignInDisplayNode
    var didSignInObserver: AnyObject!

    
    init() {
        print("SigninVC Inited")
        signInDisplayNode = SignInDisplayNode()
        super.init(node: signInDisplayNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Sign In Loading.")

        didSignInObserver =  NSNotificationCenter.defaultCenter().addObserverForName( AWSIdentityManagerDidSignInNotification,
            object: AWSIdentityManager.defaultIdentityManager(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(note: NSNotification) -> Void in
            
            // perform successful login actions here
            
            print("SignInVC didSignInObserver")
        })
        
        
        

        //TODO: Change verified -->  is_verified
    
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["user_friends", "email", "user_birthday", "user_photos"])
        AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.Browser.rawValue)

        // SystemAccount = Alert Pop up ---> Easiest
        // Browser - Browswer Modal
        // Web - Pop up in screen   ---> Coolest
        // , Native = Browswer Modal
        
        signInDisplayNode.signinButton.addTarget(self,
                                                 action: #selector(handleFacebookLogin),
                                                 forControlEvents: .TouchUpInside)
        
        signInDisplayNode.signinButton.userInteractionEnabled = true
        signInDisplayNode.hideSpinningWheel()
    }
    
    deinit {
        print("SignInVC deinited")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("SignInVC viewWillDisappear")
        super.viewWillDisappear(animated)
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
        
        print("SigninVC View did appear")
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            
            print("SigninVC View did appear: dispatch_once")

            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
            
                self.view.alpha = 1.0
                
            }, completion: { (done) in
                
                print("tabBarController?.selectedIndex = 0")

//                self.tabBarController?.selectedIndex = 0
            })
        }
    }
    
    
    
    func dismissVC() {
        print("SignInVC dismissVC")
        NSNotificationCenter.defaultCenter().removeObserver(self)

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: {
            self.view.alpha = 0.0
        }) { (completed) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
    func didRegister() {
        navigationController?.popViewControllerAnimated(false)
        dismissVC()
    }
    
    
    // MARK: - IBActions
    func handleFacebookLogin() {
        
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    
    // MARK: - Utility Methods
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        
        print("Logging into facebook through AWS")

        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            
            // If no error reported by SignInProvider
            print("Logged into facebook through AWS")
            print("result = \(result), error = \(error)")

            
            if error == nil {
                
                print("Logging into: \(AppName)")
                
                self.signInDisplayNode.signinButton.userInteractionEnabled = false
                self.signInDisplayNode.showSpinningWheel()
                BigBrother.Manager.sharedInstance.incrementActivityCount()
                // Lambda function does userId exist?
                
                      
                AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaLogin,
                 withParameters: nil) { (result: AnyObject?, error: NSError?) in
                    
                    print("3) Is Main Thread: \(NSThread.isMainThread()), ASSERT to false")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        BigBrother.Manager.sharedInstance.decrementActivityCount()
                    })
                    
                    if let result = result {
                        
                        print("Logged into App: \(AppName)")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            print("CloudLogicViewController: Result: \(result)")
                            
                            self.signInDisplayNode.hideSpinningWheel()
                            
                            if let userDetails = LambdaLoginResponse(response: result) {
                                
                                if userDetails.profiles.count > 0 {
                                    
                                    if userDetails.hasOneProfile() {
                                        let profile = userDetails.profiles.first!
                                        
                                        if profile.active == UserActiveStatus.Active.rawValue  {
                                            
                                            Me.sharedInstance.saveGuid(profile.guid)
                                            Me.sharedInstance.saveAcctid(profile.acctId)
                                            Me.sharedInstance.saveUsername(profile.username)
                                            Me.sharedInstance.saveVerification(profile.verified)
                                            
                                            if let fullname = profile.fullname {
                                                Me.sharedInstance.saveFullname(fullname)
                                            }
                                            if let about = profile.about {
                                                Me.sharedInstance.saveBio(about)
                                            }
                                            if let domain = profile.domain {
                                                Me.sharedInstance.saveWebsite(domain)
                                            }
                                            if let gender = profile.gender {
                                                Me.sharedInstance.saveGender(gender)
                                            }
                                            self.dismissVC()
                                            
                                        } else if profile.active == UserActiveStatus.Disabled.rawValue  {
                                            
                                            Drop.down("This account has been disabled.",
                                                state: .Error ,
                                                duration: 6.0,
                                                action: nil)
                                            
                                            print("Push register")
                                            
                                            let vc = RegisterUserVC()
                                            vc.delegate = self
                                            self.navigationController?.pushViewController(vc, animated: false)
                                        }
                                        
                                        
                                    } else {
                                        // Show Multi profile user selection.
                                        // Let user pick Profile and save info then
                                        
                                    }
                                    
                                    // aslso get username and profilephoto
                                    
                                } else {
                                    // User does not exist
                                    print("Push register")
                                    
                                    let vc = RegisterUserVC()
                                    vc.delegate = self
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }
                            } else {
                                // User does not exist
                                self.serverError(.AppName, message: nil)
                            }
                        })
                    }
                    
                    if let _ = AWSConstants.errorMessage(error) {
                        dispatch_async(dispatch_get_main_queue(), {
                            print("Error occurred in invoking Lambda Function: \(error)")
                            
                            self.serverError(.AppName, message: nil)
                        })
                    }
                }
            }
            
            else { // error
                print("Logged into facebook through AWS error")
           
                if let error = error {
                    
                    // let localizedDescription = error.localizedDescription
                    
                    if error.code == 306 {
                        self.serverError(.FacebookDeniedSettings, message: nil)
                    } else {
                        self.serverError(.Other, message: error.localizedDescription)

                    }
                    
                } else {
                
                    self.serverError(.Facebook, message: nil)
                
                }
            }
        })
    }
    
    
    enum SigninErrorType {
        case FacebookDeniedSettings
        case Facebook
        case AppName
        case Other
    }
    
    
    func serverError(type: SigninErrorType, message: String?) {
        
        signInDisplayNode.signinButton.userInteractionEnabled = true
        signInDisplayNode.hideSpinningWheel()
        

        switch type {
            
        case .FacebookDeniedSettings:
            let alertView = UIAlertController(title: NSLocalizedString("Access Denied",
                comment: "Title bar for error alert."),
                                              message: "Access has not been granted to the Facebook account. Verify device settings.",
                                              preferredStyle: .Alert)
          
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                comment: "Button on alert dialog."),
                style: .Cancel,
                handler: nil))
            
            alertView.addAction(UIAlertAction(title: NSLocalizedString("Take me there",
                comment: "Button on alert dialog."),
                style: .Default,
                handler: { (alertAction) in
                    UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=FACEBOOK")!)
            }))
            
            
            self.presentViewController(alertView, animated: true, completion: nil)
            
        case .Facebook:
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                                              comment: "Title bar for error alert."),
                                              message: "Could not Login through Facebook at this time",
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                              comment: "Button on alert dialog."),
                                              style: .Default,
                                              handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
       
        case .AppName:
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                comment: "Title bar for error alert."),
                                              message: "Could not login to \(AppName) at this time. Please try again shortly.",
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                comment: "Button on alert dialog."),
                style: .Default,
                handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            

        default:
            let alertView = UIAlertController(title: NSLocalizedString("Error",
                comment: "Title bar for error alert."),
                                              message: message!,
                                              preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK",
                comment: "Button on alert dialog."),
                style: .Default,
                handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}


