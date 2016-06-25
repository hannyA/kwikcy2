//
//  HAFollowingVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/4/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

//import UIKit
import AsyncDisplayKit
import MobileCoreServices

class HAFollowingVC: ASViewController, ASTableDelegate, ASTableDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HAAlbumDisplayVCDelegate {
    
    
   
    
    let NewAlbumSection = 0
    let OldAlbumSection = 1
    
    let _tableNode: ASTableNode
    var feedModel: FollowFeedModel

//    var fetchingInitialData:Bool
    var fetchingMoreData:Bool
    var refreshingData:Bool
    
    var lowRightCameraButton: UIButton
    var imagePicker: UIImagePickerController
    var _activityIndicatorView: UIActivityIndicatorView

    
    init() {
        
        _tableNode = ASTableNode(style: .Plain)
       
        _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        lowRightCameraButton = UIButton()
        imagePicker = UIImagePickerController()
        
        if Constants.TestMode {
            feedModel = TESTFollowFeedModel(withType: .Friends, forNumberOfAlbums: 10)
        } else { //TODO: Connect to server data
            feedModel = TESTFollowFeedModel(withType: .Friends)
        }
        
        refreshingData = false
//        fetchingInitialData = true
        fetchingMoreData = false
        
        super.init(node: _tableNode)
        
        _tableNode.dataSource = self
        _tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func loadView() {
        super.loadView()
        
        let boundSize = view.bounds.size
        
        _activityIndicatorView.sizeToFit()
        var refreshRect = _activityIndicatorView.frame
        refreshRect.origin = CGPointMake( (boundSize.width - _activityIndicatorView.frame.size.width)/2.0, (boundSize.height - _activityIndicatorView.frame.size.height) / 2.0)
        
        _activityIndicatorView.frame = refreshRect
        _activityIndicatorView.color = UIColor.blackColor()

        view.addSubview(_activityIndicatorView)

        
        refreshFeed()
    }
    
    
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Following"
        _tableNode.view.separatorStyle = .None
        _tableNode.view.allowsSelection = true
//        _tableNode.view.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS;

        let tableFrame = _tableNode.bounds
        
        let rightSpace: CGFloat = 15.0
        let bottomSpace: CGFloat = 15.0
        let tabbarHeight:CGFloat =  (tabBarController?.tabBar.frame.height)!
        let tableWidth = tableFrame.width
        let tableHeight = tableFrame.height
        let buttonSize:CGFloat = tableWidth/7
        let xPositionButton:CGFloat = tableWidth - buttonSize - rightSpace
        let yPositionButton:CGFloat =  tableHeight - buttonSize - bottomSpace - tabbarHeight
        tabBarController?.view.frame.height
        
        let cameraImageNormal = UIImage(named: "camera")
        let cameraImageHighlighted = UIImage(named: "earth")
        
        let camButton = UIButton(type: .Custom)
//        camButton.setImage(cameraImageNormal, forState: .Normal)
//        camButton.setImage(cameraImageHighlighted, forState: .Highlighted)
        
        camButton.setBackgroundImage(cameraImageNormal, forState: .Normal)
        camButton.setBackgroundImage(cameraImageHighlighted, forState: .Highlighted)
//        camButton.sizeToFit()
//        camButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        camButton.contentMode = .ScaleAspectFit
        camButton.frame = CGRectMake(xPositionButton, yPositionButton, buttonSize , buttonSize)

        if hasCamera() {
            lowRightCameraButton = camButton
            lowRightCameraButton.layer.borderWidth = 1
            lowRightCameraButton.layer.borderColor = UIColor.blackColor().CGColor
            lowRightCameraButton.addTarget(self, action: #selector(openCamera), forControlEvents: .TouchUpInside)
            navigationController?.view.addSubview(lowRightCameraButton)
            let cameraTitleButton = UIBarButtonItem(title: "Camera", style: .Done, target: self, action: #selector(openCamera))
            
//            let cameraButton = UIBarButtonItem(image: UIImage(named: "camera"), style: .Plain, target: self, action: #selector(openCamera))
            navigationItem.setRightBarButtonItem(cameraTitleButton, animated: false)
        }
    }
    
    //MARK: View appear/disappers
    
    /* ============================================================================
     ============================================================================
     
     Lifetime cycle
     
     ============================================================================
     ============================================================================
     */
    
    
    
    func presentClearViewController(viewController: UIViewController) {
        
        viewController.view.alpha = 0
        viewController.hidesBottomBarWhenPushed = true
        
        viewController.navigationController?.navigationBarHidden = true
        navigationController?.navigationBarHidden = true
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        lowRightCameraButton.hidden = false
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lowRightCameraButton.hidden = true
        
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
        let cameraVC = INCameraVC()
        presentClearViewController(cameraVC)
    }
    
    
    
    func closeCamera() {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveImage(image: UIImage) {
       
        print("saveImage")
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(HAFollowingVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    // Save image to iPhone library
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        print("didFinishSavingWithError")
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        print("didFinishPickingMediaWithInfo")
//        
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
////        dismissViewControllerAnimated(true, completion: nil)
//        
//        if mediaType == (kUTTypeImage as String) {
//            
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//            
//            let albumPhotoShare = HAAlbumMediaShareVC(withImage: image)
////            albumPhotoShare.navigationItem.title = "Hello"
////            navigationController?.pushViewController(albumPhotoShare, animated: true)
//            
//            imagePicker.navigationBarHidden = false
//            imagePicker.pushViewController(albumPhotoShare, animated: true)
//            
//        } else if mediaType == (kUTTypeVideo as String) {
//            // Code to support video here
//
//        }
////        
//        if mediaType.isEqualToString(kUTTypeImage as! String) {
//            let image = info[UIImagePickerControllerOriginalImage]
//                as! UIImage
//            
//            imageView.image = image
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                                               "image:didFinishSavingWithError:contextInfo:", nil)
//            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
//                // Code to support video here
//            }
//    }
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage
//        image: UIImage, editingInfo: [String : AnyObject]?) {
//      
//        print("didFinishPickingImage")
//    }
//
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        
//        print("imagePickerControllerDidCancel")
//        closeCamera()
//    }
    
    
    
    
    
    
    /* ============================================================================
     ============================================================================
     
                        HAAlbumDisplayVC Delegate METHODS
     
     ============================================================================
     ============================================================================
     */
    
    
    
    //MARK: - PhotoFeedViewControllerProtocol
    
    func removeTableBackgroundView() {
        print("removeTableBackgroundView")

        _tableNode.view.backgroundView = nil
    }
    
    func showTableBackgroundViewForNoAlbums() {
        print("showTableBackgroundViewForNoAlbums")

        let bounds = _tableNode.bounds
        let backgroundView = UIView(frame: bounds)
        
        let backgroundImageView = UIImageView(frame: backgroundView.bounds)
        backgroundImageView.image = UIImage(named: "mad-men-1.png")
        backgroundImageView.contentMode = .ScaleAspectFill
        
        backgroundView.addSubview(backgroundImageView)
        
        _tableNode.contentMode = .ScaleAspectFill
        _tableNode.view.backgroundView = backgroundView
    }
    
    func refreshFeed() {

        refreshingData = true
        _activityIndicatorView.startAnimating()
        
        feedModel.refreshFeedWithCompletionBlock({ (albumResults) in
            
            self.refreshingData = false
            
            self._activityIndicatorView.stopAnimating()
            
            self._tableNode.view.reloadData()
            //            self.insertNewRowsInTableView(albumResults)
            
            //    // immediately start second larger fetch
            //    [self loadPageWithContext:nil];
            
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
        
        _tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
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
        
        _tableNode.view.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    
    func removeNewAlbumAtIndexPath(indexPath: NSIndexPath) {
    
        feedModel.removeNewAlbumAtIndex(indexPath.row)
        
        _tableNode.view.beginUpdates()
        
        _tableNode.view.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        print("removeNewAlbumAtIndexath count  \(feedModel.numberOfNewAlbums())")

        
        
        if !feedModel.hasNewAlbums() {
            print("removeNewAlbumAtIndexPath has no NewAlbums")
            let newAlbumSection  = NSIndexSet(index: 0)
            _tableNode.view.deleteSections(newAlbumSection, withRowAnimation: .None)
        } else {
            print("removeNewAlbumAtIndexPath still has NewAlbums")

        }
        _tableNode.view.endUpdates()
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
        let headerViewRect = _tableNode.view.rectForHeaderInSection(section)
        
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
    

    

    
    
    
    //MARK: - ASTableDataSource methods
    
    
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
            if indexPath.section == NewAlbumSection {
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
                print("New album has \(album.mediaCount!) images")
                print("New newMediaIndex: \(album.newMediaIndex!)")
            } else {
                album = feedModel.albumAtIndex(indexPathRow)!
            }
        } else { // Old albums
            album = feedModel.albumAtIndex(indexPathRow)!
        }
        
        
//        didselect delete items from newalbum, if none left remove from new album section
        
        
        let displayAlbumVC = HAAlbumDisplayVC(album: album, fromNewAlbumSection:newAlbumSection,  atIndexPath: indexPath)
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
