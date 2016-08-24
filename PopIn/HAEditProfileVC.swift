//
//  HAEditProfileVC.swift
//  PopIn
//
//  Created by Hanny Aly on 6/24/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//


import AsyncDisplayKit
import SwiftIconFont
import AWSMobileHubHelper
import SwiftyDrop

class HAEditProfileVC: ASViewController, ASTableDelegate, ASTableDataSource, UITextFieldDelegate {
    
    
    struct TextFieldValues {
        var placeHolder : String
        var text        : String
        var imageCode   : String?
        var imageType   : Fonts?
    }
    
    struct UserData {
        var username :String?
        var fullname :String?
        var website  :String?
        var bio      :String?
        var email    :String?
        var mobile   :String?
        var gender   :String?
    }

    
    /*
     Material
     realname: hearing, sort.by.alpha, subtitles, view.headline, font.download, border.color
     website: web
     gender : wc
     dob: cake
     */
    
    let tableNode: ASTableNode
    
    var textFieldValues = [TextFieldValues]()
    var publicTextFields  = [UITextField]()
    
    var originalUserData: UserData
    var changedUserData : UserData
    
    init() {
        tableNode = ASTableNode(style: .Plain)
        
        
        originalUserData = UserData()
        changedUserData  = UserData()
        
        super.init(node: tableNode)
        
        tableNode.view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        tableNode.view.allowsSelection = true
        tableNode.view.separatorStyle = .None
        tableNode.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Edit Profile"
        navigationController?.hidesNavigationBarHairline = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(saveProfileEdit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: #selector(dimissMessageVC))
    
        
        
        let fullname    = Me.fullname() ?? ""
        let username    = Me.username() ?? ""
        let website     = Me.website() ?? ""
        let bio         = Me.bio() ?? ""
        let email  = Me.email() ?? ""
        let mobile = Me.mobile() ?? ""
//        let gender = Me.gender() ?? ""
        
        textFieldValues.append(TextFieldValues(placeHolder: "", text: "", imageCode: nil, imageType: nil))
        textFieldValues.append(TextFieldValues(placeHolder: "Name", text: fullname, imageCode: "speakerphone", imageType: .Ionicon ))
        textFieldValues.append(TextFieldValues(placeHolder: "Username", text: username, imageCode: "ios-person", imageType: .Ionicon ))
        textFieldValues.append(TextFieldValues(placeHolder: "Website", text: website, imageCode: "link", imageType: .Ionicon ))
        textFieldValues.append(TextFieldValues(placeHolder: "Bio", text: bio, imageCode: "information-circled", imageType: .Ionicon ))
        textFieldValues.append(TextFieldValues(placeHolder: "PRIVATE INFO", text: "PRIVATE INFO", imageCode: nil, imageType: nil ))
        textFieldValues.append(TextFieldValues(placeHolder: "Email", text: email, imageCode: "at", imageType: .Ionicon ))
        textFieldValues.append(TextFieldValues(placeHolder: "Mobile Number", text: mobile, imageCode: "pound", imageType: .Ionicon ))
//        textFieldValues.append(TextFieldValues(placeHolder: "Gender", text: gender, imageCode: "wc", imageType: .MaterialIcon ))

        originalUserData.fullname = fullname // 1
        originalUserData.username = username // 2
        originalUserData.fullname = fullname // 2
        originalUserData.website  = website  // 3
        originalUserData.bio      = bio      // 4
        
        originalUserData.email    = email    // 6
        originalUserData.mobile   = mobile   // 7
//        originalUserData.gender   = gender   // 8
        
        changedUserData = originalUserData
        
        print("originalUserData: \(originalUserData)")
        print("changedUserData: \(changedUserData)")
    }
    
    
    var textField:UITextField?
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.textField = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch textField.tag {
        case 1:
            changedUserData.fullname = textField.text
        case 2:
            changedUserData.username = textField.text
        case 3:
            changedUserData.website  = textField.text
        case 4:
            changedUserData.bio      = textField.text
        case 6:
            changedUserData.email    = textField.text
        case 7:
            changedUserData.mobile   = textField.text
//        case 8:
//            changedUserData.gender   = textField.text
        default:
            break
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let textField = textField {
            textField.resignFirstResponder()
        }
    }
    
    
    //MARK: - ASTableDataSource methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldValues.count
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textField?.resignFirstResponder()
    }
    
    
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let leftImageSize:CGFloat = 20.0
        
