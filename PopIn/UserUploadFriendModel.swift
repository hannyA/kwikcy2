//
//  UserUploadFriendModel.swift
//  PopIn
//
//  Created by Hanny Aly on 8/19/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSS3
import AWSMobileHubHelper

class UserUploadFriendModel: UserSearchModel {
    
    
    var albumHorizontalImageClosure: ((image: UIImage?) -> ())?

    
    override var downloadFileURL :NSURL? {
        willSet {
            
            print("downloadFileURL setting: \(newValue)")
            if let downloadFileURL = newValue {
                if let data = NSData(contentsOfURL: downloadFileURL) {
                    
                    let image = UIImage(data: data)
                    if let avatarImageClosure = avatarImageClosure {
                        print("setAvatarCellNodeImage: \(newValue)")
                        avatarImageClosure(image: image)
                    }
                    if let albumCellNodeImage = albumHorizontalImageClosure {
                        print("setAvatarCellNodeImage: \(newValue)")
                        albumCellNodeImage(image: image)
                    }
                }
            } else {
                let failedPlaceHolderImage = UIImage(named: "DefaultProfileImage")
                
                if let avatarImageClosure = avatarImageClosure {
                    print("setAvatarCellNodeImage: \(newValue)")
                    avatarImageClosure(image: failedPlaceHolderImage)
                }
                if let albumCellNodeImage = albumHorizontalImageClosure {
                    print("setAvatarCellNodeImage: \(newValue)")
                    albumCellNodeImage(image: failedPlaceHolderImage)
                }
            }
        }
    }
    
    
}