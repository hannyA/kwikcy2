//
//  Realm+Utilities.swift
//  PopIn
//
//  Created by Hanny Aly on 8/28/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
//import Realm

import RealmSwift

//extension Realm {
//    
//    
//    class func UsersRealm() {
//        
//    }
//    // Get the default Realm
//    let realm = try! Realm()
//    // You only need to do this once (per thread)
//    
//    // Add to the Realm inside a transaction
//    try! realm.write {
//    realm.add(author)
//    }
//    
//}


class RealmsUtilities {
    
    // Each identity has its own realm
    class func setDefaultRealmForUser(guid: String) {
        
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(guid).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}