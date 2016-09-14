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
    
    
    let kRefreshNotifications = "refreshNotifications"

    
    // pull New Notifications, is from the top, cause we're geting new ones
//    change this to refreshing or loading tail
    func queryLambdaNotifications(refreshNotifications refreshNotifications: Bool, completionClosure: (hasNewMessages :Bool, delete: [Int]?, insert: [Int]?, reload: [Int]?) ->()) {
        
        guard let acctId: String = Me.sharedInstance.acctId() else {
            completionClosure(hasNewMessages: false, delete: nil, insert: nil, reload: nil)
            return
        }
        
        var jsonInput:[String: AnyObject] = [kAcctId: acctId]
        
        jsonInput[kRefreshNotifications] = refreshNotifications

        if refreshNotifications {
            if !notificationList.isEmpty {
                if let id = notificationList.first?.id, date = notificationList.first?.date {
                    jsonInput[kNotificationId] = id
                    jsonInput[kTimestamp] = String(date)
                    
                    print("date.toString(): \(date.toString())")
                    print("String(date):   \(String(date))")
                }
            }
        } else {
            if !notificationList.isEmpty {
                print("jsonInput will be getting tail")
                if let id = notificationList.last?.id, date = notificationList.last?.date {
                    jsonInput[kNotificationId] = id
                    jsonInput[kTimestamp] = String(date)
                }
            }
        }
        
        print("jsonInput: \(jsonInput)")
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaNotifications,
         withParameters: jsonInput) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    print("AWSLambdaNotifications CloudLogicViewController: Result: \(result)")
                    
                    let newNotifications = self.responseNotifications(result)
                    
                    if newNotifications.count == 0 {
                        
                        completionClosure(hasNewMessages: false, delete: nil, insert: nil, reload: nil)

                    } else {
                     
                        let deleteRows = self.deleteNotifications(newNotifications)
                        let insertRows = self.insertNotificaitons(newNotifications)
                        let reloadRows = self.reloadNotificaitons(newNotifications)
                        
                        completionClosure(hasNewMessages: true, delete: deleteRows, insert: insertRows, reload: reloadRows)
                        self.downloadAllUserThumbImages()

                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
            
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    
                    completionClosure(hasNewMessages: false, delete: nil, insert: nil, reload: nil)
                })
            }
        }
    }
    
    
    
    
    
    /* TODO: THis should only be used to delete canceled friend notificatinos */
    
    func deleteNotifications(newImage: [HANotificationModel]) -> [Int] {
        
        var indexPathsToRemove = [Int]()
        var modelsToRemove = [HANotificationModel]()
        
        for index in 0..<newImage.count {
            
            let notification = newImage[index]

            if notification.type == .FriendRequestCanceled || notification.type == .FriendAcceptedRequest {
                
                if let (curIndex, currentNotification) = notificationModel(notification, inList: notificationList) {
                    
                    modelsToRemove.append(currentNotification)
                    indexPathsToRemove.append(curIndex)
                }
            }
            
        }
        
        // We don't use indexPathsToRemove because the rows will move as things are deleted
        for model in modelsToRemove {
            
            let index = notificationList.indexOf({ (notification) -> Bool in
               
                if model.id == notification.id {
                    return true;
                }
                return false
            })!
            
            notificationList.removeAtIndex(index)
        }
        
        return indexPathsToRemove
    }
    
    
    
    func insertNotificaitons(newImage: [HANotificationModel]) -> [Int] {
        
        
        var indexPathsToInsert = [Int]()
        var modelsToInsert = [HANotificationModel]()
        
        var newRow = 0
        for index in 0..<newImage.count {
            
            let notification = newImage[index]
            
            if notification.type != .FriendRequestCanceled {
                
                if !notificationExists(notification, inList: notificationList) {
                    
                    modelsToInsert.append(notification)
                    indexPathsToInsert.append(newRow)
                    newRow += 1
                }
                
            }
        }
        
        for index in 0..<modelsToInsert.count {

            let model = modelsToInsert[index]
            notificationList.insert(model, atIndex: index)
        }
        
        return indexPathsToInsert
    }
    
    
    
    
    /*
     
        We have to reload rows, but also
        
        If a row has an udate timestamp, we delete that row
        and insert a new row in the appropriate order (by time)
     
//     */
//    
//    func insertModel(mode: HANotificationModel, intoList list: [HANotificationModel])  -> Int {
//        
//        
//        
//        return 0
//    }
//    
//    
    
    func reloadNotificaitons(newImage: [HANotificationModel]) -> [Int] {
        
        
        var indexPathsToReload = [Int]()
        
        for index in 0..<notificationList.count {
       
            let oldModel = notificationList[index]
            
            if let (_, newModel) = notificationModel(oldModel, inList: newImage) {
                
                if oldModel.type != newModel.type {
                    
                    notificationList.replaceRange( index..<index+1 , with: [oldModel])
                    indexPathsToReload.append(index)
                }
                
            }
        }
        
        return indexPathsToReload
    }
    
    
    /* Converts our backend data into model objects */
    func responseNotifications(object: AnyObject) -> [HANotificationModel] {
       
        var newNotifications = [HANotificationModel]()
        
        if let resultArray = object as? [AnyObject] {
        
            for notification in resultArray {
                
                if let notificationModel = HANotificationModel(item: notification) {
                    
                    newNotifications.append(notificationModel)
                }
            }
        }

        return newNotifications
    }
    
    
    
    /* Finds a notification model in a list */
    
    func notificationModel(model: HANotificationModel , inList list: [HANotificationModel]) -> (Int, HANotificationModel)? {
        
        if let index = list.indexOf({ (notification) -> Bool in
            if model.id == notification.id {
                return true;
            }
            return false
        }) {
            
            return (index, list[index])
        }
        return nil
    }
    
    
    
    func notificationExists(notificationModel: HANotificationModel, inList list: [HANotificationModel] ) -> Bool {
        
        if list.indexOf({ (notification) -> Bool in
            if notificationModel.id == notification.id && notificationModel.timeStamp == notification.timeStamp {
                return true;
            }
            return false
        }) == nil {
            return false
        }
        return true
    }
    
    
    
    
    /* Deprecated */
