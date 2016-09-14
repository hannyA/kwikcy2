//
//  HAContactUsVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



import AsyncDisplayKit
import SwiftyDrop
import AWSMobileHubHelper


class HAContactUsVC: ASViewController, ASEditableTextNodeDelegate {
    
    
    enum HeadlineType : String {
        case Abuse = "Spam or abuse"
        case Bug = "Something isn't working"
        case General = "General Feedback"
    }
    
    enum MessageType: String {
        case Abuse   = "Tell us what's wrong"
        case Bug     = "Briefly explain what happened."
        case General = "Tell us what you love, what you hate, or what you want changed"
    }
    
    enum FeedbackType: String {
        case Abuse   = "abuse"
        case Bug     = "bug"
        case General = "general"
    }
    
    let headline: String
    let message: String
    let feedbackType: FeedbackType
    
    let displayNode: HAContactFormDisplay
    
    init(headline: HeadlineType) {

              
        self.headline = headline.rawValue

        switch headline {
        case .Abuse:
            feedbackType = .Abuse
            message      = MessageType.Abuse.rawValue
        case .Bug:
            feedbackType = .Bug
            message      = MessageType.Bug.rawValue

        case .General:
            feedbackType = .General
            message      = MessageType.General.rawValue
        }
        
        displayNode = HAContactFormDisplay(headline: headline.rawValue, message: message)
        

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
    
    
    let MaxFeedbackLength = 250
    
    var kFeedback = "feedback"
    let HannyHumorError1 = "404 - Internal Server Error, Beep Boop Beep Boop Boop... Thank you for your feedback. We thrive off it."

    
    func sendMessage() {
        
        if let text = displayNode.textNode.textView.text {
            
            let trimmedString = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if trimmedString.characters.count == 0 {
                Drop.upAll()
                Drop.down("Nothing to send here",
                          state: .Error ,
                          duration: 3.0,
                          action: nil)
            } else if trimmedString.characters.count < 10 {
                Drop.upAll()


                Drop.down("Please enter a legit message",
                          state: .Error ,
                          duration: 2.0,
                          action: nil)
            } else if trimmedString.characters.count > MaxFeedbackLength {
                
                
                
                Drop.upAll()
                Drop.down("Feedback is too long. It can't be any longer than \(MaxFeedbackLength) characters",
                          state: .Error ,
                          duration: 8.0,
                          action: nil)
            } else {
                
                // TODO: Delete this
                if trimmedString.characters.count > 100 {
                    Drop.upAll()
                    Drop.down("Is that all you have to say? Pour your heart out, we're listening",
                              state: .Error ,
                              duration: 5.0,
                              action: nil)
                }
                
                
                var jsonObj = [String: AnyObject]()
                
                jsonObj[kGuid]      = Me.sharedInstance.guid()
                jsonObj[kAcctId]    = Me.sharedInstance.acctId()
                jsonObj[kType]      = feedbackType.rawValue
                jsonObj[kFeedback]  = trimmedString
                
                AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaFeedback,
                 withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in
                    
                    if let result = result {
                        dispatch_async(dispatch_get_main_queue(), {
                            print("Feedback refreshFeedWithCompletionBlock - Result: \(result)")
                            
                            if let response = result as? [String: AnyObject]  {
                                
                                if let success = response[kSuccess] as? Bool {
                                    
                                    if success {
                                        Drop.down("Thank you for your feedback",
                                            state: .Error ,
                                            duration: 3.0,
                                            action: nil)
                                        self.dimissMessageVC()

                                    } else {
                                        Drop.down(self.HannyHumorError1,
                                            state: .Error ,
                                            duration: 8.0,
                                            action: nil)
                                    }
                                }
                                if let errorMessage = response[kErrorMessage] as? String {
                                    
                                    Drop.down(self.HannyHumorError1,
                                        state: .Error ,
                                        duration: 8.0,
                                        action: nil)
                                }
                            } else {
                                
                                Drop.down(self.HannyHumorError1,
                                    state: .Error ,
                                    duration: 8.0,
                                    action: nil)
                            }
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            Drop.down(self.HannyHumorError1,
                                      state: .Error ,
                                      duration: 8.0,
                                      action: nil)
                        })
                    }
                }
            }
        }
    }
    
    
    
    func dimissMessageVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* ASEditableTextNodeDelegate */
    
    func editableTextNodeDidUpdateText(editableTextNode: ASEditableTextNode) {
        print("editableTextNodeDidUpdateText string  \(editableTextNode.textView.attributedText.string)")
        print("editableTextNodeDidUpdateText text \(editableTextNode.textView.text)")
        
        print("editableTextNodeDidUpdateText next \(displayNode.textNode.textView.text)")

        
    }
    
    
    func editableTextNode(editableTextNode: ASEditableTextNode, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if editableTextNode.textView.text.characters.count == MaxFeedbackLength {
            Drop.down("You've reached the end of the line. Maximum message length is \(MaxFeedbackLength) characters.",
                      state: .Error ,
                      duration: 8.0,
                      action: nil)
            return false
        }
        
        return true
    }

    
    
    func editableTextNodeDidBeginEditing(editableTextNode: ASEditableTextNode) {
        print("editableTextNodeDidBeginEditing")

    }
    
    
    
    
}