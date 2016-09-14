//
//  UpdatedBoolResponse.swift
//  PopIn
//
//  Created by Hanny Aly on 9/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import Foundation

class UpdatedBoolResponse: ActiveResponse {
    
    
    var updatedValue: Bool?
    
    override init?(response result: AnyObject?) {
        
        super.init(response: result)
        
        if success {
            updatedValue = info[kUpdatedValue] as? Bool
        }
        
    }
}