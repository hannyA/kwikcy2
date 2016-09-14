//
//  ActiveResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 9/5/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation


// Login/Signin variables
enum UserActiveStatus: Int {
    case DoesNotExist = 0
    case Active       = 1
    case Deleted      = 2
    case Disabled     = 3
    case DisabledConfirmed = 4
}

class ActiveResponse {
    
    class func activeStatusFromValue(int: Int) -> UserActiveStatus {
        switch int {
        case 0:
            return .DoesNotExist
        case 1:
            return .Active
        case 2:
            return .Deleted
        case 3:
            return .Disabled
        case 4:
            return .DisabledConfirmed
        default:
            return .Active
        }
    }
    
    
    let info : [String: AnyObject]
    let userActiveStatus:UserActiveStatus
    let success         : Bool
    var errorMessage    : String?
    
    
    init?(response result: AnyObject?) {
        
        if let response = result as? [String: AnyObject]  {
            
            info = response
            if let status = response[kActive] as? Int {
                
                userActiveStatus = ActiveResponse.activeStatusFromValue(status)
                
                if userActiveStatus == .Active {
                    success = response[kSuccess] as! Bool
                } else {
                    success = false
                }
                    
                
                if let error = response[kErrorMessage] as? String {
                    errorMessage = error
                }
                
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}