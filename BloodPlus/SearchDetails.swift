//
//  SearchDetails.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation

class SearchDetails{
    
    private var _addressToSearch:String!
    private var _pincode:String!
    private var _bloodType:String!
    
    var addressToSearch:String{
        if _addressToSearch == nil{
            _addressToSearch = ""
        }
        return _addressToSearch
    }
    
    var pincode:String {
        if _pincode == nil {
            return ""
        }
        return _pincode
    }
    
    var bloodType:String{
        if _bloodType == nil {
            return ""
        }
        return _bloodType
    }
    
    
    init(addr:String,pincode:String,blood:String) {
        self._addressToSearch = addr
        self._pincode = pincode
        self._bloodType = blood
    }
    
}
