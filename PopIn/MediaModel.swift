//
//  MediaModel.swift
//  PopIn
//
//  Created by Hanny Aly on 6/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



class MediaModel {
    
    
    var photo: UIImage?
    var photoData: NSData?

    var media: String?
    var viewTime: Int?
    var date: String?
    var isNew: Bool

    var itemURL: NSURL?

    init(withImage image: String, andTimeLimit time: Int, isNew new: Bool ) {
        
        media = image
        viewTime = time
        isNew = new
    }
    
    init(withPhoto photo: UIImage ) {
        
        self.photo = photo
        isNew = true
    }
    
}