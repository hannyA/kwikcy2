//
//  HAFacebookExampleCode.swift
//  PopIn
//
//  Created by Hanny Aly on 9/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

//let facebookToken = FBSDKAccessToken.currentAccessToken()
//let tokenString = facebookToken.tokenString
// let tokenExpiration = facebookToken.expirationDate

//
//
//                let req = FBSDKGraphRequest(graphPath: "me",
////                    parameters: ["fields": "name, first_name, last_name, id, email, gender, is_verified, birthday, friends, photos"],
//
//                    parameters: ["fields": "id, is_verified"],
//
//                    tokenString: tokenString,
//                    version: nil,
//                    HTTPMethod: "GET")

/*
 
 *  All we need for now is -> id and is_verified
 *  id -> facebook id
 *
 *  is_verified -> will only be used for public albums and search, so we don't need it now.
 
 *  link -> Web domain
 
 *  first_name, last_name, name, email, gender, birthday/age_range -> Profile
 
 *  friends -> To find friends
 *  photos  -> To change profile pic
 *
 *
 */
//                print("Request to facebook. On main thread? \(NSThread.isMainThread())")
//                req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
//                print("Request from facebook. On main thread? \(NSThread.isMainThread())")
//
//                    var verified = false
//                    var facebookId: String?
//
//                    if let result = result as? [String: AnyObject] {
//
//                        if let isVerified = result["is_verified"] as? Bool {
//                            verified = isVerified
//                        }
//                        if let fbid = result["id"] as? String {
//                            facebookId = fbid
//                        }
//                    }
//
//                    if let error = error {
//                        print("error \(error)")
//                    } else {
//                        print("result \(result)")
//                    }

