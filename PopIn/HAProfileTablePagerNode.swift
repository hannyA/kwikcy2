//
//  HAProfileTablePagerNode.swift
//  PopIn
//
//  Created by Hanny Aly on 6/3/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class HAProfileTablePagerNode: ASCellNode, ASTableDelegate, ASTableDataSource {


    let tableNode: ASTableNode
    
    override init() {
        
        tableNode = ASTableNode(style: .Plain)
        
        super.init()
        
        print("tableNode:")

        tableNode.dataSource = self
        tableNode.delegate = self
        
        addSubnode(tableNode)
    }
    
    
    override func didLoad() {
        super.didLoad()
        
        tableNode.view.allowsSelection = false
//        tableNode.view.separatorStyle = .None
    }
    
    //MARK: - ASTableDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        print("cell simple node")
        return {() -> ASCellNode in
            return SimpleCellNode(withMessage: "Simple Node Profile page")
        }
    }

    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        print("tableView layoutSpecThatFits")
        
        
        let titleNodeStack = ASStackLayoutSpec(direction: .Horizontal,
                                               spacing: 0,
                                               justifyContent: .Start,
                                               alignItems: .Start,
                                               children: [tableNode])
        return titleNodeStack
    }
    
//    override func layout() {
//        super.layout()
//        print("bounds:\(bounds)")
//        tableNode.frame = bounds
//    }

}
    