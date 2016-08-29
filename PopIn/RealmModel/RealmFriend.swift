//
//  RealmFriend.swift
//  PopIn
//
//  Created by Hanny Aly on 8/28/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFriend: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
        
    dynamic var guid = ""
    dynamic var userName = ""
    dynamic var fullName = ""
    dynamic var picture: NSData? = nil

}
