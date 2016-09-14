////
////  HAAlbumDisplayVC.swift
////  PopIn
////
////  Created by Hanny Aly on 6/6/16.
////  Copyright © 2016 Aly LLC. All rights reserved.
////
//
//
////import UIKit
//import AsyncDisplayKit
//
//
//
//class HAAlbumDisplayVC: ASViewController, HAAlbumDisplayNodeDelegate, MediaModelDelegate {
//
//    
//    let albumDisplayNode: HAAlbumDisplayNode
//    
//    var timeLeft:Double?
//        
//    var albumError = false
//    
//    var currentMediaContent: MediaModel
//
//    
//    init(firstMediaModel: MediaModel ) {
//    
//        // Change to loading images and video
//
//        currentMediaContent = firstMediaModel
//
//        albumDisplayNode = HAAlbumDisplayNode(mediaContent: currentMediaContent)
//
//        super.init(node: albumDisplayNode)
//    
//        view.backgroundColor = UIColor.clearColor()
//
//        albumDisplayNode.delegate    = self
//        currentMediaContent.delegate = self
//        
//    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
//    
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        view.alpha = 0.0
//        albumDisplayNode.hidden = true
//      
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//
//        
//        print("View did appear")
//        
//        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseIn , animations: {
//            
//            self.view.alpha = 1.0
//            self.albumDisplayNode.hidden = false
//      }) { (complete) in
//            
//            print("View did appear: Starting timer")
//
//            self.startCurrentTimer()
//        }
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
// 
//    }
//    
//    
//    func updateVCForTimeLeft(timeLeft: Int) {
//       
//        print("Timeleft: \(timeLeft)")
//        
//        if timeLeft <= 0 {
//            showNextItem()
//        }
//    }
//    
//    
//    
//    
//    
//    
//    /* *********************************************************************************************
//       *********************************************************************************************
//        
//                Delegate methods for Album View
//       *********************************************************************************************
//       *********************************************************************************************
//     */
//    
//    func closeAlbumVC() {
//        
//        stopCurrentTimer()
//        
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
//            self.view.alpha = 0.0
//            
//        }) { (complete) in
//            self.dismissViewControllerAnimated(false, completion: nil)
//        }
//    }
//    
//
//    func startCurrentTimer() {
//        print("startCurrentTimer")
//        currentMediaContent.startTimer()
//    }
//    
//    func stopCurrentTimer() {
//        print("stopCurrentTimer")
//        currentMediaContent.stopTimer()
//    }
//    
//    
//    
//    func setupCurrentMedia(mediaContent: MediaModel) {
//        
//        currentMediaContent = mediaContent
//        
//        if currentMediaContent.type == .Photo {
//            let image = UIImage(data: currentMediaContent.mediaData)
//            
//            albumDisplayNode.imageNode.image = image
//            currentMediaContent.delegate = self
//        }
//    }
//    
//    
//    
//    func changeCurrentMediaContent(mediaContent: MediaModel) {
//        
//        stopCurrentTimer()
//        
//        setupCurrentMedia(mediaContent)
//       
//        startCurrentTimer()
//    }
//    
//    
//    
//    
//    func showPreviousItem() {
//        
//        print("===============================================================")
//        print("             HAAlbumDisplayVC ShowPreviousItem  ")
//        print("===============================================================")
//
//        if let previousMediaContent = albumModel.previousItem() {
//            
//            changeCurrentMediaContent(previousMediaContent)
//        } else {
//            print("This is the first image, Can't go back")
//        }
//    }
//    
//    func showNextItem() {
//        print("===============================================================")
//        print("            HAAlbumDisplayVC showNextItem")
//        print("===============================================================")
//
//        if let nextMediaContent = albumModel.nextItem() {
//            
//            changeCurrentMediaContent(nextMediaContent)
//            
//        } else {
//            closeAlbumVC()
//        }
//    }
//}
//
//
//
