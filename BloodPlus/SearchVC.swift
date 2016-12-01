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
        
        navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.24, blue:0.14, alpha:1.0)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: #selector(signoutTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    
    
    func signoutTapped() {
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("log", sender: self)
        
    }
}
