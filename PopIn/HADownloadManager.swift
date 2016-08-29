//
//  HADownloadManager.swift
//  PopIn
//
//  Created by Hanny Aly on 8/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSMobileHubHelper
import AWSS3
import Foundation

class HADownloadManager {
    
    private var allUsers = [UserSearchModel]()
    
    
    init(imageType: UserSearchModel.ProfileImageType) {
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(
                NSURL(fileURLWithPath: NSTemporaryDirectory())
                    .URLByAppendingPathComponent("download"),
//                    .URLByAppendingPathComponent(imageType.rawValue),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            print("Creating 'download' directory failed. Error: \(error)")
        }
    }
    
    
//    
//    func isEmpty() -> Bool {
//        return searchResults.isEmpty
//    }
//    
//    func count() -> Int {
//        return searchResults.count
//    }
//    
//    
//    func indexOf(row: Int) -> UserSearchModel {
//        return searchResults[row]
//    }
//    
//    func removeAllResults() {
//        searchResults.removeAll(keepCapacity: false)
//    }
//    
//    func appendContentsOf(list : [UserSearchModel]) {
//        searchResults.appendContentsOf(list)
//        
//        downloadAllUserThumbImages()
//    }
//    
//    func results() -> [UserSearchModel]{
//        return searchResults
//    }
//    
//    
    
    //MARK: S3 Transfer Manager of User Profile Photos
    
    
    func setDownloadProfileImages(users:[UserSearchModel] ) {
        
        allUsers.appendContentsOf( users )
    }
    
    func downloadAllUserThumbImages() {
        print("downloadAllUserThumbImages: coutn: \(allUsers.count)")
        for userModel in allUsers {
            if let downloadRequest = userModel.downloadRequest {
                print("downloadAllUserThumbImages: userModel.downloadRequest")

                if downloadRequest.state == .NotStarted
                    || downloadRequest.state == .Paused {
                    download(downloadRequest)
                }
            }
        }
    }
    
    
    func indexOfDownloadRequest(downloadRequest: AWSS3TransferManagerDownloadRequest?) -> UserSearchModel? {
        print("indexOfDownloadRequest")
        
        for userModel in allUsers {
            if userModel.downloadRequest == downloadRequest {
                print("indexOfDownloadRequest userModel.downloadRequest == downloadRequest")
                return userModel
            }
        }
        return nil
    }
    
    
    
    
    
    
    func download(downloadRequest: AWSS3TransferManagerDownloadRequest) {
        print(" download(downloadRequest: AWSS3TransferManagerDownloadRequest)")
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
                        
                    }
                } else if let exception = task.exception {
                    print("Exception download failed: [\(exception)]")
                } else {
                    print("download(downloadRequest Successful download")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let searchUserModel = self.indexOfDownloadRequest(downloadRequest) {
                            searchUserModel.downloadRequest = nil
                            searchUserModel.downloadFileURL = downloadRequest.downloadingFileURL
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
        for userModel in allUsers {
            if let downloadRequest = userModel.downloadRequest {
                print("cancelAllDownloads: downloading image for \(userModel.userName)")
                
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

