//
//  PhotoFeedNodeController.swift
//  PopIn
//
//  Created by Hanny Aly on 4/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class PhotoFeedNodeController: ASViewController,
    PhotoFeedControllerProtocol, ASTableDelegate, ASTableDataSource  {
    
    
    
    // MARK: Properties
    
    struct State {
        var itemCount: Int
        var fetchingMore: Bool
        static let empty = State(itemCount: 20, fetchingMore: false)
    }
    
    enum Action {
        case BeginBatchFetch
        case EndBatchFetch(resultCount: Int)
    }

    private(set) var state: State = .empty
    
    let AUTO_TAIL_LOADING_NUM_SCREENFULS: CGFloat = 2.5

    var _photoFeed: PhotoFeedModel?
    var _tableNode: ASTableNode
    var _activityIndicatorView: UIActivityIndicatorView
    
    
    
    // MARK: LifeCycle

    init() {
        _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        _tableNode = ASTableNode()
        super.init(node: _tableNode)
        _tableNode.dataSource = self;
        _tableNode.delegate = self;

        navigationItem.title = "fef"
        navigationController?.navigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    
    // do any ASDK view stuff in loadView
    override func loadView() {
        super.loadView()
        
        _photoFeed = PhotoFeedModel(photoFeedModelType: .Popular, imageSize: imageSizeForScreenWidth())
        
        refreshFeed()
        
        let boundSize: CGSize = view.bounds.size
        
        _activityIndicatorView.sizeToFit()
        
        var refreshRect = _activityIndicatorView.frame
        refreshRect.origin = CGPointMake((boundSize.width - _activityIndicatorView.frame.size.width) / 2.0,
                                         (boundSize.height - _activityIndicatorView.frame.size.height) / 2.0)
        _activityIndicatorView.frame = refreshRect
        
        view.addSubview(_activityIndicatorView)
        
        view.backgroundColor = UIColor.whiteColor()
        _tableNode.view.allowsSelection = false
        _tableNode.view.separatorStyle = .None
        _tableNode.view.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS // overriding default of 2.0
    }
    
    
    
    // MARK: Helper Methods
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func imageSizeForScreenWidth() -> CGSize {
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        let screenScale: CGFloat = UIScreen.mainScreen().scale
        return CGSizeMake(screenRect.size.width * screenScale, screenRect.size.width * screenScale)
    }
    
    
    // chnage ANyOBject
    func insertNewRowsInTableView(newPhotos: [AnyObject]) {
        let section = 0
        var indexPaths = [NSIndexPath]()
        
        let newTotalNumberOfPhotos = Int((_photoFeed?.numberOfItemsInFeed())!)
        
        var row = newTotalNumberOfPhotos - newPhotos.count
        
        while row < newTotalNumberOfPhotos {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            indexPaths.append(path)
            row += 1
        }
        
        _tableNode.view .insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    
    func loadPageWithContext(context: ASBatchContext?) {
        
        _photoFeed?.requestPageWithCompletionBlock({ (newPhotos) in
            self.insertNewRowsInTableView(newPhotos)
            //            self.requestCommentsForPhotos:newPhotos
            if context != nil {
                context!.completeBatchFetching(true)
            }
            }, numResultsToReturn: 20)
    }
    
    
    func refreshFeed() {
        _activityIndicatorView.startAnimating()
        // small first batch
        
        _photoFeed?.refreshFeedWithCompletionBlock({ (newPhotos) in
            self._activityIndicatorView.stopAnimating()
            
            self.insertNewRowsInTableView(newPhotos)
            //            self.requestCommentsForPhotos:newPhotos];
            
            // immediately start second larger fetch
            self.loadPageWithContext(nil)
            }, numResultsToReturn: 4)
    }
    
    
    
    
    
    // MARK: ASTableView data source and delegate.
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((_photoFeed?.numberOfItemsInFeed())!)
    }
    
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = state.itemCount
//        if state.fetchingMore {
//            count += 1
//        }
//        return count
//    }
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        let photoModel = _photoFeed?.objectAtIndex(UInt(indexPath.row))
        
        // this will be executed on a background thread - important to make sure it's thread safe

        
        let cellNodeBlock: ASCellNodeBlock = { ASCellNodeBlock in
            
            let cellNode = PhotoCellNode(photoObject: photoModel)
            return cellNode
        }

//        ASCellNode *(^ASCellNodeBlock)() = ^ASCellNode *() {
        return cellNodeBlock
    }
    
//    - (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    PhotoModel *photoModel = [_photoFeed objectAtIndex:indexPath.row];
//    // this will be executed on a background thread - important to make sure it's thread safe
//    ASCellNode *(^ASCellNodeBlock)() = ^ASCellNode *() {
//        PhotoCellNode *cellNode = [[PhotoCellNode alloc] initWithPhotoObject:photoModel];
//        return cellNode;
//    };
//    
//    return ASCellNodeBlock;
//    }

    
    
    
    // MARK - PhotoFeedViewControllerProtocol

    func resetAllData() {
        _photoFeed?.clearFeed()
        _tableNode.view.reloadData()
        refreshFeed()
    }

    
    
//    
//    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
//        // Should read the row count directly from table view but
//        // https://github.com/facebook/AsyncDisplayKit/issues/1159
//        let rowCount = self.tableView(tableView, numberOfRowsInSection: 0)
//        
//        if state.fetchingMore && indexPath.row == rowCount - 1 {
//            return TailLoadingCellNode()
//        }
//        
//        let node = ASTextCellNode()
//        node.text = String(format: "[%ld.%ld] says hello!", indexPath.section, indexPath.row)
//        
//        return node
//    }
    
    
    
    
    
    // MARK - ASTableDelegate methods
    
    // Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.

    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {

        context.beginBatchFetching()
        loadPageWithContext(context)
    }
    
    
//    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
//        /// This call will come in on a background thread. Switch to main
//        /// to add our spinner, then fire off our fetch.
//        dispatch_async(dispatch_get_main_queue()) {
//            let oldState = self.state
//            self.state = ViewController.handleAction(.BeginBatchFetch, fromState: oldState)
//            self.renderDiff(oldState)
//        }
//        
//        ViewController.fetchDataWithCompletion { resultCount in
//            let action = Action.EndBatchFetch(resultCount: resultCount)
//            let oldState = self.state
//            self.state = ViewController.handleAction(action, fromState: oldState)
//            self.renderDiff(oldState)
//            context.completeBatchFetching(true)
//        }
//    }
//    
//    
//    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
//        /// This call will come in on a background thread. Switch to main
//        /// to add our spinner, then fire off our fetch.
//        dispatch_async(dispatch_get_main_queue()) {
//            let oldState = self.state
//            self.state = PhotoFeedNodeController.handleAction(.BeginBatchFetch, fromState: oldState)
//            self.renderDiff(oldState)
//        }
//        
//        PhotoFeedNodeController.fetchDataWithCompletion { resultCount in
//            let action = Action.EndBatchFetch(resultCount: resultCount)
//            let oldState = self.state
//            self.state = PhotoFeedNodeController.handleAction(action, fromState: oldState)
//            self.renderDiff(oldState)
//            context.completeBatchFetching(true)
//        }
//    }
    
    
    

    
    
    
    private func renderDiff(oldState: State) {
        let tableView = _tableNode.view
        tableView.beginUpdates()
        
        // Add or remove items
        let rowCountChange = state.itemCount - oldState.itemCount
        if rowCountChange > 0 {
            let indexPaths = (oldState.itemCount..<state.itemCount).map { index in
                NSIndexPath(forRow: index, inSection: 0)
            }
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        } else if rowCountChange < 0 {
            assertionFailure("Deleting rows is not implemented. YAGNI.")
        }
        
        // Add or remove spinner.
        if state.fetchingMore != oldState.fetchingMore {
            if state.fetchingMore {
                // Add spinner.
                let spinnerIndexPath = NSIndexPath(forRow: state.itemCount, inSection: 0)
                tableView.insertRowsAtIndexPaths([ spinnerIndexPath ], withRowAnimation: .None)
            } else {
                // Remove spinner.
                let spinnerIndexPath = NSIndexPath(forRow: oldState.itemCount, inSection: 0)
                tableView.deleteRowsAtIndexPaths([ spinnerIndexPath ], withRowAnimation: .None)
            }
        }
        tableView.endUpdatesAnimated(false, completion: nil)
    }
    
    /// (Pretend) fetches some new items and calls the
    /// completion handler on the main thread.
    private static func fetchDataWithCompletion(completion: (Int) -> Void) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSTimeInterval(NSEC_PER_SEC) * 0.5))
        dispatch_after(time, dispatch_get_main_queue()) {
            let resultCount = Int(arc4random_uniform(20))
            completion(resultCount)
        }
    }
    
    private static func handleAction(action: Action, fromState state: State) -> State {
        var _state = state
        
        switch action {
        case .BeginBatchFetch:
            _state.fetchingMore = true
        case let .EndBatchFetch(resultCount):
            _state.itemCount += resultCount
            _state.fetchingMore = false
        }
        return _state
    }
}