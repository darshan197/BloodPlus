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

class TableVC:UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating , UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    static var imageCache:NSCache = NSCache()
    
    var userStore = UserStore(allUsers: [], filteredUsers: [])
    //var users = [User]()
    //var filteredUsers = [User]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tableview loaded")
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
    //

}