//    func appendNewNotifications(object: AnyObject) -> (Bool, Int)  {
//        
//        var newNotifications = [HANotificationModel]()
//        
//        if let resultArray = object as? [AnyObject] {
//            print("resultArray = object")
//            
//            
//            if resultArray.isEmpty {
//                return (false, 0)
//            }
//            
//            var newItems = false
//            
//            var count = 0
//            for notification in resultArray {
//                print("notification = \(notification)")
//
//                
//                if let notificationModel = HANotificationModel(item: notification) {
//                    print("notificationList = append")
//
//                    if !notificationExists(notificationModel) {
//                        newItems = true
//                        count += 1
//                        notificationList.insert(notificationModel, atIndex: 0)
//                    }
//                }
//            }
//            
//            return (newItems, count)
//            
//        }
//        return (false, 0)
//    }

    
//    /* Replaced - Soon to be Deprecated */
//
//    func notificationExists(notificationModel: HANotificationModel) -> Bool {
//        
//        if notificationList.indexOf({ (notification) -> Bool in
//            if notificationModel.id == notification.id {
//                return true;
//            }
//            return false
//        }) == nil {
//            return false
//        }
//        return true
//    }

    
    
    /*
        Old Notifications list         New Notifications list
            Id: Timestamp                   Id: Timestamp
                                            6       1s
                                            5       1s
            4      3s  Received             3       2s   Friend_Accepted
            3      2m  Sent                 4       14s  I Accepted
            2      8m                       2       8m
            1      9m                       1       10m
     */
    
    
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

