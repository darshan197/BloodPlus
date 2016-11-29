//
//  TableVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit

class TableVC:UIViewController{
    
    var searchObject:SearchDetails?
    
    static var imageCache:NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Chiranth: Recieved details are :\(searchObject?.addressToSearch)\(searchObject?.pincode)")
        //testing3
    }

    
}
