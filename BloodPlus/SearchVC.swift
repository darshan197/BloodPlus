//
//  SearchVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchVC : UIViewController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signoutTapped(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("log", sender: self)
        
    }
}
