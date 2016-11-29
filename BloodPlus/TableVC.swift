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

class TableVC:UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    var searchObject:SearchDetails?
    
    @IBOutlet weak var tableView: UITableView!
    static var imageCache:NSCache = NSCache()
    
    var users = [User]()
    var filteredUsers = [User]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("Chiranth: Recieved details are :\(searchObject?.addressToSearch)\(searchObject?.pincode)")
        
        //tableview delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        self.users = []
        //append Firebase data to array
        DataService.ds.REF_USERS.observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
           
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{

                    if let userDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let user = User(uid: key, userData: userDict)
                        self.users.append(user)
                        print("User key:\(key) with name \(user.firstName)")
                    }
                    
                }
            }
            
           self.tableView.reloadData()
        })

        //search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user:User
        
        if searchController.active && searchController.searchBar.text != "" {
            if filteredUsers.count == 0 {
                user = users[indexPath.row]
            }else {
                user = filteredUsers[indexPath.row]
            }
        
        }else{
           user = users[indexPath.row]
        }

        
        if let cell = tableView.dequeueReusableCellWithIdentifier("user") as? UserCell {
            
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
            filteredUsers = []
            let lower = searchController.searchBar.text!.lowercaseString
            print("lower is \(lower)")
            for user in users {
                if lower == user.bloodType.lowercaseString {
                    filteredUsers.append(user)
                }
            }
            print("After filter count is \(filteredUsers.count)")

        tableView.reloadData()

    }

}


