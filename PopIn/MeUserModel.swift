//
//  MeUserModel.swift
//  PopIn
//
//  Created by Hanny Aly on 9/7/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class MeUserModel: UserModel {
    
    var acctId  : String?
    var email   : String?
    var mobile  : String?
    

    init() {
        
        let me = Me.sharedInstance
        
        email  = me.email()
        mobile = me.mobile()
        acctId = me.acctId()

        let userModel = UserModel.BasicInfo(guid: me.guid() ?? "null",
                                            username: me.username() ?? "null",
                                            fullname: me.fullname(),
                                            verified: me.verified(),
                                            blocked: false)
        
        let userInfo = UserSearchModel.dictionaryRep(userModel)

        
        super.init(withUser:userInfo, imageType: .Crop)
        
        about  = me.bio()
        domain = me.website()
    }
    
    
    func saveResponse(newData : HAEditProfileVC.UserData) {
        
        if let username = newData.username {
            print("response.newData: \(newData.username)")
            self.userName = username
            Me.sharedInstance.saveUsername(username)
        }
        
        if let fullname = newData.fullname {
            print("response.newData: \(newData.fullname)")
            self.fullName = fullname
            Me.sharedInstance.saveFullname(fullname)
        }
        
        if let website = newData.website {
            print("response.newData: \(newData.website)")
            self.domain = website
            Me.sharedInstance.saveWebsite(website)
        }
        
        if let bio = newData.bio {
            print("response.newData: \(newData.bio)")
            self.about = bio
            Me.sharedInstance.saveBio(bio)
        }
        
        if let email = newData.email {
            print("response.newData: \(newData.email)")
            self.email = email
            Me.sharedInstance.saveEmail(email)
        }
        
        if let mobile = newData.mobile {
            print("response.newData: \(newData.mobile)")
            self.mobile = mobile
            Me.sharedInstance.saveMobile(mobile)
        }
        
        //                            if let gender = response.newData.gender {
        //                                Me.saveGender(gender)
        //                            }
    }
    
    
}