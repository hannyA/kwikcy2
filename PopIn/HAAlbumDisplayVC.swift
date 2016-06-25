//
//  HAAlbumDisplayVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/6/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


//import UIKit
import AsyncDisplayKit

protocol HAAlbumDisplayVCDelegate {
    func removeNewAlbumAtIndexPath(indexPath: NSIndexPath)
}

class HAAlbumDisplayVC: ASViewController, HAAlbumDisplayNodeDelegate {

    
    var delegate: HAAlbumDisplayVCDelegate?
    
    let displayNode: HAAlbumDisplayNode
    
    let albumModel: AlbumModel
    let newAlbumSection: Bool

    var timer: NSTimer?

    var isPaused = false
    var timeLeft:Double
//    var timeLimit:Double
    
    let indexPath: NSIndexPath
    
    var albumError = false
    
    init(album: AlbumModel, fromNewAlbumSection newSection: Bool, atIndexPath indexPath: NSIndexPath) {
    
        albumModel = album
        self.indexPath = indexPath
        newAlbumSection = newSection
        
        print("DisplayVC albumModel starting at: \(albumModel.newMediaIndex!) out of \(albumModel.mediaCount!). Current index: \(albumModel.currentItemIndex)")
        
        let firstItem:MediaModel
        
        if newAlbumSection {
            print("startWithNewContent")
            firstItem = albumModel.firstNewItem()!
        } else {
            firstItem = albumModel.firstItem()!
        }
        
        displayNode = HAAlbumDisplayNode(withMediaContent: firstItem)
        timeLeft = Double(firstItem.viewTime!)
        super.init(node: displayNode)
        
        
        displayNode.delegate = self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presentClearViewController()
    }
    
    
    
    func presentClearViewController() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.alpha = 1.0
            
        }) { (complete) in
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.timeLeftForMediaContent), userInfo: nil, repeats: true)
        }
    }
    
    
    
    
    func timeLeftForMediaContent() {
        
        print("Timeleft: \(timeLeft)")
        timeLeft -= 1
        if timeLeft <= 0 {
            showNextItem()
        }
    }
    
    
    func stopTimer() {
        timer?.invalidate()

    }
    
    func startTimer() {
        print("Timer has started")
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timeLeftForMediaContent), userInfo: nil, repeats: true)
    }
    
    
    
    
    
    /* *********************************************************************************************
       *********************************************************************************************
        
                Delegate methods for Album View
       *********************************************************************************************
       *********************************************************************************************
     */
    
    func closeAlbumVC() {
        
        
        if newAlbumSection && !albumModel.hasNewContent {
            delegate?.removeNewAlbumAtIndexPath(indexPath)
        }
        
        stopTimer()
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.alpha = 0.0
            
        }) { (complete) in
            
            self.navigationController?.popViewControllerAnimated(false)
        }
    }

    
    func pauseAlbum() {

        isPaused = !isPaused
        if isPaused {
            print("Timer is paused")
            stopTimer()

        } else {
            startTimer()
        }
    }
    func unPauseAlbum() {
        
        isPaused = false
    }
    
//    func startAlbum() {  }
//    
//    func previousAlbumMedia(){   }
//    func nextAlbumMedia() { }
    
    
    
    func showPreviousItem() {
        
        unPauseAlbum()

        print("showPreviousItem")

        if let nextMediaContent = albumModel.previousItem() {
            stopTimer()
            
            timeLeft = Double(nextMediaContent.viewTime!)
            
            let imageName = nextMediaContent.media
            
            displayNode.updateImageNamed(imageName!)
            
            startTimer()
            
        } else {
            
        }
    }
    
    func showNextItem() {
        print("HAAlbumDisplayVC showNextItem")
        unPauseAlbum()


        if let nextMediaContent = albumModel.nextItem() {

            stopTimer()

            timeLeft = Double(nextMediaContent.viewTime!)
            
            let imageName = nextMediaContent.media
            
            displayNode.updateImageNamed(imageName!)
            
            startTimer()
            
        } else {
            closeAlbumVC()
        }
    }
}