        func textNodeWith(textTitle: String, placeHolder: String, left image: UIImage, hasTopDivider topDivider: Bool, fullWidth topWidth: Bool, hasBottomDivider bottomDivider: Bool, fullWidth bottomWidth: Bool) -> HAEditableProfileCN {
            
            let textNode = HAEditableProfileCN(withLeftImage: image,
                                               text: textTitle,
                                               placeHolderText: placeHolder,
                                               hasTopDivider: topDivider,
                                               fullWidth: topWidth,
                                               hasBottomDivider: bottomDivider,
                                               fullWidth: bottomWidth)
            textNode.selectionStyle = .None
            textNode.backgroundColor = UIColor.whiteColor()
            return textNode
        }
        
        // Header rows
        if indexPath.row == 0 || indexPath.row == 5 {
            
            let hasTopDivider = indexPath.row == 0 ? false: true
           
            let textNode = HASettingCN(withTitle: textFieldValues[indexPath.row].text,
                                       isHeader: true,
                                       hasTopDivider: hasTopDivider,
                                       hasBottomDivider: true)
            textNode.selectionStyle = .None
            textNode.userInteractionEnabled = false
            return textNode
        }
        
        // ALl other rows
        let image = UIImage.icon(from: textFieldValues[indexPath.row].imageType!,
                                 code: textFieldValues[indexPath.row].imageCode!,
                                 imageSize: CGSizeMake(leftImageSize, leftImageSize),
                                 ofSize: leftImageSize,
                                 color: UIColor.blackColor())
        
        let hasTopDivider = (indexPath.row == 1 || indexPath.row == 6) ? false: true
        let hasBottomDivider = indexPath.row == textFieldValues.count - 1 ? true: false
        
        let textNode = textNodeWith(textFieldValues[indexPath.row].text,
                                    placeHolder: textFieldValues[indexPath.row].placeHolder, left: image,
                                    hasTopDivider: hasTopDivider, fullWidth: false,
                                    hasBottomDivider: hasBottomDivider, fullWidth: hasBottomDivider)
        
        let textField = textNode.textField.textField
        textField.delegate = self
        textField.tag = indexPath.row
        
        
        if indexPath.row == 1 {
            textField.autocapitalizationType = .Words
        }
        if indexPath.row == 2 {
            textField.autocapitalizationType = .None
        }
        
        if indexPath.row == 3 {
            textField.keyboardType = .URL
            textField.autocapitalizationType = .None
        }
        if indexPath.row == 3 {
            textField.autocapitalizationType = .Sentences
        }
        if indexPath.row == 6 {
            textField.keyboardType = .EmailAddress
            textField.autocapitalizationType = .None
        }
        
        if indexPath.row == 7 {
            textField.keyboardType = .PhonePad
        }
        
        publicTextFields.append(textField)
        
