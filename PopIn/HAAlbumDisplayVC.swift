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
    func removeNewAlbum(album: AlbumModel)
}

class HAAlbumDisplayVC: ASViewController, HAAlbumDisplayNodeDelegate, MediaModelDelegate {

    
    var delegate: HAAlbumDisplayVCDelegate?
    
    let albumDisplayNode: HAAlbumDisplayNode
    
    let albumModel: AlbumModel
    let isNewAlbumSection: Bool

    var timeLeft:Double?
    
    let indexPath: NSIndexPath
    
    var albumError = false
    
    var currentMediaContent: MediaModel

    
    init(album: AlbumModel, isFromNewAlbumSection newSection: Bool, atIndexPath indexPath: NSIndexPath) {
    
        
        // Change to loading images and video
        albumModel = album
        self.indexPath = indexPath
        isNewAlbumSection = newSection
        
//        self.init(album: album)
        
        if isNewAlbumSection {
            print("startWithNewContent")
            currentMediaContent = albumModel.firstNewItem()!
        } else {
            currentMediaContent = albumModel.firstItem()!
        }
        
        albumDisplayNode = HAAlbumDisplayNode()

        super.init(node: albumDisplayNode)
        
        
        albumDisplayNode.delegate = self
    }
    
    
    convenience init(userAlbum album: AlbumModel) {
        
        self.init(album: album, isFromNewAlbumSection: false, atIndexPath: NSIndexPath(index: 0))

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
        let image = UIImage(named: (self.currentMediaContent.media))
        changeDisplayViewToImage(image!)
        print("viewWillAppear done")

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.alpha = 1.0
        
        }) { (complete) in
            
            self.startCurrentTimer()
        }
    }
    
    
    
    func updateVCForTimeLeft(timeLeft: Int) {
       
        print("Timeleft: \(timeLeft)")
        
        if timeLeft <= 0 {
            showNextItem()
        }
    }
    
    func changeDisplayViewToImage(image: UIImage) {
        
        print("changeDisplayViewToImage start")

        albumDisplayNode.imageNode.image = image
        currentMediaContent.delegate = self
        print("changeDisplayViewToImage done")

    }
    
    func continueTimer() {
        currentMediaContent.continueTimer()
    }
    
    func startCurrentTimer() {
        print("startCurrentTimer")

        currentMediaContent.startTimer()
    }
    
    func stopCurrentTimer() {
        print("stopCurrentTimer")
        currentMediaContent.stopTimer()
    }

    
    
    
    
    /* *********************************************************************************************
       *********************************************************************************************
        
                Delegate methods for Album View
       *********************************************************************************************
       *********************************************************************************************
     */
    
    func closeAlbumVC() {
        
        delegate?.removeNewAlbum(albumModel)

        stopCurrentTimer()
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.alpha = 0.0
            
        }) { (complete) in
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
    
    
    
    func pauseAlbum() {

        if currentMediaContent.timerIsRunning() {
            stopCurrentTimer()
        } else {
            continueTimer()
        }
    }
    
    
    func changeCurrentMediaContent(mediaContent: MediaModel) {
        
        currentMediaContent = mediaContent
        let image = UIImage(named: (currentMediaContent.media))
        changeDisplayViewToImage(image!)
        startCurrentTimer()
    }
    
    
    func showPreviousItem() {
        
        print("===============================================================")
        print("             HAAlbumDisplayVC ShowPreviousItem  ")
        print("===============================================================")

        if let previousMediaContent = albumModel.previousItem() {

            stopCurrentTimer()
            
            changeCurrentMediaContent(previousMediaContent)
        } else {
            print("This is the first image, Can't go back")
        }
    }
    
    func showNextItem() {
        print("===============================================================")
        print("            HAAlbumDisplayVC showNextItem")
        print("===============================================================")

        if let nextMediaContent = albumModel.nextItem() {

            stopCurrentTimer()
            
            changeCurrentMediaContent(nextMediaContent)
            
        } else {
            closeAlbumVC()
        }
    }
}



