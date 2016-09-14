//
//  HAFollowingVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/16/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AWSMobileHubHelper
import AsyncDisplayKit
import SwiftIconFont
import ReachabilitySwift
import SwiftyUserDefaults

import SwiftyDrop

protocol HAPresentAppDelegate {
    func showSelfWithAnimation()
    func presentSignInController(message: String?)
//    func presentRegisterController(message: String?)
    func handleLogoutWithMessage(message: String?)

}

class HAFollowingVC: ASViewController, ASTableDelegate, ASTableDataSource,
    HAFriendAlbumDisplayVCDelegate, HAFollowingTableNodeDelegate {


    var delegate: HAPresentAppDelegate?
    
    var reachability: Reachability?

    
    let tableNodeDisplay: HAFollowingTableNode
    
    var feedModel = FollowFeedModel(withType: .Friends)

    func tabbarHeight() -> CGFloat {
        return CGRectGetHeight((tabBarController?.tabBar.frame)!)
    }
    
    init() {
        print("HAFollowingVC init")
        
        tableNodeDisplay = HAFollowingTableNode()

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
    
    let AUTO_TAIL_LOADING_NUM_SCREENFULS:CGFloat = 2.5
//    
//    override func loadView() {
//        super.loadView()
//        title = "Following"
//        
//        tableNodeDisplay.tableNode.view.separatorStyle = .None
//        tableNodeDisplay.tableNode.view.allowsSelection = true
//        tableNodeDisplay.tableNode.view.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS  // overriding default of 2.0
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HAFollowingVC viewDidLoad")
        title = "Following"
        
        tableNodeDisplay.tableNode.view.separatorStyle = .None
        tableNodeDisplay.tableNode.view.allowsSelection = true
        tableNodeDisplay.tableNode.view.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS  // overriding default of 2.0
        
        if hasCamera() {
            tableNodeDisplay.cameraButton.hidden = false
       }
        
//        let hostName = "google.com"
//        let useClosures = true
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
//    deinit {
//        stopNotifier()
//    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("HAFollowingVC viewWillAppear")
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = false
        // print("isReachable: \(reachability?.isReachable())")
        // print("isReachableViaWWAN: \(reachability?.isReachableViaWWAN())")
        // print("isReachableViaWiFi: \(reachability?.isReachableViaWiFi())")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("HAFollowing Viewdid appear")
        
        let guid   = Me.sharedInstance.guid()
        let acctId = Me.sharedInstance.acctId()
        
        // Logged in before and created an account already
        if AWSIdentityManager.defaultIdentityManager().loggedIn && guid != nil && acctId != nil {
            
            print("HATabar AWSIdentityManager loggedIn")
            
            self.delegate?.showSelfWithAnimation()

            
            var jsonObj = [String: AnyObject]()
            
            jsonObj[kGuid]   = guid!
            jsonObj[kAcctId] = acctId!
            
            //Check to see if our account still exists
            // TODO: Instead of calling AWSLambdaAccountActive, this functionality should be included in every other function
            
            // If account not active, show signin screen? maybe register screen
            AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaAccountActive,
             withParameters: jsonObj) { (result: AnyObject?, error: NSError?) in

                if let result = result {
                    dispatch_async(dispatch_get_main_queue(), {
                        print("1 refreshFeedWithCompletionBlock - Result: \(result)")
                        
                        if let response = result as? [String: AnyObject]  {
                            
                            print("2 refreshFeedWithCompletionBlock - Result: \(result)")

                            var errorMessage: String?
                            if let activeStatus = response[kActive] as? Int {
                                
                                print("--- activeStatus: \(activeStatus)")

                                switch activeStatus {
                                case UserActiveStatus.Active.rawValue:
                                    self.refreshFeed()
                                case UserActiveStatus.Deleted.rawValue:
                                    errorMessage = "This account has been deleted"
                                    fallthrough
                                case UserActiveStatus.DoesNotExist.rawValue:
                                    errorMessage = "Account not found"

                                    fallthrough
                                
                                case UserActiveStatus.Disabled.rawValue:
                                    errorMessage = "This account has been disbaled"

                                    fallthrough
                                case UserActiveStatus.DisabledConfirmed.rawValue:
                                    errorMessage = "This account has been disbaled"
                                    self.delegate?.handleLogoutWithMessage(errorMessage)
                                default:
                                    break
                                }
                            }
                        } else {
                            self.refreshFeed()
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.refreshFeed()
                    })
                }
            }
            // We;ve logged in through facebook, but have no guid or acctId
        } else if AWSIdentityManager.defaultIdentityManager().loggedIn { // but no guid/accId
            
            
            delegate?.handleLogoutWithMessage(nil)

        
            // Query
            // Show sign in screen?

            // We're not logged in
        } else {
            delegate?.presentSignInController(nil)

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
//        let cameraNavCtrl = UINavigationController(rootViewController: cameraVC)
        presentClearViewController(cameraVC)
    }
    
    func presentClearViewController(viewController: UIViewController) {
        
        viewController.view.alpha = 0
        navigationController?.pushViewController(viewController, animated: false)
//        presentViewController(viewController, animated: false, completion: nil)
    }
    
    
    
    
    //MARK: - PhotoFeedViewControllerProtocol
    
    
    // This will fetch new albums and get any updates for existing albums
    func refreshFeed() {
        
        tableNodeDisplay.showSpinningWheel()
        
        feedModel.refreshFeedWithCompletionBlock({ (indexSetChange, insertSections, removeSections, reloadSections, errorMessage) in
            
            self.tableNodeDisplay.hideSpinningWheel()

            if let errorMessage = errorMessage {
               
                Drop.down("\(errorMessage) \(randomUpsetEmoji())",
                    state: .Error ,
                    duration: 4.0,
                    action: nil)
           
            } else {
                
                
                self.tableNodeDisplay.tableNode.view.beginUpdates()
                
                if indexSetChange > 0 {
                    
                    self.tableNodeDisplay.tableNode.view.insertSections(NSIndexSet(index: 0),
                                                                        withRowAnimation: .None)
               
                    if indexSetChange > 1 {
                        self.tableNodeDisplay.tableNode.view.insertSections(NSIndexSet(index: 1),
                                                                            withRowAnimation: .None)
                    }
                    
                } else if indexSetChange < 0 {

                    if indexSetChange < -1 {
                        self.tableNodeDisplay.tableNode.view.deleteSections(NSIndexSet(index: 1),
                            withRowAnimation: .None)
                    }
                    
                    self.tableNodeDisplay.tableNode.view.deleteSections(NSIndexSet(index: 0),
                                                                        withRowAnimation: .None)
                    
                }
                
                
                self.tableNodeDisplay.tableNode.view.deleteRowsAtIndexPaths(removeSections!, withRowAnimation: .None)
                self.tableNodeDisplay.tableNode.view.insertRowsAtIndexPaths(insertSections!, withRowAnimation: .None)
                self.tableNodeDisplay.tableNode.view.reloadRowsAtIndexPaths(reloadSections!, withRowAnimation: .None)
                
                self.tableNodeDisplay.tableNode.view.endUpdates()
                
            }
            
            
            
//                self.insertNewRowsInTableView(albumResults)
            
                
            
            
            
            }, numbersOfResultsToReturn: 20)
        
//        feedModel.refreshFeedWithCompletionBlock({ (albumResults, errorMessage) in
//            
//            self.tableNodeDisplay.hideSpinningWheel()
//            
//            if let albumResults = albumResults {
//            
//                self.insertNewRowsInTableView(albumResults)
//                
//                // immediately start second larger fetch
//                // self.loadPageWithContext(nil)
//            } else {
//                Drop.down("\(errorMessage!) \(randomUpsetEmoji())",
//                    state: .Error ,
//                    duration: 4.0,
//                    action: nil)
//            }
//        }, numbersOfResultsToReturn: 20)
    }
    
    
    func loadPageWithContext(context: ASBatchContext?) {
        
        feedModel.requestPageWithCompletionBlock({ (albumResults) in
            
            self.insertNewRowsInTableView(albumResults)

            context?.completeBatchFetching(true)

        }, numbersOfResultsToReturn: 20)
    }
    
    
    func downloadAlbumCovers() {
//        
//        if !Defaults[.useLessData] {
//            
//            print("Call function to download all media content")
//        } else {
//            
//            print("Don't download data: In data savings mode")
//            
//        }
    }
    
    
    
    
    
    
    func insertNewRowsInTableView(albums: [FriendAlbumModel]) {
        
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
    
    
    func deleteRowsInTableView(albums: [FriendAlbumModel]) {
        
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
    
    
    func removeNewAlbum(album: FriendAlbumModel) {
        
        if let index = feedModel.indexOfNewAlbumModel(album) {
            
            if !album.hasNewContent() {
               
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
    
    
    
    
    
//    func removeTableBackgroundView() {
//        print("removeTableBackgroundView")
//        tableNodeDisplay.tableNode.view.backgroundView?.hidden = true
//    }
//    
//    
//    func showTableBackgroundViewForNoAlbums() {
//        print("showTableBackgroundViewForNoAlbums")
//        tableNodeDisplay.tableNode.view.backgroundView?.hidden = false
//    }
    
    

    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Only spinning wheel should show
        if feedModel.refreshingFeedDataInProgress {
            return 0
        }
        
        if feedModel.hasNewAlbums() {
//            removeTableBackgroundView()
            return 2
        } else if feedModel.hasAlbums() {
//            removeTableBackgroundView()
            return 1
        } else {
//            showTableBackgroundViewForNoAlbums()
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("numberOfRowsInSection \(section)")
        
        if feedModel.refreshingFeedDataInProgress {
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
        let album: FriendAlbumModel
        
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
        let album: FriendAlbumModel
        var newAlbumSection = false
        
        if feedModel.hasNewAlbums() {
            if indexPath.section == 0 {
                newAlbumSection = true
                album = feedModel.newAlbumAtIndex(indexPathRow)!
                print("New album at index : \(indexPathRow)")
                print("New album has \(album.mediaCount()) images")
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
        let displayAlbumVC = HAFriendAlbumDisplayVC(album: album, isFromNewAlbumSection:newAlbumSection)
        displayAlbumVC.delegate = self
        presentClearViewController(displayAlbumVC)
    }
    
    
    
    
    //MARK: - ASTableDelegate methods
    
//     Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
        func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
            context.beginBatchFetching()
            loadPageWithContext(context)
        }
    
    
}
