//
//  LambdaErrorResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 7/31/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import Foundation

class LambdaErrorResponse {
    
    
    let message: String
  
    init(response result: AnyObject?) {
        
        if let response  = result as? [String: AnyObject]  {
            
            if let error = response["ErrorMessage"] as? String {
                
                message = error
            } else  {
                message = AWSErrorBackend
            }
        } else {
            message = AWSErrorBackend
        }
    }
}