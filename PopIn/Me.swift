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
        default:
            return nil
        }
    }
}



class Me {
    
    private static let mAcctId   = "Acctid"
    private static let mGuid     = "Guid"
    
    private static let mUsername = "Username"
    private static let mFullname = "Fullname"
    private static let mVerified = "Verified"
    private static let mWebsite  = "Website"
    private static let mBio      = "Bio"
    private static let mEmail    = "Email"
    private static let mMobile   = "Mobile"
    
    private static let mAge      = "Age"
    private static let mGender   = "Gender"
    private static let mProfileImage   = "ProfileImage"


    static let keychain = Keychain(service: "com.dromo.dromo-user")

    
    class func acctId() -> String? {
        
        if let acctId = try! keychain.get(mAcctId) {
            return acctId

        } else {
            return nil
        }
    }
    
    class func guid() -> String? {
        
        if let guid = try! keychain.get(mGuid) {
            return guid
            
        } else {
            return nil
        }
    }
    
    class func username() -> String? {
        
        if let username = try! keychain.get(mUsername) {
            return username
            
        } else {
            return nil
        }

    }
    
    class func fullname() -> String? {
        
        if let fullname = try! keychain.get(mFullname) {
            return fullname
            
        } else {
            return nil
        }
    }
    
    
    class func verified() -> Bool? {
        
        if let verified = try! keychain.get(mVerified)?.toBool() {
            return verified
            
        } else {
            return nil
        }
    }
    
    class func website() -> String? {
        
        if let website = try! keychain.get(mWebsite) {
            return website
            
        } else {
            return nil
        }
    }
    
    class func bio() -> String? {
        
        if let bio = try! keychain.get(mBio) {
            return bio
            
        } else {
            return nil
        }
    }
    
    class func email() -> String? {
        
        if let email = try! keychain.get(mEmail) {
            return email
            
        } else {
            return nil
        }
    }
    
    
    class func mobile() -> String? {
        
        if let mobile = try! keychain.get(mMobile) {
            return mobile
            
        } else {
            return nil
        }
    }
    
    class func gender() -> Int? {
        
        if let gender = try! keychain.get(mGender) {
            return Int(gender)
            
        } else {
            return nil
        }
    }
    
    class func age() -> String? {
        
        if let age = try! keychain.get(mAge) {
            return age
            
        } else {
            return nil
        }
    }
    
    
    class func profileImage() -> NSData? {
        
        if let data = try? keychain.getData(mProfileImage) {
            return data!
        } else {
            return nil
        }
    }

    
    
    
    
    
    
    class func saveGuid(guid: String) {
        keychain[mGuid] = guid
    }
    class func saveAcctid(id: String) {
        keychain[mAcctId] = id
    }
    class func saveUsername(username: String) {
        keychain[mUsername] = username
    }
    class func saveFullname(fullname: String) {
        keychain[mFullname] = fullname
    }
    class func saveVerification(verified: Bool) {
        keychain[mVerified] = verified.toString()
    }
    class func saveWebsite(website: String) {
        keychain[mWebsite] = website
    }
    class func saveBio(bio: String) {
        keychain[mBio] = bio
    }
    class func saveEmail(email: String) {
        keychain[mEmail] = email
    }
    class func saveMobile(mobile: String) {
        keychain[mMobile] = mobile
    }
    class func saveAge(age: String) {
        keychain[mAge] = age
    }
    class func saveGender(gender: Int) {
        keychain[mGender] = String(gender)
    }
    class func saveProfileImage(imageURL: NSURL) {
        keychain[data: mProfileImage] = NSData(contentsOfURL: imageURL)
    }
    
    
}