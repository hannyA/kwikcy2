//
//  HAEditProfileVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit

class HAEditProfileVC: ASViewController, ASTableDelegate, ASTableDataSource, ASEditableTextNodeDelegate {
    
    
    let tableNode: ASTableNode
    
    
    let data: [String]
    
    var username = "username"
    var newUsername = "username"
    
    var realname = "realname"

    var website = "username"
    
    var bio = "bio"
    
    var email = "username"
    
    var mobile = "username"
    
    var gender = "username"
    
    var didChangeData = false
    var didChangeUsername = false
    
    
    
    init() {
        
        data = ["Real Name", "UserName", "website", "bio", "Email", "Mobile Number", "Gender"]
        
        tableNode = ASTableNode(style: .Plain)
        
        super.init(node: tableNode)
        
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(saveProfileEdit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: #selector(dimissMessageVC))
        
        
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let editableNode = currentEditableTextNode {
            editableNode.resignFirstResponder()
        }
    }
    
    
    
    
    //MARK: - ASTableDataSource methods
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let textNode: HAEditableProfileCN
        let row = indexPath.row
        let textTitle = data[row]
        
        if row == 0 {
            let textNode = HASettingCN(withTitle: "", isHeader: true, hasDivider: false)
            textNode.selectionStyle = .None
            textNode.backgroundColor = UIColor.whiteColor()
            return textNode
        } else if row == 1 {
            textNode = HAEditableProfileCN(withTitle: textTitle, hasDivider: false)
        } else {
            textNode = HAEditableProfileCN(withTitle: textTitle, hasDivider: true)
        }
        
        textNode.editableTextNode.delegate = self
        textNode.editableTextNode.view.tag = row
        textNode.editableTextNode.textView.tag = row

        textNode.selectionStyle = .None
        textNode.backgroundColor = UIColor.whiteColor()
        
        return textNode

        
        
        
    }
    
    
    func saveProfileEdit() {
        
        print("saveProfileEdit")
        
        if didChangeUsername || username != newUsername {
            
            let alertController = UIAlertController(title: "Save Changes", message: "Are you sure you want to change your username? You may not be able to get it back ", preferredStyle: .Alert )
            
            let OKAction = UIAlertAction(title: "Yes", style: .Default) { (defaultAction) in
                
                print("Saving new username: \(self.newUsername)")
                print("OK saved!")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            
            print("Saving all data")
            print("OK saved!")
            dismissViewControllerAnimated(true, completion: nil)

        }
    }
    
    func dimissMessageVC() {
        print("dimissMessageVC")
        
        if didChangeData {
            let alertController = UIAlertController(title: "Unsaved Changes", message: "You have unsaved changes. Are you sure you want to cancel?", preferredStyle: .Alert )
            
            let OKAction = UIAlertAction(title: "Yes", style: .Default) { (defaultAction) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    var currentEditableTextNode: ASEditableTextNode?
    
    func editableTextNodeDidUpdateText(editableTextNode: ASEditableTextNode) {
        
        currentEditableTextNode = editableTextNode
        let tag = editableTextNode.textView.tag
        let newText = editableTextNode.textView.text
     
        switch tag {
        case 1:
            username = newText
            newUsername  = newText
            didChangeUsername = true
        case 2:
            realname = newText
            
        case 3:
            website = newText
            
        case 4:
            bio = newText
            
        case 5:
            email = newText
            
        case 6:
            mobile = newText
    
        default:
            gender = newText
        }
        
        didChangeData = true
        
    }
    
    //    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
    //
    //        if indexPath.section == 0 {
    //
    //            return {() -> ASCellNode in
    //                self.basicUserCellNode = BasicProfileCellNode(withProfileModel: self.profileModel, loggedInUser: true)
    //                self.basicUserCellNode!.delegate = self
    //                self.basicUserCellNode!.selectionStyle = .None
    //                return self.basicUserCellNode!
    //            }
    //
    //        } else { // Section 2
    //
    //            print("profileModel count \(profileModel.albumCount())")
    //            // If albums exist
    //            let album = profileModel.albumAtIndex(indexPath.row)
    //
    //            return {() -> ASCellNode in
    //                let albumCellNode = MyAlbumCN(withAlbumObject: album, atIndexPath: indexPath)
    //                albumCellNode.selectionStyle = .None
    //                albumCellNode.delegate = self
    //                return albumCellNode
    //            }
    //        }
    //    }
    //
    
    
}
    