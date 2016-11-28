//
//  SearchDetails.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation

class SearchDetails{
    
    var addressToSearch:String!
    var pincode:String!
    
    init(addr:String,pincode:String) {
        self.addressToSearch = addr
        self.pincode = pincode
    }
    
}
