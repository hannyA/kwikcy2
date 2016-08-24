//
//  HorizontalScrollCell.swift
//  PopIn
//
//  Created by Hanny Aly on 6/17/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import AsyncDisplayKit


protocol HorizontalScrollCellDelegate {
    func numberOfItemsInCollectionView() -> Int
    func itemAtIndexPathRow(row: Int) -> UserUploadFriendModel
    func deleteItemFromTableAndCollectionNodeAtSelectedFriendsIndexRow(index: Int)
}

class HorizontalScrollCell: ASCellNode,
    ASCollectionDataSource,  ASCollectionDelegate,
    ASCollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
//    var imageCellDelegate: ImageCellDelegate?
    var delegate: HorizontalScrollCellDelegate?
    
    
    let kOuterPadding: CGFloat = 14.0
    let kInnerPadding: CGFloat = 10.0

    let kTopPadding: CGFloat    = 5.0
    let kBottomPadding: CGFloat = 30.0

    
    var _collectionNode: ASCollectionNode
    var _elementSize: CGSize
//    var _divider: ASDisplayNode
    
    
    
    init(initWithElementSize size: CGSize) {
        _elementSize = size
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = _elementSize
        flowLayout.minimumInteritemSpacing = kInnerPadding
        _collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
    
        // Hairline cell separator
//        _divider = ASDisplayNode()
//        _divider.backgroundColor = UIColor.lightGrayColor()
//        
        super.init()
        
        backgroundColor = UIColor.greenColor()
        _collectionNode.backgroundColor = UIColor.whiteColor()
        
        addSubnode(_collectionNode)
//        addSubnode(_divider)
        
    }
    
    override func didLoad() {
        super.didLoad()
        _collectionNode.dataSource = self
        _collectionNode.delegate = self
    }
    

//    override func layout() {
//        super.layout()
//        
////        _collectionNode.frame = bounds
////        _collectionNode.view.contentInset = UIEdgeInsetsMake(kTopPadding, kOuterPadding, kBottomPadding, kOuterPadding);
//        
//        print("_collectionNode.frame: \(_collectionNode.frame)")
//        print("_collectionNode.bounds: \(_collectionNode.bounds)")
//        print("bounds: \(bounds)")
//        print("frame: \(frame)")
//        
//        // Manually layout the divider.
//        let pixelHeight:CGFloat = 1.0 / UIScreen.mainScreen().scale// [[UIScreen mainScreen] scale];
//        _divider.frame = CGRectMake(0, 0, calculatedSize.width, pixelHeight)
//    }
    
//    
    func collectionView(collectionView: ASCollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(kTopPadding, kOuterPadding, kBottomPadding, kOuterPadding)
    }
    
    
//    override func layoutDidFinish() {
//        super.layoutDidFinish()
//        print("layoutDidFinish")
//
//        print("_collectionNode height \(_collectionNode.view.frame.height)")
//        print("_collectionNode width \(_collectionNode.view.frame.width)")
//    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = constrainedSize.max.width
        _collectionNode.preferredFrameSize = CGSizeMake(width, _elementSize.height + 40)
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0.0, 0, 0.0), child: _collectionNode)
        return insetSpec
    }
    
    
    
    
    
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        print("collectionView: numberOfItemsInSection \(section)")
        if let delegate = delegate {
            return delegate.numberOfItemsInCollectionView()
        }
        return 0
    }
    
    
    
    func insertItemAtIndexPathRow(index: Int) { //, forObjectAtIndexPathRow indexRow: Int) {
       
        print("insertItemAtIndexPathRow")
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        _collectionNode.beginUpdates()
        _collectionNode.view.insertItemsAtIndexPaths([indexPath])
        _collectionNode.endUpdatesAnimated(false, completion: { (inserted) in

            if inserted && indexPath.row > 4 {
                self._collectionNode.view.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Right , animated: true)
            }
        })
    }
    
    
    func deleteItemAtIndexPathRow(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        _collectionNode.beginUpdates()
        _collectionNode.view.deleteItemsAtIndexPaths([indexPath])
        _collectionNode.endUpdatesAnimated(true)

        cellNodeViews.removeAtIndex(index)
    }
    
    
    
    
    
    
    
//    var allowPanGesture: Bool = false

//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        print("gestureRecognizer: shouldReceiveTouch")
//        
//        if gestureRecognizer is UIPanGestureRecognizer {
//            print("gestureRecognizer is UIPanGestureRecognizer")
//
//            
//        } else if gestureRecognizer is UISwipeGestureRecognizer {
//            print("gestureRecognizer is UISwipeGestureRecognizer")
//        }
//        
//        return true
//    }

    
    
