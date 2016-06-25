//
//  TESTFullAppModel.swift
//  PopIn
//
//  Created by Hanny Aly on 5/25/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


//@objc protocol TESTFullAppModelDelegate {
//    
//    // Call delegate to delete these these rows first
//    optional func filterOutSearchResultsWithPrefix(prefix: String) -> [NSIndexPath]
//    
//    // Call delegate to insert these these rows next
//    optional func filterInResults(prefix: String) -> [NSIndexPath]
//}

class TESTFullAppModel {
//    
//    static let sharedInstance = TheOneAndOnlyKraken()
//    private init() {} //This prevents others from using the default '()' initializer for this class.


    
    
    private let defaultNumberOfUsers = 30
    var kIndexPathSection: Int
    
    private var usersList: [UserModel] = [UserModel]()
    
    
    
    //    var gender = [UserModel.GenderType.Male , UserModel.GenderType.Female]
    private let gender = ["male", "female"]
    
    private var femalePhotos = ["Betty.jpeg", "claire.jpeg", "kate.jpeg", "peggy.jpeg", "red.jpeg",
                        "Sally.jpg", "Trudy.jpeg", "girl1.jpg", "girl2.jpg"]
    
    
    private var malePhotos = ["ben.jpeg", "desmond.jpeg", "don.jpeg", "Harry Crane.jpeg",
                      "jack.jpeg", "james.jpeg", "ken.jpeg",
                      "Lane Pryce.jpeg", "Pete.jpeg", "Roger Sterling.jpg",
                      "Stan.jpeg", "ted.jpeg", "boy1.jpg", "boy2.jpg",
                      "boy3.jpg", "boy4.jpg"]
    
    private let userPhotoList = ["ben.jpeg", "Betty.jpeg", "claire.jpeg",
                         "desmond.jpeg", "don.jpeg", "Harry Crane.jpeg",
                         "jack.jpeg", "james.jpeg", "kate.jpeg",
                         "ken.jpeg", "Lane Pryce.jpeg", "peggy.jpeg",
                         "Pete.jpeg", "red.jpeg", "Roger Sterling.jpg",
                         "Sally.jpg", "Stan.jpeg", "ted.jpeg",
                         "Trudy.jpeg", "girl1.jpg", "girl2.jpg",
                         "boy1.jpg", "boy2.jpg", "boy3.jpg",
                         "boy4.jpg"]
    
    
    private let usernames = ["tom", "ben", "ron", "bets", "dog", "drop",
                     "renner", "rogger", "boo", "carr", "cat",
                     "adena", "africa", "arina", "app", "adella", ""]
    
    
    
    
    private let usernamesStartingWithA = ["appleaba", "appleabc", "appleabf", "appleabgr","appleabrd","appleabfd",
                                  "appleafef", "appleabafe", "appleabrgo", "appleabse", "applexef", "applebxc",
                                  "appleaare", "apple", "apple", "apple", "apple", "apple",
                                  "apple", "apple", "apple", "apple", "apple", "apple"]
    

    
    private let firstNames = ["tom", "ben", "ron", "bets", "dog", "drop",
                      "renner", "rogger", "boo", "carr", "cat",
                      "adena", "africa", "arina", "app", "adella"]
    
    private let maleNames = ["noah", "liam", "mason", "jacob", "william", "ethan",
                     "james", "alex", "alexander", "michael", "ben",
                     "benjamin", "elijah", "daniel", "aiden", "logan",
                     "matthew", "lucas", "jackson", "david", "oliver", "jayden",
                     "joseph", "gabriel", "samuel", "carter", "anthony", "john",
                     "dylan", "luke", "andrew", "henry", "isaac",
                     "christopher", "joshua", "wyatt", "sebastian", "owen", "caleb", "nathan", "ryan", "jack", "levi", "julian"]
    
