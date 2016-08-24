//
//  INCameraTableNode.swift
//  PopIn
//
//  Created by Hanny Aly on 5/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit


class INCameraTableNode: ASCellNode, ASTableViewDelegate, ASTableViewDataSource {

    let _tableNode: ASTableNode
    let rowSize: CGSize
    let controlsCellNode: ASCellNode

    
    init(withRowSize size: CGSize, andControlNode controlNode: ASCellNode) {

        _tableNode = ASTableNode(style: .Plain)
        rowSize = size
        controlsCellNode = controlNode
        
        super.init()
        
        addSubnode(_tableNode)
    }

    
    override func didLoad() {
        super.didLoad()

        _tableNode.delegate = self
        _tableNode.dataSource = self

        _tableNode.view.separatorStyle = .None
        _tableNode.view.backgroundColor = UIColor.clearColor()
        _tableNode.view.scrollEnabled = false
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    

    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let node = controlsCellNode
        node.backgroundColor = UIColor.clearColor()
        node.preferredFrameSize = rowSize
        node.selectionStyle = .None
    
        return node
    }
    
    override func layout() {
        super.layout()
        _tableNode.frame = bounds
    }
}
