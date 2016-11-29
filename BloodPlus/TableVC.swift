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

class TableVC:UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var searchObject:SearchDetails?
    
    @IBOutlet weak var tableView: UITableView!
    static var imageCache:NSCache = NSCache()
    
    var users = [User]()
    var filteredUsers = [User]()
    
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

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]

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
    
}
