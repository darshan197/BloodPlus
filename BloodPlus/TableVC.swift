//
//  TableVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI

class TableVC:UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating , UISearchBarDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    static var imageCache:NSCache = NSCache()
    
    
    var userStore = UserStore(allUsers: [], filteredUsers: [])
    //var users = [User]()
    //var filteredUsers = [User]()

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBarController?.tabBar.items![0].image = UIImage(named: "iconTab0.png")

        
        // search bar color
        searchController.searchBar.layer.borderColor = UIColor.redColor().CGColor
        searchController.searchBar.tintColor = UIColor.redColor()
        //
        navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.24, blue:0.14, alpha:1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: #selector(signoutTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        //tableview delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        //self.users = []
        self.userStore.allUsers = []
        //append Firebase data to array
        DataService.ds.REF_USERS.observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
           
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{

                    if let userDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let user = User(uid: key, userData: userDict)
                        //self.users.append(user)
                        self.userStore.allUsers.append(user)
                        print("User key:\(key) with name \(user.firstName)")
                    }
                    
                }
            }
            
           self.tableView.reloadData()
        })

        //search controller initialization
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["BloodType","Address"]
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search blood group or address.."
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

 
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
           // return filteredUsers.count
            return self.userStore.filteredUsers.count
        }
        //return users.count
        return self.userStore.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user:User

        if searchController.active && searchController.searchBar.text != "" {
            if self.userStore.filteredUsers.count == 0 {
                user = self.userStore.allUsers[indexPath.row]
            }else {
                user = self.userStore.filteredUsers[indexPath.row]
            }
        
        }else{
           user = self.userStore.allUsers[indexPath.row]
        }


        if let cell = tableView.dequeueReusableCellWithIdentifier("user") as? UserCell {
        cell.selectionStyle = .None
        //cell.contentView.userInteractionEnabled = false//disable cell interaction
   
            //mail tap
            let mailTap = UITapGestureRecognizer(target:self, action:#selector(TableVC.mailUser(_:)))
            cell.email.userInteractionEnabled = true
            cell.email.addGestureRecognizer(mailTap)
    
            /////
            
            //call tap
            let callTap = UITapGestureRecognizer(target:self, action:#selector(TableVC.callUser(_:)))
            //tapGestureRecognizer.cancelsTouchesInView = true
            cell.phone.userInteractionEnabled = true
            cell.phone.addGestureRecognizer(callTap)
     
            
            /////
        cell.layer.borderWidth = 2.5
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.redColor().CGColor
    
            //
            if let img = TableVC.imageCache.objectForKey(user.profilePicUrl){
                cell.configureCell(user, img: img as? UIImage)
                return cell
            } else {
                print("ERROR: Error while setting downloaded image")
                cell.configureCell(user) // image default nil
                return cell
            }
            //
        }else{
            return UserCell()
        }
        
        
    }
    
    //search
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("search called")
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchScope(searchBar.text!, scope: scope)
    }
    
    //scope
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchScope(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    //search func
    func filterContentForSearchScope(searchText:String , scope: String = "BloodType"){
        
        switch scope {
        case "BloodType":
            //filteredUsers = []
            self.userStore.filteredUsers = []
            let lower = searchText.lowercaseString
            print("lower is \(lower)")
            for user in self.userStore.allUsers {
                if lower == user.bloodType.lowercaseString {
                    self.userStore.filteredUsers.append(user)
                }
            }
            //print("After filter count is \(filteredUsers.count)")
            
            tableView.reloadData()

        case "Address" :
            //filteredUsers = []
            self.userStore.filteredUsers = []
            let lower = searchText.lowercaseString
            print("lower is \(lower)")
            for user in self.userStore.allUsers {
                if (user.address.lowercaseString.rangeOfString(lower) != nil) {
                    self.userStore.filteredUsers.append(user)
                }
            }
            print("After filter count is \(self.userStore.filteredUsers.count)")
            
            tableView.reloadData()
            
        default:
            print("default")
        }
    }

    //mail
    func mailUser(sender:UITapGestureRecognizer){
        
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.locationInView(self.tableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        print("mail user table called")
        let mailAlert = UIAlertController(title: "Mail?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        mailAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            //
            print("inside action1")
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                //we could even get the cell from the index, too
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? UserCell {
                   mail.setToRecipients([cell.email.text!])
                }
                mail.setSubject("Mail from Blood+")
                mail.setMessageBody("<p>Please help by donating blood..</p>", isHTML: true)
                self.presentViewController(mail, animated: true, completion: nil)
            } else {
                print("Cant send mail")
            }
            
            
            //
        }))
        
        mailAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(mailAlert, animated: true, completion: nil)
    }
    
    //
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // call
    //call
    func callUser(sender:UITapGestureRecognizer){
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.locationInView(self.tableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        print("call user called")
        let callAlert = UIAlertController(title: "Call?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        callAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            print("inside alert")
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? UserCell {
        let CleanphoneNumber = cell.phone.text!.stringByReplacingOccurrencesOfString(" ", withString:
            "")
                if let phoneCallURL:NSURL = NSURL(string: "tel://\(CleanphoneNumber)") {
                    let application:UIApplication = UIApplication.sharedApplication()
                    if (application.canOpenURL(phoneCallURL)) {
                        application.openURL(phoneCallURL);
                    } else {
                        let alertController = UIAlertController(title: "Error making call!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }


            
        }))
        
        callAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(callAlert, animated: true, completion: nil)
    }
    //call
    
    //
    func signoutTapped() {
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("tabletohome", sender: self)
        
    }
    
    
    //
    
}