        return textNode
        
    }
    
    
    func textFieldForIndexRow(row: Int) -> UITextField?  {
        
        let textFields = publicTextFields.filter { (textField) -> Bool in
            if textField.tag == row {
                return true
            }
            return false
        }
        return textFields.first
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Did select indexpath section: \(indexPath.section), row: \(indexPath.row)")
        
        if let textField = textFieldForIndexRow(indexPath.row) {
            textField.becomeFirstResponder()
        }
    }

    func saveChanges() {
        
        disableView()
        
        let acctId = Me.acctId()!
        
        var jsonInput:[String: AnyObject] = [kAcctId: acctId]
        
        if originalUserData.username?.lowercaseString != changedUserData.username?.lowercaseString {
            jsonInput[kUserName] = changedUserData.username
        }
        
        jsonInput[kFullName] = originalUserData.fullname != changedUserData.fullname ? changedUserData.fullname : originalUserData.fullname
        
        jsonInput[kDomain] = originalUserData.website != changedUserData.website ? changedUserData.website : originalUserData.website
        
        jsonInput[kAbout] = originalUserData.bio != changedUserData.bio ? changedUserData.bio : originalUserData.bio
        
        jsonInput[kEmail] = originalUserData.email != changedUserData.email ? changedUserData.email : originalUserData.email
        
        jsonInput[kMobile] = originalUserData.mobile != changedUserData.mobile ? changedUserData.mobile : originalUserData.mobile
        
//        jsonInput[kGender] = originalUserData.gender != changedUserData.gender ? changedUserData.gender : originalUserData.gender
        
        
        let parameters: [String: AnyObject]
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonInput, options: .PrettyPrinted)
            parameters = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return
        }
        
                
        AWSCloudLogic.defaultCloudLogic().invokeFunction(AWSLambdaUpdateProfile,
         withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    self.enableView()
                    print("CloudLogicViewController: Result: \(result)")
                    
                    if let response = HAProfileEditResponse(response: result) {
                    
                        if let errorMessage = response.errorMessage {
                            
                            Drop.down(errorMessage,
                                state: .Warning ,
                                duration: 3.0,
                                action: nil)
                        } else {
                            
                            print("response.newData: \(response.newData)")
                            
                            if let username = response.newData.username {
                                print("response.newData: \(response.newData.username)")
                                Me.saveUsername(username)
                            }
                            if let fullname = response.newData.fullname {
                                print("response.newData: \(response.newData.fullname)")
                                Me.saveFullname(fullname)
                            }
                            if let website = response.newData.website {
                                print("response.newData: \(response.newData.website)")
                                Me.saveWebsite(website)
                            }
                            if let bio = response.newData.bio {
                                print("response.newData: \(response.newData.bio)")
                                Me.saveBio(bio)
                            }
                            if let email = response.newData.email {
                                print("response.newData: \(response.newData.email)")
                                Me.saveEmail(email)
                            }
                            if let mobile = response.newData.mobile {
                                print("response.newData: \(response.newData.mobile)")
                                Me.saveMobile(mobile)
                            }

//                            if let gender = response.newData.gender {
//                                Me.saveGender(gender)
//                            }
                            self.dimissMessageVC()
                        }
                    } else {
                        
                        Drop.down("\(AppName) is having some problems and could not save data. Try again shortly",
                            state: .Warning ,
                            duration: 3.0,
                            action: nil)
                    }
                })
            }
            
            if let _ = AWSConstants.errorMessage(error) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.enableView()
                    Drop.down("\(AppName) is having some problems and could not save data. Try again shortly",
                        state: .Warning ,
                        duration: 3.0,
                        action: nil)
                })
            }
        }
    }
    
    
    
    func saveProfileEdit() {
        
        if let textField = textField {
            textField.resignFirstResponder()
        }
        
        if originalUserData.username != changedUserData.username && changedUserData.username?.characters.count > 0 {
            
            let alertController = UIAlertController(title: "Save Changes",
                                                    message: "Are you sure you want to change your username to \(changedUserData.username)? You may not be able to get it back",
                                                    preferredStyle: .Alert )

            let OKAction = UIAlertAction(title: "Yes", style: .Default) { (defaultAction) in

                print("Saving new username: \(self.changedUserData.username)")
            }
            alertController.addAction(OKAction)

            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)

        } else if anyChangesMade() {
            saveChanges()
        } else {
            dimissMessageVC()
        }
    }
    
    func anyChangesMade() -> Bool {
        
        if originalUserData.username?.lowercaseString    != changedUserData.username?.lowercaseString
            || originalUserData.fullname   != changedUserData.fullname
            || originalUserData.website    != changedUserData.website
            || originalUserData.bio        != changedUserData.bio
            || originalUserData.email      != changedUserData.email
            || originalUserData.mobile     != changedUserData.mobile
            //       ||  originalUserData.gender     != changedUserData.gender
        {
            return true
        }
        return false
    }
    
    
    func enableView() {
        navigationItem.rightBarButtonItem?.enabled = true
        tableNode.userInteractionEnabled = true
    }
    
    func disableView() {
        navigationItem.rightBarButtonItem?.enabled = false
        tableNode.userInteractionEnabled = false
    }
    
    
    
    func dimissMessageVC() {
        print("dimissMessageVC")
        dismissViewControllerAnimated(true, completion: nil)

    }

}
    