//    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("gestureRecognizerShouldBegin ========================")
//        
////        if gestureRecognizer is UIPanGestureRecognizer {
////            print("gestureRecognizer is UIPanGestureRecognizer")
////        } else if gestureRecognizer is UISwipeGestureRecognizer {
////            print("gestureRecognizer is UISwipeGestureRecognizer")
////        }
////        print(" =====================================================")
//
////        if gestureRecognizer is UIPanGestureRecognizer {
////
////            if let _ = gestureRecognizer as? UIPanGestureRecognizer {
////
////                if allowPanGesture {
////                    return true
////                } else {
////                    return false
////                }
////            }
////        } else if gestureRecognizer is UISwipeGestureRecognizer {
////            if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
////                
////                if swipeGesture.direction == .Left || swipeGesture.direction == .Right {
////                    allowPanGesture = false
////                } else  {
////                    allowPanGesture = true
////                }
////            }
////            return false
////        }
//        
//        return true
//    }
    
    
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//      
//        print("shouldRecognizeSimultaneouslyWithGestureRecognizer")
//
//        
//        if gestureRecognizer is UIPanGestureRecognizer {
//            print("gestureRecognizer is UIPanGestureRecognizer")
//        } else if gestureRecognizer is UISwipeGestureRecognizer {
//            print("gestureRecognizer is UISwipeGestureRecognizer")
//        }
//        if otherGestureRecognizer is UIPanGestureRecognizer {
//            print("otherGestureRecognizer is UIPanGestureRecognizer")
//        } else if otherGestureRecognizer is UISwipeGestureRecognizer {
//            print("otherGestureRecognizer is UISwipeGestureRecognizer")
//        }
//        return true
//    }
    
    
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
//         shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        
//        if gestureRecognizer is UIPanGestureRecognizer {
//            print("gestureRecognizer is UIPanGestureRecognizer")
//            if let swipeGesture = otherGestureRecognizer as? UISwipeGestureRecognizer {
//                
//                if swipeGesture.direction == .Left || swipeGesture.direction == .Right {
//                    return false
//                } else  {
//                    return true
//                }
//            }
//
//            
//        } else if gestureRecognizer is UISwipeGestureRecognizer {
//            print("gestureRecognizer is UISwipeGestureRecognizer")
//            if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
//                
//                if swipeGesture.direction == .Left || swipeGesture.direction == .Right {
//                    return false
//                } else  {
//                    return true
//                }
//            }
//
//        }
//    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        
//        
//    }
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
//         shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        
//        if gestureRecognizer is UIPanGestureRecognizer {
//            print("gestureRecognizer is UIPanGestureRecognizer")
//            if let swipeGesture = otherGestureRecognizer as? UISwipeGestureRecognizer {
//                
//                if swipeGesture.direction == .Left || swipeGesture.direction == .Right {
//                    return false
//                } else  {
//                    return true
//                }
//            }
//            
//            
//        } else if gestureRecognizer is UISwipeGestureRecognizer {
//            print("gestureRecognizer is UISwipeGestureRecognizer")
//            if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
//                
//                if swipeGesture.direction == .Left || swipeGesture.direction == .Right {
//                    return false
//                } else  {
//                    return true
//                }
//            }
//            
//        }
//
//        
//    }
    
    
    