    private let femalesNames = ["emma", "olivia", "sophia", "ava", "isabella", "mia",
                        "abigail", "emily", "charlotte", "harper", "madison",
                        "amelia", "elizabeth", "sofia", "evelyn", "avery", "chloe",
                        "ella", "grace", "victoria", "aubrey", "scarlett",
                        "zoey", "addison", "lily", "lillian", "hannah", "natalie",
                        "aria", "layla", "alexa", "zoe", "riley",
                        "leah", "allison", "nora", "sammy", "samantha", "skylar",
                        "camila", "anna", "violet", "sadie", "lucy"]
    
    
    private let lastNames = ["smith", "jones", "brown", "johnson", "williams", "taylor",
                     "davis", "miller", "wilson", "white", "black", "clark", "thomas", "hall",
                     "thompson", "moore","hill", "walker", "wright", "martin", "allen",
                     "robinson", "wood", "adams", "jackson", "evans", "lewis", "green",
                     " aderson", "king", "baker", "roberts", "harris", "john", "john",
                     "scott", "young", "lee", "james", "parker", "turner", "cook", "campbell",
                     "edwards", "davies", "morris", "county", "stewart", "phillips", "cooper",
                     "hughes", "bell", "watson", "carter", "harrison", "richardson", "murrphy",
                     "collins", "foster", "gray", "reed", "howard"]
    
    
    private let verifcation = [true, false]
    
    
    
    
    
    
    private func randomVerification() -> Bool {
        
        let randomNumber = Int(arc4random_uniform(UInt32(verifcation.count)))
        return verifcation[randomNumber]
        
    }
    
    
    
    
    
    //  predicate example
    private func useridIsUnique(userId: String) -> Bool {
        
        let useridIndex = usersList.indexOf({ (userModel: UserModel) -> Bool in
            
            if userModel.userId == userId {
                return true
            }
            return false
        })
        
        if useridIndex == nil {
            return true
        }
        return false
    }
    
    
    private func confirmedUniqueId() -> String {
    
        var randomId = randomUserid()

        while !useridIsUnique(randomId) {
            randomId = randomUserid()
        }
        return randomId
    }
    
    
    private func randomUserid() -> String {
        return String(Int(arc4random_uniform(UInt32(100000))))
    }
    
    private func randomNumberString() -> String {
        return String(Int(arc4random_uniform(UInt32(200))))
    }
    
    
    
    
    
    private func usernameIsUnique(username: String) -> Bool {
        
        let useridIndex = usersList.indexOf({ (userModel: UserModel) -> Bool in
            
            if userModel.userName == username {
                return true
            }
            return false
        })
        
        if useridIndex == nil {
            return true
        }
        return false
    }
    
    
    private func confirmedUniqueUsername() -> String {
        
        var randomName = randomUsername()
        
        while !usernameIsUnique(randomName) {
            randomName = randomUsername()
        }
        return randomName
    }
    
    
    private func randomNameFromRandomList() -> String {
        
        let arrIndex =  Int(arc4random_uniform(UInt32(4)))
        
        let choices = [firstNames, lastNames, maleNames, femalesNames]
        
        let namesList = choices[arrIndex]
        let nameIndex =  Int(arc4random_uniform(UInt32(namesList.count)))
        return namesList[nameIndex]
    }
    
    private func randomUsername() -> String {
        
        let firstPart = randomNameFromRandomList()
        let secondPart = randomNameFromRandomList()
    
        let thirdPart = randomNumberString()
        return firstPart + secondPart + thirdPart
    }
    
    
    
    private func randomGender() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(2)))
        return gender[randomNumber]
    }
    
    private  func randomLastname() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(lastNames.count)))
        return lastNames[randomNumber]
    }
    
    
    
    
    private  func about() -> String {
        return "siniff ensono fefsff efsfsifn efifnef"
    }
    
    
    
    private  func city() -> String {
        return "Florham Park"
    }
    
    
    private  func state() -> String {
        return "NJ"
    }
    
    
    private  func country() -> String {
        return "USA"
    }
    
    
    private  func domainWebLink() -> String {
        return "www.example.com"
    }
    
    
    
    
    
    private  func randomMaleFirstname() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(maleNames.count)))
        return maleNames[randomNumber]
    }
    
    private  func randomFemaleFirstname() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(femalesNames.count)))
        return femalesNames[randomNumber]
    }
    
    
    
    private  func randomMalePhoto() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(malePhotos.count)))
        return malePhotos[randomNumber]
    }
    
    
    private  func randomFemalePhoto() -> String {
        let randomNumber =  Int(arc4random_uniform(UInt32(femalePhotos.count)))
        return femalePhotos[randomNumber]
    }
    
    
    
