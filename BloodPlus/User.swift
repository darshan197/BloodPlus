//
//  User.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation


class User {
    private var _firstName : String!
    private var _lastName : String!
    private var _address : String!
    private var _bloodType : String!
    private var _phoneNumber : String!
    private var _emailId : String!
    private var _profilePicUrl : String!
    
    var firstName : String{
        return _firstName
    }
    
    var lastName : String{
        return _lastName
    }
    
    var address : String{
        return _address
    }
    
    var bloodType : String{
        return _bloodType
    }
    
    var phonenumber : String{
        return _phoneNumber
    }
    
    var emailId : String{
        return _emailId
    }
    
    var profilePicUrl : String{
        return _profilePicUrl
    }
    
    init(firstName : String, lastName : String,address:String,bloodType:String, phoneNumber: String, emailId:String, profilePicUrl : String){
        self._firstName = firstName
        self._lastName = lastName
        self._address = address
        self._bloodType = bloodType
        self._phoneNumber = phoneNumber
        self._emailId = emailId
        self._profilePicUrl = profilePicUrl
    }
}
