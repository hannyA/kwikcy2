//
//  HAAlbumDisplayModel.swift
//  PopIn
//
//  Created by Hanny Aly on 6/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//



//class HAAlbumDisplayModel {
//    
//    
//    
//    var mediaContent: AlbumModel
//
//    var currentItemIndex: Int
//    
//    init(withItems newItems: [HADisplayMediaModel]) {
//     
//        mediaContent = newItems
//        currentItemIndex = 0
//    }
//    
//    func numberOfItems() -> Int {
//        return mediaContent.count
//    }
//    
//    
//    func appendItems(moreItems: [HADisplayMediaModel]) {
//        
//        for newItem in moreItems {
//            mediaContent.append(newItem)
//        }
//    }
//    
//    
//    func firstItem() -> HADisplayMediaModel? {
//      
//        if !mediaContent.isEmpty {
//            currentItemIndex = 0
//            return mediaContent[currentItemIndex]
//            
//        }
//        return nil
//    }
//    
//    func nextItem() -> HADisplayMediaModel? {
//        
//        if currentItemIndex < (mediaContent.count - 1) {
//            currentItemIndex += 1
//            return mediaContent[currentItemIndex]
//        }
//        return nil
//    }
//    
//    func previousItem() -> HADisplayMediaModel? {
//      
//        if currentItemIndex > 0 {
//            currentItemIndex -= 1
//            return mediaContent[currentItemIndex]
//        }
//        return nil
//    }
//}