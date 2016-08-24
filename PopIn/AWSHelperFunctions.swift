//
//  AWSHelperFunctions.swift
//  PopIn
//
//  Created by Hanny Aly on 6/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



        /*  
         ====================================================================
                My helpful AWS HelperFunctions
         ====================================================================
         */


func resultDetails(object: AnyObject?) -> [String: AnyObject]? {
    
    if object == nil {
        print("object == nil")
    } else if let resultArray = object as? [AnyObject] {
        print("resultArray = object")
        
    } else if object is NSDictionary  {
        print("object is NSDictionary")
        
        let objectAsDictionary: [String: AnyObject] = object as! [String: AnyObject]
        
        if objectAsDictionary.isEmpty {
            print("object is NSDictionary isEmpty")
            return objectAsDictionary
        } else {
            print("object is NSDictionary not isEmpty")
            return objectAsDictionary
            
        }
    }
    return nil
}