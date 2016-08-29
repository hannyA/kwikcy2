//
//  Album.swift
//  PopIn
//
//  Created by Hanny Aly on 8/28/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import RealmSwift


        /*  We will need to use this especially when a user creates a new album 
            
            and we then check on our albums in our profile section
         */
 
/*
 *  What we will store in persistence:
 *  
 *  1) The users albums, we can moitor the time on ourselves and have them deleted... 
 *          Maybe query the databse for updates, in case the internal clock changes
 * 
 *      These things will/can change, so do we store them?
 
 *  2) Friends albums?
 *  3) Users friends, excluding the photos?, because the user does chagne them, as well as usernames?
 *  4)
 */



class User: Object {
    
    dynamic var guid = ""
    dynamic var userName = ""
    dynamic var fullName = ""
}

    func userList(users: [String]) -> List<User> {
        
        let usersList = List<User>()
        for user in users {
            let u = User()
            u.guid = user
            
            usersList.append(u)
        }
        return usersList
    }

class Album: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var guid = ""
    dynamic var username = ""
    dynamic var owner: User? // Properties can be optional

    let acl = List<User>()

}


class Albums: Object {
    let albums = List<Album>()
}