//    func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
//        
//        let userModel = delegate!.itemAtIndexPathRow(indexPath.row)
//        
//        let image = UIImage(named: userModel.userTestPic!)
//        
//        return {() -> ASCellNode in
//            
//            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.intoThingAir))
//            panGesture.minimumNumberOfTouches = 1
//            panGesture.delegate = self
//            
//            let imageCellNode = ImageCell(withImage: image!, size: self._elementSize, gesture: panGesture)
//            imageCellNode.preferredFrameSize = self._elementSize
//            
//            self.cellNodeViews.append(imageCellNode)
//            
//            return imageCellNode
//        }
//    }
    
    

    func collectionView(collectionView: ASCollectionView, nodeForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNode
    {
        let userModel = delegate!.itemAtIndexPathRow(indexPath.row)
//        
        var image: UIImage?
        if let downloadedFile = userModel.downloadFileURL {
            if let data = NSData(contentsOfURL: downloadedFile) {
                image = UIImage(data: data)!
            }
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.intoThingAir))
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        
        
        let imageCellNode = ImageCell(withImage: image, size: self._elementSize, gesture: panGesture, forUser: userModel)
//        imageCellNode.preferredFrameSize = self._elementSize
        
        self.cellNodeViews.append(imageCellNode)
 
//        let startSwipe = UISwipeGestureRecognizer(target: self, action: #selector(some))
//        startSwipe.direction = [.Up, .Down]
//        startSwipe.numberOfTouchesRequired = 1
//        startSwipe.delegate = self
//        imageCellNode.view.addGestureRecognizer(startSwipe)

        
        return imageCellNode
    }
    
    
    
    var cellNodeViews = [ASCellNode]()
    
    var originalCenterPoint: CGPoint?
    
    func intoThingAir(slideFinger: UIPanGestureRecognizer) {
        
        let translation = slideFinger.translationInView(view)
        
//        let height = view.bounds.height  // 90
//        let originY = view.bounds.origin.y //90
//        let maxY = view.bounds.maxY  //0
//        let midY = view.bounds.midY //45
        
        switch slideFinger.state {
        case .Began:
           originalCenterPoint = slideFinger.view?.center
           
        case .Changed:
            if let view = slideFinger.view {
                view.center = CGPoint(x:view.center.x ,
                                      y:view.center.y + translation.y)
            }
            
//            let viewOrigin = view.bounds.origin
//            
//            let endPoint = CGPointMake(slideFinger.view?.center.x, <#T##y: CGFloat##CGFloat#>)
//            
//            let finalY:CGPoint = (slideFinger.view?.convertPoint(viewOrigin, toView: slideFinger.view))!
//            print("finalY: \(finalY)")
//            
//
//            let slidePoint = slideFinger.view?.superview!.convertPoint((slideFinger.view?.center)!, toView: view)
//
//            
//            let a = slideFinger.view?.superview!.convertPoint(<#T##point: CGPoint##CGPoint#>, fromView: <#T##UIView?#>)
            
            
            
        case .Ended:
          
            let startingBoxCenter = (originalCenterPoint?.y)!  // 25
            let boxCenterToBoxBorder = (slideFinger.view?.bounds.midY)! //25
            let boxCenterToParentBorder = view.bounds.midY // 45
            
            
            
            let distanceToBottomBorder = view.bounds.height - (originalCenterPoint?.y)!  // 90 - 25
            let distanceToTopBorder = view.bounds.origin.y - (originalCenterPoint?.y)!   // 25
            
            
            
            let slidePoint = slideFinger.view?.superview!.convertPoint((slideFinger.view?.center)!, toView: view)
            
            let lastCenterY = (slidePoint?.y)!

            
            
            let velocity = slideFinger.velocityInView(view)
            let absVelocity = fabs(velocity.y)
            
            if  lastCenterY < 0   ||
                lastCenterY >  view.bounds.height ||
                absVelocity > 300 {
                // remove box
                
                
                
                
                
                let centerX = (originalCenterPoint?.x)!
//                let y: CGFloat
                let yVelocity = velocity.y
                let finalPoint:CGPoint

                
                let topEnd = view.bounds.origin.y - (slideFinger.view?.bounds.midY)!
                let bottomEnd = view.bounds.height + (slideFinger.view?.bounds.midY)!
                
                let topPoint = CGPointMake(centerX, topEnd)
                let bottomPoint = CGPointMake(centerX, bottomEnd)
            
                
                
                if absVelocity > 300 {
                    if yVelocity > 0 {
                        finalPoint = bottomPoint
                    } else {
                        finalPoint = topPoint
                    }
                } else if lastCenterY > 0 {
                    finalPoint = bottomPoint
                } else {
                    finalPoint = topPoint
                }
                
                
                
//                
//                if absVelocity > 300 {
//                    if yVelocity > 0 {
//                        y = startingBoxCenter + boxCenterToBoxBorder + boxCenterToParentBorder // Moves up
//                    } else {
//                        y = startingBoxCenter - boxCenterToParentBorder - boxCenterToBoxBorder // Moves down
//                    }
//                } else if lastCenterY > 0 {
//                    y = startingBoxCenter + boxCenterToBoxBorder + boxCenterToParentBorder // Moves up
//                } else {
//                    y = startingBoxCenter - boxCenterToParentBorder - boxCenterToBoxBorder // Moves down
//                }
//                
                
                
                
                
                
                
                if let view = slideFinger.view {
                    
                    UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: {
                        
                        view.center = finalPoint
                        
                        }, completion: { (finished) in
                         
                            
                            let index = self.cellNodeViews.indexOf({ (cellNode: ASCellNode) -> Bool in
                                if cellNode.view == slideFinger.view {
                                    return true
                                }
                                return false
                            })
                            
                            self.delegate!.deleteItemFromTableAndCollectionNodeAtSelectedFriendsIndexRow(index!)
                    })
                    
//                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .CurveEaseIn, animations: {
//                        
//                        view.center = finalPlace
//                        }, completion: { (finished) in
//                            let index = self.viewModel.indexOf( slideFinger.view! )!
//                            self.delegate!.deleteItemFromTableAndCollectionNodeAtSelectedFriendsIndexRow(index)
//                    })
                }
            }  else {
                
                if let view = slideFinger.view {
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: .CurveEaseIn, animations: {
                       
                        view.center = self.originalCenterPoint!
                        
                        }, completion: nil)
                }
            }
        default: print("Failed")
        }
        slideFinger.setTranslation(CGPointZero, inView: self.view)
    }
    

    
//    func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
//        
//        return {() -> ASCellNode in
//            let titleCN = SimpleCellNode(withMessage: "boo")
//            return titleCN
//        }
    
////        return {() -> ASCellNode in
////            let imageCell = ImageCell()
////            imageCell.preferredFrameSize = self._elementSize
////            return imageCell
////        }
//        
//    }
    
    
    
    
}

