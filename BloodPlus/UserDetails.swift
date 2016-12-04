//
//  UserDetails.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/2/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation

class UserDetails {
    //class to store just email and password of user
    private var _email : String!
    private var _password:String!
    var uid: String = ""
    
    var email:String {
        if _email == nil {
            return ""
        }
        return _email
    }
    
    var password:String {
        if _password == nil {
            return ""
        }
        return _password
    }
    
    
    init(email:String,password:String) {
        self._email = email
        self._password = password
    }
    
}