//    class TheOneAndOnlyKraken {
//        static let sharedInstance = TheOneAndOnlyKraken()
//        private init() {} //This prevents others from using the default '()' initializer for this class.
//    }
    
    
    init() {
        kIndexPathSection = 0
        createUserSearchDataSource(defaultNumberOfUsers)
    }
    init(indexPathSection section: Int) {
        kIndexPathSection = section
        createUserSearchDataSource(defaultNumberOfUsers)
    }
    
    
    init(numberOfUsers number: Int) {
        kIndexPathSection = 0
        createUserSearchDataSource(number)
    }
    
    
    func createUser() -> UserModel {
        
        
        var dict = [String: AnyObject]()
        
        let gender = randomGender()
        
        if gender == "male" {
            dict["gender"] = gender
            dict["firstName"]   = randomMaleFirstname()
            dict["userTestPic"] = randomMalePhoto() //UIImage(named: randomPhoto())
        } else {
            dict["gender"] = gender
            dict["firstName"]   = randomFemaleFirstname()
            dict["userTestPic"] = randomFemalePhoto() //UIImage(named: randomPhoto())
        }
        
        dict["userId"]    = confirmedUniqueId()
        
        dict["userName"]  = confirmedUniqueUsername()
        dict["lastName"]  = randomLastname()
        
        let a = dict["userName"] as! String
        
        print("username \(a)")
        dict["fullName"] =  (dict["firstName"] as! String) + " " + (dict["lastName"] as! String)
        
        dict["following"]   = false
        dict["friends"]     = false
        
        dict["verified"] = randomVerification()
        dict["about"]    = about()
        dict["domain"]   = domainWebLink()
        
        
        return UserModel(withUser: dict)
    }
    
    func firstUser() -> UserModel? {
        return usersList.first!
    }
    
    func lastUser() -> UserModel? {
       
        if !usersList.isEmpty {
            usersList.last
        }
        return nil
    }
    
    func userCount() -> Int {
        return usersList.count
    }
    
    func userAtIndex(index: Int) -> UserModel {
        return usersList[index]
    }
    
    
    
    func allUsers() -> [UserModel] {
        return usersList
    }
    
    
    
    
    func createUserSearchDataSource(numberOfUsers: Int) {
        for _ in 0..<numberOfUsers {
            usersList.append(createUser())
        }
        
        print("usersList count = \(usersList.count)")

        usersList.sortInPlace { (user1, user2) -> Bool in
            
            if user1.userName?.lowercaseString < user2.userName?.lowercaseString {
                return true
            }
            return false
        }
        print("sorted usersList count = \(usersList.count)")

    }
    
    
    
    
    /*  
        ==========================================================================================
        ==========================================================================================
                        Search functions
        ==========================================================================================
        ==========================================================================================
    */
    
    private var searchResults = [UserModel]()

    func searchResultAtIndex(index: Int) -> UserModel {
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
            if let name = user.userName {
                if !name.lowercaseString.hasPrefix(prefix.lowercaseString) {
                    deletedRows.append(NSIndexPath(forRow: i, inSection: kIndexPathSection))
                }
            }
        }
        print("filterOutSearchResultsWithPrefix  deleted count: \(deletedRows.count)")

        searchResults = searchResults.filter { (userModel: UserModel) -> Bool in
            
            if let name = userModel.userName {
                if name.lowercaseString.hasPrefix(prefix.lowercaseString) {
                    return true
                }
            }
            return false
        }
        print("filterOutSearchResultsWithPrefix searchResults count: \(searchResults.count)")

        return deletedRows
    }
    
    
    
    
    func filterInResults(prefix: String) -> [NSIndexPath]? {
        
        var newResults:[UserModel] = [UserModel]()
            
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
            
            if newResults[newI].userName?.lowercaseString < searchResults[searchIndex].userName?.lowercaseString {
                insertRows.append(NSIndexPath(forRow: indexPathRow, inSection: kIndexPathSection))
                newI += 1
            }
            else if newResults[newI].userName?.lowercaseString == searchResults[searchIndex].userName?.lowercaseString {
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
    
    
    
    func searchUsersWithPrefix(prefix:String) -> [UserModel] {
    
        var filteredList = usersList.filter { (userModel:UserModel) -> Bool in
            
            if let username = userModel.userName {
                if username.lowercaseString.hasPrefix(prefix.lowercaseString) {
                    return true
                }
            }
            return false
        }
        filteredList.sortInPlace { (user1, user2) -> Bool in
            
            if user1.userName?.lowercaseString < user2.userName?.lowercaseString {
                return true
            }
            return false
        }
        return filteredList
    }
}

