////
////  TESTSearchModel.swift
////  PopIn
////
////  Created by Hanny Aly on 5/20/16.
////  Copyright © 2016 Aly LLC. All rights reserved.
////
//
//import Foundation
//
//class TESTSearchModel {
//    
//    var usersList: [UserModel] = [UserModel]()
//    
//    let defaultNumberOfUsers = 30
//    
//    
////    var gender = [UserModel.GenderType.Male , UserModel.GenderType.Female]
//    let gender = ["male", "female"]
//    
//    var femalePhotos = ["Betty.jpeg", "claire.jpeg", "kate.jpeg", "peggy.jpeg", "red.jpeg",
//                        "Sally.jpg", "Trudy.jpeg", "girl1.jpg", "girl2.jpg"]
//    
//    
//    var malePhotos = ["ben.jpeg", "desmond.jpeg", "don.jpeg", "Harry Crane.jpeg",
//                      "jack.jpeg", "james.jpeg", "ken.jpeg",
//                       "Lane Pryce.jpeg", "Pete.jpeg", "Roger Sterling.jpg",
//                       "Stan.jpeg", "ted.jpeg", "boy1.jpg", "boy2.jpg",
//                       "boy3.jpg", "boy4.jpg"]
//    
//    let userPhotoList = ["ben.jpeg", "Betty.jpeg", "claire.jpeg",
//                         "desmond.jpeg", "don.jpeg", "Harry Crane.jpeg",
//                         "jack.jpeg", "james.jpeg", "kate.jpeg",
//                         "ken.jpeg", "Lane Pryce.jpeg", "peggy.jpeg",
//                         "Pete.jpeg", "red.jpeg", "Roger Sterling.jpg",
//                         "Sally.jpg", "Stan.jpeg", "ted.jpeg",
//                         "Trudy.jpeg", "girl1.jpg", "girl2.jpg",
//                         "boy1.jpg", "boy2.jpg", "boy3.jpg",
//                         "boy4.jpg"]
//    
//    
//    let usernames = ["tom", "ben", "ron", "bets", "dog", "drop",
//                     "renner", "rogger", "boo", "carr", "cat",
//                     "adena", "africa", "arina", "app", "adella", ""]
//    
//    
//    
//    
//    let usernamesStartingWithA = ["appleaba", "appleabc", "appleabf", "appleabgr","appleabrd","appleabfd",
//                     "appleafef", "appleabafe", "appleabrgo", "appleabse", "applexef", "applebxc",
//                     "appleaare", "apple", "apple", "apple", "apple", "apple",
//                     "apple", "apple", "apple", "apple", "apple", "apple"]
//    
//    
//    
//    let firstNames = ["tom", "ben", "ron", "bets", "dog", "drop",
//                     "renner", "rogger", "boo", "carr", "cat",
//                     "adena", "africa", "arina", "app", "adella", ""]
//    
//    let maleNames = ["noah", "liam", "mason", "jacob", "william", "ethan",
//                     "james", "alex", "alexander", "michael", "ben",
//                     "benjamin", "elijah", "daniel", "aiden", "logan",
//                     "matthew", "lucas", "jackson", "david", "oliver", "jayden",
//                     "joseph", "gabriel", "samuel", "carter", "anthony", "john",
//                     "dylan", "luke", "andrew", "henry", "isaac",
//                     "christopher", "joshua", "wyatt", "sebastian", "owen", "caleb", "nathan", "ryan", "jack", "levi", "julian"]
//    
//    let femalesNames = ["emma", "olivia", "sophia", "ava", "isabella", "mia",
//                        "abigail", "emily", "charlotte", "harper", "madison",
//                     "amelia", "elizabeth", "sofia", "evelyn", "avery", "chloe",
//                     "ella", "grace", "victoria", "aubrey", "scarlett",
//                     "zoey", "addison", "lily", "lillian", "hannah", "natalie",
//                     "aria", "layla", "alexa", "zoe", "riley",
//                     "leah", "allison", "nora", "sammy", "samantha", "skylar",
//                     "camila", "anna", "violet", "sadie", "lucy"]
//    
//    
//    let lastNames = ["smith", "jones", "brown", "johnson", "williams", "taylor",
//                     "davis", "miller", "wilson", "white", "black", "clark", "thomas", "hall",
//                     "thompson", "moore","hill", "walker", "wright", "martin", "allen",
//                     "robinson", "wood", "adams", "jackson", "evans", "lewis", "green",
//                     " aderson", "king", "baker", "roberts", "harris", "john", "john",
//                     "scott", "young", "lee", "james", "parker", "turner", "cook", "campbell",
//                     "edwards", "davies", "morris", "county", "stewart", "phillips", "cooper",
//                     "hughes", "bell", "watson", "carter", "harrison", "richardson", "murrphy",
//                     "collins", "foster", "gray", "reed", "howard"]
//    
//    
//    
//
//    
//    
//    
//    let verifcation = [true, false]
//
//    func randomVerification() -> Bool {
//         
//        let randomNumber = Int(arc4random_uniform(UInt32(verifcation.count)))
//        return verifcation[randomNumber]
//
//    }
//    
//    
//
//    func randomUserid() -> String {
//         return String(Int(arc4random_uniform(UInt32(100000))))
//    }
//    
//    
//    func randomUsername() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(usernamesStartingWithA.count)))
//        return usernamesStartingWithA[randomNumber]
//    }
//    
//    func randomGender() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(2)))
//        return gender[randomNumber]
//    }
//    
//    func randomLastname() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(lastNames.count)))
//        return lastNames[randomNumber]
//    }
//    
//    
//    
//    
//    func about() -> String {
//        return "siniff ensono fefsff efsfsifn efifnef"
//    }
//    
//    
//    
//    func city() -> String {
//        return "Florham Park"
//    }
//    
//    
//    func state() -> String {
//        return "NJ"
//    }
//    
//    
//    func country() -> String {
//        return "USA"
//    }
//
//    
//    func domainWebLink() -> String {
//        return "www.example.com"
//    }
//
//    
//    
//    
//    
//    func randomMaleFirstname() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(maleNames.count)))
//        return maleNames[randomNumber]
//    }
//    
//    func randomFemaleFirstname() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(femalesNames.count)))
//        return femalesNames[randomNumber]
//    }
//    
//    
//    
//    func randomMalePhoto() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(malePhotos.count)))
//        return malePhotos[randomNumber]
//    }
//    
//    
//    func randomFemalePhoto() -> String {
//        let randomNumber =  Int(arc4random_uniform(UInt32(femalePhotos.count)))
//        return femalePhotos[randomNumber]
//    }
//    
//    
//    init() {
//
//        createUserSearchDataSource(withNumberOfUsers: defaultNumberOfUsers)
//    }
//    
//    
//    init(numberOfUesrs number: Int) {
//        createUserSearchDataSource(withNumberOfUsers: number)
//    }
//    
//    
//    
//    
//    
//    func createUser() -> UserModel {
//        
//        
//        var dict = [String: AnyObject]()
//        
//        let gender = randomGender()
//        
//        if gender == "male" {
//            dict["gender"] = gender
//            dict["firstName"]   = randomMaleFirstname()
//            dict["userTestPic"] = randomMalePhoto() //UIImage(named: randomPhoto())
//        } else {
//            dict["gender"] = gender
//            dict["firstName"]   = randomFemaleFirstname()
//            dict["userTestPic"] = randomFemalePhoto() //UIImage(named: randomPhoto())
//        }
//        
//        dict["userId"]    = randomUserid()
//        dict["username"]  = randomUsername()
//        dict["lastName"]  = randomLastname()
//
//        dict["fullName"] =  (dict["firstName"] as! String) + " " + (dict["lastName"] as! String)
//        
//        dict["following"]   = false
//        dict["friends"]     = false
//        
//        dict["verified"] = randomVerification()
//        dict["about"]    = about()
//        dict["domain"]   = domainWebLink()
//
//        
//        return UserModel(withUser: dict)
//    }
//    
//    func createUserSearchDataSource(withNumberOfUsers users: Int ) {
//        for _ in 1...users {
//            usersList.append(createUser())
//        }
//    }
//    
//    
//    func searchUsersWithPrefix(prefix:String) -> [UserModel] {
//        
//        var searchResults: [UserModel] = [UserModel]()
//
//        for user in usersList {
//            if user.userName.lowercaseString.hasPrefix(prefix.lowercaseString) {
//                searchResults.append(user)
//            }
//        }
//        
//        return searchResults
//        
//    }
//    
//}