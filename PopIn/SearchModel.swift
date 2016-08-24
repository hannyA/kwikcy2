//
//  SearchModel.swift
//  PopIn
//
//  Created by Hanny Aly on 7/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSMobileHubHelper
import AWSS3
import Foundation

class SearchModel {
    
    private var searchResults: [UserSearchModel]
    
    init() {
        searchResults = [UserSearchModel]()
    }
    

    
    func isEmpty() -> Bool {
        return searchResults.isEmpty
    }
    
    func count() -> Int {
        return searchResults.count
    }
    
    
    func indexOf(row: Int) -> UserSearchModel {
        return searchResults[row]
    }
    
    func removeAllResults() {
        searchResults.removeAll(keepCapacity: false)
    }
    
    func appendContentsOf(list : [UserSearchModel]) {
        searchResults.appendContentsOf(list)
    }
    
    func results() -> [UserSearchModel]{
        return searchResults
    }
    
    

    
    func query(parameters: [String: AnyObject], callbackSearchResults: (serverError :Bool, errorMessage: String?) ->()) {
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaSearchUsers,
         withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("CloudLogicViewController: Result: \(result)")
                    
                    let searchResultsList = self.detailsFromResult(result)
                    print("CloudLogicViewController: response: \(searchResultsList)")
                    
                    if let searchResultsList = searchResultsList {
                        
                        print("CloudLogicViewController: response: \(searchResultsList)")
                        if !searchResultsList.isEmpty {
                            
                            print("!searchResults.isEmpty")
                            self.searchResults.appendContentsOf(searchResultsList)
                        }
                        callbackSearchResults(serverError: false, errorMessage: nil)

                    } else {
                        
                        callbackSearchResults(serverError: true, errorMessage: AWSErrorBackend)
                    }
                })
            }
            
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    callbackSearchResults(serverError: true, errorMessage: AWSErrorBackend)
                })
            }
        }
    }
    
    
    //MARK: S3 Transfer Manager of User Profile Photos
    
        
    
    
    
    // https://s3.amazonaws.com/dromo-userfiles-mobilehub-102319095/public/a.jpg

   
    
    func detailsFromResult(object: AnyObject?) -> [UserSearchModel]? {
        
        print("detailsFromResult")
        
        if let objectAsDictionary = object as? [String: AnyObject] {

            var userList = [UserSearchModel]()
            
            if objectAsDictionary.isEmpty {
                return userList
                
            } else {
                let usersFound = objectAsDictionary["UsersFound"] as! Bool
                
                
                if usersFound {
                    let users = objectAsDictionary["Profiles"] as! [ AnyObject] // Array of dictionaries
                    
                    for userItem in users {
                        let user = userItem as! [ String: AnyObject] // Array of dictionaries
                        
                        let username = user[kUserName] as! String
                        let guid     = user[kGuid]     as! String
                        let fullname = user[kFullName] as? String
                        let verified = user[kVerified] as? Bool
                        
                        let userInfo = UserSearchModel.BasicInfo(guid: guid,
                                                                 username: username,
                                                                 fullname: fullname,
                                                                 verified: verified,
                                                                 blocked: nil)
                        let userModel = UserSearchModel(withBasic: userInfo, imageType: .Crop)
                        
                        userList.append(userModel )
                    }
                    return userList
                    
                } else {
                    return userList
                }
            }
        }
        return nil
    }
}

