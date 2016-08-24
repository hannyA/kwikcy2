//
//  HANotificationFeed.swift
//  PopIn
//
//  Created by Hanny Aly on 7/17/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AWSS3
import AWSMobileHubHelper
import KeychainAccess

class HANotificationFeed {
    
    
    var newestNotificationId: Int
    var oldestNotificationId: Int
    private var notificationList: [HANotificationModel]
    
    
    init() {
        newestNotificationId = 0
        oldestNotificationId = 0
        notificationList = [HANotificationModel]()
    }
    
    // Not used, we have to change SQL statement to do a Count of total notifications for user
    private func totalNumberOfNotifications() -> Int {
        return 0
    }
    
    func isEmpty() -> Bool {
        return notificationList.isEmpty
    }
    
    func numberOfItemsInFeed() -> Int {
        return notificationList.count
    }
    
    func objectAtIndex(index: Int) -> HANotificationModel {
        
        return notificationList[index]
    }
    
    
    func indexOfNotificationModel(model: HANotificationModel) -> Int? {
        
        let index = notificationList.indexOf { (notification: HANotificationModel) -> Bool in
            
            if notification.id == model.id {
                return true
            }
            return false
        }
        
        return index
    }

    
    //MARK: AWS Lambda
    
    
    /*
     *  Gets users notifications, then downloads all users thumb photos
     *
     */
    
    func queryLambdaNotifications(pullNewNotifications: Bool, completionClosure: (newMessages :Bool, count: Int) ->()) {
        
        //TODO: I guess we're letting it crash for now, cause I don't know what to tell the user...
        // ONly other option is to store last active account in db?
        let acctId = Me.acctId()!
        
        var jsonInput:[String: AnyObject] = ["acctId": acctId]
        
        
        jsonInput["pullNewNotifications"] = pullNewNotifications

        if pullNewNotifications {
            if !notificationList.isEmpty {
                jsonInput["notificationId"] = notificationList.first?.id
            }
        } else {
            jsonInput["notificationId"] = notificationList.last?.id
        }
        
        print("notificationId: \(jsonInput["notificationId"])")
        
        
        var parameters: [String: AnyObject]
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonInput, options: .PrettyPrinted)
            let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
            parameters = anyObj
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            completionClosure(newMessages: false, count: 0)
            return
        }
        
        //        HAUserProfileBasic
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaNotifications,
         withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("CloudLogicViewController: Result: \(result)")
                    
                    let (didGetNotifications, count) = self.appendNewNotifications(result)
                    
                    completionClosure(newMessages: didGetNotifications, count: count)

                    self.downloadAllUserThumbImages()
                    
                })
            }
            
//            var errorMesage = AWSConstants.errorMessage(error)
            
            if let _ = AWSConstants.errorMessage(error) {
            
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    
                    completionClosure(newMessages: false, count: 0)
                })
            }
        }
    }
    
    func notificationExists(notificationModel: HANotificationModel) -> Bool {
        
        if notificationList.indexOf({ (notification) -> Bool in
            if notificationModel.id == notification.id {
                return true;
            }
            return false
        }) == nil {
            return false
        }
        
        return true
    }

    
    func appendNewNotifications(object: AnyObject) -> (Bool, Int)  {
        
        if let resultArray = object as? [AnyObject] {
            print("resultArray = object")
            
            
            if resultArray.isEmpty {
                return (false, 0)
            }
            
            var newItems = false
            
            var count = 0
            for notification in resultArray {
                print("notification = \(notification)")

                
                if let notificationModel = HANotificationModel(item: notification) {
                    print("notificationList = append")

                    if !notificationExists(notificationModel) {
                        newItems = true
                        count += 1
                        notificationList.insert(notificationModel, atIndex: 0)
                    }
                }
            }
            
            return (newItems, count)
            
        }
        return (false, 0)
    }


    
    
    
    func downloadAllUserThumbImages() {
        print("downloadAllUserThumbImages")
        for userModel in notificationList {
            print("downloadAllUserThumbImages userModel")

            if let downloadRequest = userModel.otherUser.downloadRequest {

                if downloadRequest.state == .NotStarted
                    || downloadRequest.state == .Paused {
                    print("downloadAllUserThumbImages download")

                    download(downloadRequest)
                }
            }
        }
        //        self.collectionView.reloadData()
    }
    
    
    func indexOfDownloadRequest(downloadRequest: AWSS3TransferManagerDownloadRequest?) -> HANotificationModel? {
        print("indexOfDownloadRequest")
        
        for notification in notificationList {
            if notification.otherUser.downloadRequest == downloadRequest {
                print("indexOfDownloadRequest userModel.downloadRequest == downloadRequest")
                return notification
            }
        }
        return nil
    }
    
    
    
    
    
    
    func download(downloadRequest: AWSS3TransferManagerDownloadRequest) {
        print("download(downloadRequest: AWSS3TransferManagerDownloadRequest)")
        switch (downloadRequest.state) {
        case .NotStarted, .Paused:
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
                if let error = task.error {
                    if error.domain == AWSS3TransferManagerErrorDomain as String
                        && AWSS3TransferManagerErrorType(rawValue: error.code) == AWSS3TransferManagerErrorType.Paused {
                        print("Download paused.")
                    } else {
                        print("Error download failed: [\(error)]")
                        print("Error download domain: [\(error.domain)]")
                        
                        
//                        //Try downloading original???
//                        if let notificationModel = self.indexOfDownloadRequest(downloadRequest) {
//                            
//                            if let largerImageType = notificationModel.otherUser.largerImageType() {
//                                
//                                notificationModel.otherUser.profileImageType(largerImageType)
//                                
//                                if let downloadRequest = notificationModel.otherUser.downloadRequest {
//                                    print("downloading original image for \(notificationModel.otherUser.userName), original: \(notificationModel.otherUser.imageS3Key)")
//                                    
//                                    
//                                    if downloadRequest.state == .NotStarted
//                                        || downloadRequest.state == .Paused {
//                                        self.download(downloadRequest)
//                                    }
//                                }
//                            }
//                        }
                    }
                } else if let exception = task.exception {
                    print("Exception download failed: [\(exception)]")
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let notification = self.indexOfDownloadRequest(downloadRequest) {
                            notification.otherUser.downloadRequest = nil
                            notification.otherUser.downloadFileURL = downloadRequest.downloadingFileURL
                        }
                    })
                }
                return nil
            })
            
            break
        default:
            break
        }
    }
    
    
    
    func cancelAllDownloads() {
        print("cancelAllDownloads")
        for notificationModel in notificationList {
            if let downloadRequest = notificationModel.otherUser.downloadRequest {
                print("cancelAllDownloads: downloading image for \(notificationModel.otherUser.userName)")
                
                if downloadRequest.state == .NotStarted
                    || downloadRequest.state == .Paused {
                    downloadRequest.cancel().continueWithBlock({ (task) -> AnyObject! in
                        if let error = task.error {
                            print("cancel() failed: [\(error)]")
                        } else if let exception = task.exception {
                            print("cancel() failed: [\(exception)]")
                        }
                        return nil
                    })
                }
            }
        }
    }
    
  
    
    

}

