//
//  Me.swift
//  PopIn
//
//  Created by Hanny Aly on 7/27/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import KeychainAccess


private extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}


private extension Bool {
    func toString() -> String? {
        switch self {
        case true:
            return "True"
        case false:
            return "False"
        }
    }
}



class Me {
    
    static let sharedInstance = Me()

    
    
    
    private let mAcctId   = "Acctid"
    private let mGuid     = "Guid"
    
    private let mUsername = "Username"
    private let mFullname = "Fullname"
    private let mVerified = "Verified"
    private let mWebsite  = "Website"
    private let mBio      = "Bio"
    private let mEmail    = "Email"
    private let mMobile   = "Mobile"
    
    private let mAge      = "Age"
    private let mGender   = "Gender"
    private let mProfileImage   = "ProfileImage"


    
    private let keychain = Keychain(service: "com.dromo.dromo-user")

    
    /* If we save user data, what to do?
     *      1) Log user back out?
     *      2) Store in NSUserdefault?
     */
    
    func acctId() -> String? {
        
        if let acctId = try! keychain.get(mAcctId) {
            return acctId

        } else {
            return nil
        }
    }
    
    func guid() -> String? {
        
        if let guid = try! keychain.get(mGuid) {
            return guid
            
        } else {
            return nil
        }
    }
    
    
    func username() -> String? {
        
        if let username = try! keychain.get(mUsername) {
            return username
            
        } else {
            return nil
        }

    }
    
    
    func fullname() -> String? {
        
        if let fullname = try! keychain.get(mFullname) {
            return fullname
            
        } else {
            return nil
        }
    }
    
    
    
    func verified() -> Bool? {
        
        if let verified = try! keychain.get(mVerified)?.toBool() {
            return verified
            
        } else {
            return nil
        }
    }
    
    
    func website() -> String? {
        
        if let website = try! keychain.get(mWebsite) {
            return website
            
        } else {
            return nil
        }
    }
    
    
    func bio() -> String? {
        
        if let bio = try! keychain.get(mBio) {
            return bio
            
        } else {
            return nil
        }
    }
    
    
    func email() -> String? {
        
        if let email = try! keychain.get(mEmail) {
            return email
            
        } else {
            return nil
        }
    }
    
    
    
    func mobile() -> String? {
        
        if let mobile = try! keychain.get(mMobile) {
            return mobile
            
        } else {
            return nil
        }
    }
    
    
    func gender() -> Int? {
        
        if let gender = try! keychain.get(mGender) {
            return Int(gender)
            
        } else {
            return nil
        }
    }
    
    
    func age() -> String? {
        
        if let age = try! keychain.get(mAge) {
            return age
            
        } else {
            return nil
        }
    }
    
    
    
    func profileImage() -> NSData? {
        
        if let data = try? keychain.getData(mProfileImage) {
            return data!
        } else {
            return nil
        }
    }

    
    func wipeData() -> Bool {
        
        do {
            try keychain.removeAll()
            return true
        } catch let error {
            print("error: \(error)")
            return false
        }
    }
    
    
    
//    
//    class func saveGuid(guid: String) {
//        keychain[mGuid] = guid
//    }
//    class func saveAcctid(id: String) {
//        keychain[mAcctId] = id
//    }
//    class func saveUsername(username: String) {
//        keychain[mUsername] = username
//    }
//    class func saveFullname(fullname: String) {
//        keychain[mFullname] = fullname
//    }
//    class func saveVerification(verified: Bool) {
//        keychain[mVerified] = verified.toString()
//    }
//    class func saveWebsite(website: String) {
//        keychain[mWebsite] = website
//    }
//    class func saveBio(bio: String) {
//        keychain[mBio] = bio
//    }
//    class func saveEmail(email: String) {
//        keychain[mEmail] = email
//    }
//    class func saveMobile(mobile: String) {
//        keychain[mMobile] = mobile
//    }
//    class func saveAge(age: String) {
//        keychain[mAge] = age
//    }
//    class func saveGender(gender: Int) {
//        keychain[mGender] = String(gender)
//    }
//    class func saveProfileImage(imageURL: NSURL) {
//        keychain[data: mProfileImage] = NSData(contentsOfURL: imageURL)
//    }
//    
    
    
    
    
    
    
    
    
    
    
    func saveGuid(guid: String) {
        keychain[mGuid] = guid
    }
    
    func saveAcctid(id: String) {
        keychain[mAcctId] = id
    }
    
    func saveUsername(username: String) {
        keychain[mUsername] = username
    }
    
    func saveFullname(fullname: String) {
        keychain[mFullname] = fullname
    }
    
    func saveVerification(verified: Bool) {
        keychain[mVerified] = verified.toString()
    }
    
    func saveWebsite(website: String) {
        keychain[mWebsite] = website
    }
    
    func saveBio(bio: String) {
        keychain[mBio] = bio
    }
    
    func saveEmail(email: String) {
        keychain[mEmail] = email
    }
    
    func saveMobile(mobile: String) {
        keychain[mMobile] = mobile
    }
    
    func saveAge(age: String) {
        keychain[mAge] = age
    }
    
    func saveGender(gender: Int) {
        keychain[mGender] = String(gender)
    }
    
    func saveProfileImage(imageURL: NSURL) {
        keychain[data: mProfileImage] = NSData(contentsOfURL: imageURL)
    }

    
    
}