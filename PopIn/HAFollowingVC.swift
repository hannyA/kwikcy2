//
//  HAFollowingVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftIconFont
import ReachabilitySwift
import SwiftyUserDefaults

class HAFollowingVC: ASViewController, ASTableDelegate, ASTableDataSource,
    HAAlbumDisplayVCDelegate, HAFollowingTableNodeDelegate {


    var reachability: Reachability?

    
    let tableNodeDisplay: HAFollowingTableNode
    
    var feedModel = FollowFeedModel(withType: .Friends)
    
    var fetchingMoreData:Bool
    var refreshingData:Bool
    
    
    func tabbarHeight() -> CGFloat {
        return CGRectGetHeight((tabBarController?.tabBar.frame)!)
    }
    
    init() {
    
        tableNodeDisplay = HAFollowingTableNode()
        
        print("HAFollowingVC init")

        print("feedModel count \(feedModel.totalNumberOfAlbums())")
        refreshingData = false
        //        fetchingInitialData = true
        fetchingMoreData = false
        

        super.init(node: tableNodeDisplay)
    
        
        tableNodeDisplay.delegate = self
        
        tableNodeDisplay.tableNode.dataSource = self
        tableNodeDisplay.tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /* ============================================================================
     ============================================================================
     
     Life cycle
     
     ============================================================================
     ============================================================================
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("HAFollowingVC viewDidLoad")
        
        
        title = "Following"
        tableNodeDisplay.tableNode.view.separatorStyle = .None
        tableNodeDisplay.tableNode.view.allowsSelection = true
        
        if hasCamera() {
            tableNodeDisplay.cameraButton.hidden = false
            
            let cameraTitleButton = UIBarButtonItem()
        
            cameraTitleButton.icon(from: .MaterialIcon, code: "photo.camera", ofSize: 30)
            navigationItem.setRightBarButtonItem(cameraTitleButton, animated: false)
        }
        
        
//        let hostName = "google.com"
//        
//        let useClosures = true
//        
//        
//        print("--- set up with host name: \(hostName)")
        
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            self.reachability = reachability
            print("--- set upreachability")

        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("Unable to create Reachability with address:\n\(address)")
            return
        } catch {}
        
        
//        if useClosures {
//            reachability?.whenReachable = { reachability in
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.updateWhenReachable(reachability)
//                }
//            }
//            reachability?.whenUnreachable = { reachability in
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.updateWhenNotReachable(reachability)
//                }
//            }
//        } else {
//            NSNotificationCenter.defaultCenter().addObserver(self,
//                                                             selector: #selector(reachabilityChanged),
//                                                             name: ReachabilityChangedNotification,
//                                                             object: reachability)
//        }
    }
    
    
    
//    func updateWhenReachable(reachability: Reachability) {
//       
//        print("\(reachability.description) - \(reachability.currentReachabilityString)")
//       
//        if reachability.isReachableViaWiFi() {
//            print("reachability.isReachableViaWiFi")
//        } else if reachability.isReachableViaWWAN() {
//            print("reachability.isReachableViaWWAN")
//        } else if reachability.isReachable() {
//            print("reachability.isReachable")
//        } else {
//            print("reachability = I don't know....")
//        }
//    }
//    
//    
//    func updateWhenNotReachable(reachability: Reachability) {
//       
//        print("\(reachability.description) - \(reachability.currentReachabilityString)")
//        
//        if reachability.isReachableViaWiFi() {
//            print("reachability.isReachableViaWiFi")
//        } else if reachability.isReachableViaWWAN() {
//            print("reachability.isReachableViaWWAN")
//        } else if reachability.isReachable() {
//            print("reachability.isReachable")
//        } else {
//            print("reachability = I don't know....")
//        }
//    }
    
    
    
//    func startNotifier() {
//        print("--- start notifier")
//        do {
//            try reachability?.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//            return
//        }
//    }
//
//    func stopNotifier() {
//        print("--- stop notifier")
//        reachability?.stopNotifier()
//        NSNotificationCenter.defaultCenter().removeObserver(self,
//                                                            name: ReachabilityChangedNotification,
//                                                            object: nil)
//        reachability = nil
//    }
//    
//    func reachabilityChanged(note: NSNotification) {
//        let reachability = note.object as! Reachability
//        
//        print("\(reachability.description) - \(reachability.currentReachabilityString)")
//        
//        if reachability.isReachableViaWiFi() {
//            print("reachability.isReachableViaWiFi")
//        } else if reachability.isReachableViaWWAN() {
//            print("reachability.isReachableViaWWAN")
//        } else if reachability.isReachable() {
//            print("reachability.isReachable")
//        } else {
//            print("reachability = I don't know....")
//        }
//    }
//    
//    
//    deinit {
//        stopNotifier()
//    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("HAFollowingVC viewWillAppear")

        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = false
        
        print("isReachable: \(reachability?.isReachable())")
        print("isReachableViaWWAN: \(reachability?.isReachableViaWWAN())")
        print("isReachableViaWiFi: \(reachability?.isReachableViaWiFi())")

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HAFollowing Viewdid appear")
        refreshFeed()
    }
    
    
    func downloadAllMedia() {
        
        if !Defaults[.useLessData] {
            
            print("Call function to download all media content")
        } else {
           
            print("Don't download data: In data savings mode")
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = true
    }
    

    
    
    
    /* ============================================================================
     ============================================================================
     
     CAMERA METHODS
     
     ============================================================================
     ============================================================================
     */
    
    
    
    
    func hasCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            return true
        }
        return false
    }
    
    
    func openCamera() {
        let cameraVC = INCameraVC(withCameraPosition: .Back)
        presentClearViewController(cameraVC)
    }
    
    
    
    func presentClearViewController(viewController: UIViewController) {
        
        viewController.view.alpha = 0
        navigationController?.pushViewController(viewController, animated: false)
//        presentViewController(viewController, animated: false, completion: nil)
        
    }
    
    
    
    func closeCamera() {
        navigationController?.popViewControllerAnimated(false)
        dismissViewControllerAnimated(true, completion: nil)
//        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//    func saveImage(image: UIImage) {
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(HAFollowingVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//    
//    
//    // Save image to iPhone library
//    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        print("didFinishSavingWithError")
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
//    }
    
    
    
    
    
    
    
    //MARK: - PhotoFeedViewControllerProtocol
    
    func removeTableBackgroundView() {
        print("removeTableBackgroundView")
        
        tableNodeDisplay.tableNode.view.backgroundView = nil
    }
    
    func showTableBackgroundViewForNoAlbums() {
        print("showTableBackgroundViewForNoAlbums")
        
        let bounds = tableNodeDisplay.tableNode.bounds
        let backgroundView = UIView(frame: bounds)
        
        let backgroundImageView = UIImageView(frame: backgroundView.bounds)
        backgroundImageView.image = UIImage(named: "mad-men-1.png")
        backgroundImageView.contentMode = .ScaleAspectFill
        
        backgroundView.addSubview(backgroundImageView)
        
        tableNodeDisplay.tableNode.contentMode = .ScaleAspectFill
        tableNodeDisplay.tableNode.view.backgroundView = backgroundView
    }
    
    
    
    
    
    func refreshFeed() {
        
        refreshingData = true
        tableNodeDisplay.showSpinningWheel()
        
        feedModel.refreshFeedWithCompletionBlock({ (albumResults) in
            
            self.refreshingData = false
            
            self.tableNodeDisplay.tableNode.view.reloadData()
            self.tableNodeDisplay.hideSpinningWheel()

            //            self.insertNewRowsInTableView(albumResults)
            
            //    // immediately start second larger fetch
            //    [self loadPageWithContext:nil];
            
            self.downloadAllMedia()
            
            }, numbersOfResultsToReturn: 4)
    }
    
    
    func insertNewRowsInTableView(albums: [AlbumModel]) {
        
        let section = 0
        var indexPaths = [NSIndexPath]()
        
        let totalNumberOfAlbums = feedModel.numberOfAlbumsInFeed()
        
        var row = totalNumberOfAlbums - albums.count
        while row < totalNumberOfAlbums {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            indexPaths.append(path)
            row += 1
        }
        
        self.tableNodeDisplay.tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    
    func deleteRowsInTableView(albums: [AlbumModel]) {
        
        let section = 0
        var indexPaths = [NSIndexPath]()
        
        let totalNumberOfAlbums = feedModel.numberOfAlbumsInFeed()
        
        var row = totalNumberOfAlbums - albums.count
        while row < totalNumberOfAlbums {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            indexPaths.append(path)
            row += 1
        }
        
        self.tableNodeDisplay.tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    
//    func indexPathOfALbum
    
    
    func removeNewAlbum(album: AlbumModel) {
        
        if let index = feedModel.indexOfNewAlbumModel(album) {
            
            if !album.hasNewContent {
               
                feedModel.removeNewAlbumAtIndex(index)
                
                self.tableNodeDisplay.tableNode.view.beginUpdates()
                
                
                self.tableNodeDisplay.tableNode.view.deleteRowsAtIndexPaths([NSIndexPath(forRow: index,
                                                                                         inSection: 0)],
                                                                            withRowAnimation: .None)
                
                print("removeNewAlbumAtIndexath count  \(feedModel.numberOfNewAlbums())")
                
                if !feedModel.hasNewAlbums() {
                    print("removeNewAlbumAtIndexPath has no NewAlbums")
                    let newAlbumSection  = NSIndexSet(index: 0)
                    self.tableNodeDisplay.tableNode.view.deleteSections(newAlbumSection, withRowAnimation: .None)
                } else {
                    print("removeNewAlbumAtIndexPath still has NewAlbums")
                    
                }
                self.tableNodeDisplay.tableNode.view.endUpdates()
            }
        }
        
    }
    
    
    /* ============================================================================
     ============================================================================
     
                    TABLEVIEW METHODS
     
     ============================================================================
     ============================================================================
     */
    
    
    
    
    //MARK: Header methods
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Text Sideline constants
        let lineWidth = tableView.frame.width/5
        let lineHeight:CGFloat = 1.0
        let spaceBetweenLineAndText:CGFloat = 15.0
        
        
        // Setup header view and text
        let headerViewRect = self.tableNodeDisplay.tableNode.view.rectForHeaderInSection(section)
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        
        headerView.textLabel?.textAlignment = .Center
        
        
        // Center Positions
        let xCenter = headerViewRect.width/2
        let yCenter = headerViewRect.height/2
        
        // Get the width of headerview text - Can't seem to get it from the header view
        let headerText = self.tableView(tableView, titleForHeaderInSection: section)
        let headerViewfont = headerView.textLabel?.font
        
        let headerTextWidth = widthOfLabelForText(headerText!, withFont: headerViewfont!)
        let headerTextWidthHalf: CGFloat = headerTextWidth/2
        
        
        let xLeftStartPosition = xCenter - lineWidth - headerTextWidthHalf - spaceBetweenLineAndText
        let xRightStartPosition = xCenter + headerTextWidthHalf + spaceBetweenLineAndText
        
        let leftLineFrame  = CGRectMake(xLeftStartPosition, yCenter, lineWidth , lineHeight)
        let rightLineFrame = CGRectMake(xRightStartPosition, yCenter, lineWidth , lineHeight)
        
        
        // backgroundView and contentView both work
        headerView.backgroundView?.addSubview(makeLineView(withFrameRect: leftLineFrame))
        headerView.backgroundView?.addSubview(makeLineView(withFrameRect: rightLineFrame))
        
        //        headerView.contentView.addSubview(leftView)
        //        headerView.contentView.addSubview(rightView)
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if feedModel.hasNewAlbums() {
            if section == 0 {
                return "New"
            } else { return "Albums"}
        } else if feedModel.hasAlbums() {
            return "Albums"
        } else {
            return nil
        }
    }
    
    //MARK: Header helper funcs
    func widthOfLabelForText(text: String, withFont font: UIFont) -> CGFloat {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }
    
    func makeLineView(withFrameRect frameRect: CGRect) -> UIView {
        
        let view = UIView(frame: frameRect)
        view.backgroundColor = UIColor.blackColor()
        return view
    }
    
    
    
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Only spinning wheel should show
        if refreshingData {
            return 0
        }
        
        if feedModel.hasNewAlbums() {
            removeTableBackgroundView()
            return 2
        } else if feedModel.hasAlbums() {
            removeTableBackgroundView()
            return 1
        } else {
            showTableBackgroundViewForNoAlbums()
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("numberOfRowsInSection \(section)")
        
        if refreshingData {
            return 0
        }
        
        if feedModel.hasNewAlbums() {
            if section == 0 {
                return feedModel.numberOfNewAlbums()
            } else {
                return feedModel.totalNumberOfAlbums()
            }
        } else if feedModel.hasAlbums() {
            return feedModel.totalNumberOfAlbums()
        } else {
            return 1 // One Row: Says to go make some friends
        }
    }
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        //If no albums
        //        if feedModel.totalNumberOfAlbums() == 0 {
        //            return  {() -> ASCellNode in
        //                return SimpleCellNode(withMessage: "Go find some new friends")
        //            }
        //        }
        
        // If albums exist
        let album: AlbumModel
        
        if feedModel.hasNewAlbums() {
            if indexPath.section == 0 {
                album = feedModel.newAlbumAtIndex(indexPath.row)!
            } else {
                album = feedModel.albumAtIndex(indexPath.row)!
            }
            //Only seen albums
        } else { //feedModel.totalNumberOfAlbums() > 0 {
            album = feedModel.albumAtIndex(indexPath.row)!
        }
        
        // this may be executed on a background thread - it is important to make sure it is thread safe
        return {() -> ASCellNode in
            let cellNode = AlbumCellNode(withAlbumObject: album)
            cellNode.selectionStyle = .None
            return cellNode
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("==================================================")
        print("================   New Selection  ================")
        print("==================================================")
        
        let indexPathRow = indexPath.row
        let album: AlbumModel
        var newAlbumSection = false
        
        if feedModel.hasNewAlbums() {
            if indexPath.section == 0 {
                newAlbumSection = true
                album = feedModel.newAlbumAtIndex(indexPathRow)!
                print("New album at index : \(indexPathRow)")
                print("New album has \(album.mediaCount) images")
                print("New newMediaIndex: \(album.newMediaIndex!)")
            } else {
                print("Old album secton 1")

                album = feedModel.albumAtIndex(indexPathRow)!
            }
        } else { // Old albums
            print("Old album secton 0")
            album = feedModel.albumAtIndex(indexPathRow)!
        }
        
        
        //        didselect delete items from newalbum, if none left remove from new album section
        
        
//        
        let displayAlbumVC = HAAlbumDisplayVC(album: album, isFromNewAlbumSection:newAlbumSection,  atIndexPath: indexPath)
        displayAlbumVC.delegate = self
        presentClearViewController(displayAlbumVC)
    }
    
    
    
    
    //MARK: - ASTableDelegate methods
    
    // Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
    //    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
    //        context.beginBatchFetching()
    ////        loadpagew
    //    }
    
    
}
