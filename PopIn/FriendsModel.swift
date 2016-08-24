//
//  FriendsModel.swift
//  PopIn
//
//  Created by Hanny Aly on 8/15/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AWSMobileHubHelper

//@objc protocol TESTFullAppModelDelegate {
//
//    // Call delegate to delete these these rows first
//    optional func filterOutSearchResultsWithPrefix(prefix: String) -> [NSIndexPath]
//
//    // Call delegate to insert these these rows next
//    optional func filterInResults(prefix: String) -> [NSIndexPath]
//}

class FriendsModel {
    
    var kIndexPathSection: Int
    
    private var usersList: [UserUploadFriendModel] = [UserUploadFriendModel]()
    
    var didLoad = false
    
    var isLoading = false
    
    func load(completionClosure: (success: Bool) ->()) {
        
        isLoading = true
       
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUserFriends,
         withParameters: nil) { (result: AnyObject?, error: NSError?) in
            
            print("AWSLambdaUserFriends back")

            if let result = result {
                print("AWSLambdaUserFriends result")

                dispatch_async(dispatch_get_main_queue(), {
                    print("profileModel: CloudLogicViewController: Result: \(result)")
                    
                    if let myFriendsModel = FriendsResponse(response: result) {
                        
                        if (myFriendsModel.hasFriends()) {
                            self.usersList.appendContentsOf(myFriendsModel.friends)
                        }
                        
                        self.didLoad = true
                        self.isLoading = false

                        completionClosure(success: true)
                    } else {
                        
                        self.didLoad = true
                        self.isLoading = false
                        completionClosure(success: false)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                print("AWSLambdaUserFriends error")
                
                self.didLoad = true
                self.isLoading = false
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(success: false)
                })
            }
        }
    }

    
    
    
    init() {
        kIndexPathSection = 0
    }
    init(indexPathSection section: Int) {
        kIndexPathSection = section
    }
    
    init(numberOfUsers number: Int) {
        kIndexPathSection = 0
    }
    
    
    func firstUser() -> UserUploadFriendModel? {
        return usersList.first!
    }
    
    func lastUser() -> UserUploadFriendModel? {
        
        if !usersList.isEmpty {
            usersList.last
        }
        return nil
    }
    
    func userCount() -> Int {
        return usersList.count
    }
    
    func userAtIndex(index: Int) -> UserUploadFriendModel {
        return usersList[index]
    }
    
    
    
    func allUsers() -> [UserUploadFriendModel] {
        return usersList
    }
    
    
    
    
//    func createUserSearchDataSource(numberOfUsers: Int) {
//        for _ in 0..<numberOfUsers {
//            usersList.append(createUser())
//        }
//        
//        print("usersList count = \(usersList.count)")
//        
//        usersList.sortInPlace { (user1, user2) -> Bool in
//            
//            if user1.userName.lowercaseString < user2.userName.lowercaseString {
//                return true
//            }
//            return false
//        }
//        print("sorted usersList count = \(usersList.count)")
//        
//    }
    
    
    
    
    /*
     ==========================================================================================
     ==========================================================================================
     Search functions
     ==========================================================================================
     ==========================================================================================
     */
    
    private var searchResults = [UserUploadFriendModel]()
    
    func searchResultAtIndex(index: Int) -> UserUploadFriendModel {
        return searchResults[index]
    }
    
    func searchResultsCount() -> Int {
        return searchResults.count
    }
    
    // Returns nsindexPaths rows
    
    func resetSearchResults() {
        searchResults.removeAll()
        searchResults.appendContentsOf(allUsers())
        print("sorted searchResults count = \(searchResults.count)")
    }
    
    
    
    func searchWithPrefix(prefix: String) {
        
        if prefix == "" {
            resetSearchResults()
        } else {
            searchResults.removeAll()
            searchResults.appendContentsOf(searchUsersWithPrefix(prefix))
        }
    }
    
    
    
    
    
