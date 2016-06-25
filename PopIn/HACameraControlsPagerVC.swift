//
//  HACameraControlPagerVC.swift
//  PopIn
//
//  Created by Hanny Aly on 5/26/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

//Used in HACameraVC
// This is of pager node type, slides with different controls
class HACameraControlsPagerVC: ASCellNode, ASPagerNodeDataSource {
    
    let pagerNode: ASPagerNode
    
    
    init(withFrame frame: CGRect) {

        
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.minimumInteritemSpacing  = 1
        _flowLayout.minimumLineSpacing       = 1

        _flowLayout.scrollDirection = .Horizontal
        
//        let a = UICollectionViewLayout()
        
        pagerNode = ASPagerNode(frame: frame, collectionViewLayout: _flowLayout)
        super.init()
        
        pagerNode.setDataSource(self)
        pagerNode.backgroundColor = UIColor.blackColor()
        addSubnode(pagerNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        
        let boundsSize = pagerNode.bounds.size
        
        print("pagerNode : \(boundsSize)")

//        CGSize gradientRowSize = CGSizeMake(boundsSize.width, 100);
        
//        GradientTableNode *node = [[GradientTableNode alloc] initWithElementSize:gradientRowSize];
//        node.preferredFrameSize = boundsSize;
        
        
        
        //        cameraControlNode.preferredFrameSize = boundSize
        
        if index == 0 {
            
            let cameraControlNode = HACameraControlPageNode()
            cameraControlNode.preferredFrameSize = boundsSize
            cameraControlNode.backgroundColor = UIColor.redColor()
            return cameraControlNode
            
        } else {
            
            let libraryControlNode = HACameraLibraryControlNode()
            libraryControlNode.preferredFrameSize = boundsSize
            libraryControlNode.backgroundColor = UIColor.blueColor()
            return libraryControlNode
        }
    }
    
    
    func numberOfPagesInPagerNode(pagerNode: ASPagerNode!) -> Int {
        return 2
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
      
//        pagerNode.flexGrow = true
        pagerNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.width/2)
        
        print("constrainedSize height \(constrainedSize.max.height)")
        
        
        let textStack = ASStackLayoutSpec(direction: .Horizontal,
                                          spacing: 5,
                                          justifyContent: .SpaceBetween,
                                          alignItems: .Center,
                                          children: [pagerNode])
        
        return textStack
 
        
    }
    
    
}