    func refillSearchResults() -> [NSIndexPath] {
        
        var indexPathRows = [NSIndexPath]()
        
        var searchIndex = 0
        var userListIndex = 0
        let limit = usersList.count
        while searchIndex < limit && userListIndex < limit {
            
            if searchResults[searchIndex].userName < usersList[userListIndex].userName {
                searchIndex += 1
            } else {
                searchResults.insert(usersList[userListIndex], atIndex: searchIndex)
                indexPathRows.append(NSIndexPath(forRow: searchIndex, inSection: kIndexPathSection))
                userListIndex += 1
            }
        }
        return indexPathRows
    }
    
    
    
    func fetchInsertSearchResults(prefix:String) -> [NSIndexPath]? {
        
        print("fetchInsertSearchResults")
        // Call delegate to insert these these rows next
        let insertedRows = filterInResults(prefix)
        return insertedRows
    }
    
    func fetchDeletedSearchResults(prefix:String) -> [NSIndexPath]? {
        
        if prefix.characters.isEmpty {
            return nil
        }
        
        print("fetchDeletedSearchResults")
        // Call delegate to insert these these rows next
        let deletedRows = filterOutSearchResultsWithPrefix(prefix)
        return deletedRows
    }
    
    
    
    
    func filterOutSearchResultsWithPrefix(prefix: String) -> [NSIndexPath] {
        
        var deletedRows = [NSIndexPath]()
        
        print("filterOutSearchResultsWithPrefix currently: \(searchResults.count) rows")
        
        for i in 0..<searchResults.count {
            
            let user = searchResults[i]
            if !user.userName.lowercaseString.hasPrefix(prefix.lowercaseString) {
                deletedRows.append(NSIndexPath(forRow: i, inSection: kIndexPathSection))
            }
        }
        print("filterOutSearchResultsWithPrefix  deleted count: \(deletedRows.count)")
        
        searchResults = searchResults.filter { (userModel: UserUploadFriendModel) -> Bool in
            
            if userModel.userName.lowercaseString.hasPrefix(prefix.lowercaseString) {
                return true
            }
            return false
        }
        print("filterOutSearchResultsWithPrefix searchResults count: \(searchResults.count)")
        
        return deletedRows
    }
    
    
    
    
    func filterInResults(prefix: String) -> [NSIndexPath]? {
        
        var newResults:[UserUploadFriendModel] = [UserUploadFriendModel]()
        
        if prefix.characters.isEmpty {
            newResults.appendContentsOf(usersList)
        } else {
            newResults = searchUsersWithPrefix(prefix)
        }
        if newResults.isEmpty {
            return nil
        }
        
        print("filterInResults should be Final count: \(newResults.count)")
        
        var insertRows = [NSIndexPath]()
        var newI = 0
        var searchIndex = 0
        var indexPathRow = 0
        
        while searchIndex < searchResults.count && newI < newResults.count {
            
            if newResults[newI].userName.lowercaseString < searchResults[searchIndex].userName.lowercaseString {
                insertRows.append(NSIndexPath(forRow: indexPathRow, inSection: kIndexPathSection))
                newI += 1
            }
            else if newResults[newI].userName.lowercaseString == searchResults[searchIndex].userName.lowercaseString {
                newI += 1
                searchIndex += 1
                
            } else {
                searchIndex += 1
            }
            indexPathRow += 1
            
        }
        print("filterInResults insertRows first stage count: \(insertRows.count)")
        
        while newI < newResults.count {
            insertRows.append(NSIndexPath(forRow: indexPathRow, inSection: kIndexPathSection))
            newI += 1
            indexPathRow += 1
            
        }
        
        
        searchResults.removeAll()
        searchResults.appendContentsOf(newResults)
        print("filterInResults insertRows total in searchResults: \(searchResults.count) rows")
        
        
        if insertRows.isEmpty {
            return nil
        }
        
        return insertRows
    }
    
    
    
    func searchUsersWithPrefix(prefix:String) -> [UserUploadFriendModel] {
        
        var filteredList = usersList.filter { (userModel:UserUploadFriendModel) -> Bool in
            
            if userModel.userName.lowercaseString.hasPrefix(prefix.lowercaseString) {
                return true
            }
            return false
        }
        filteredList.sortInPlace { (user1, user2) -> Bool in
            
            if user1.userName.lowercaseString < user2.userName.lowercaseString {
                return true
            }
            return false
        }
        return filteredList
    }
}

