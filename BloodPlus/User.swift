//
//  User.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _firstName : String!
    private var _lastName : String!
    private var _address : String!
    private var _bloodType : String!
    private var _phoneNumber : String!
    private var _emailId : String!
    private var _profilePicUrl : String!
    private var _userName:String!
    private var _userRef:FIRDatabaseReference!
    private var _uid:String!
    
    var firstName : String{
        if(_firstName == nil){
            return ""
        }
        return _firstName
    }
    
    var lastName : String{
        if(_lastName == nil){
            return ""
        }
        return _lastName
    }
    
    var address : String{
        if(_address == nil){
            return ""
        }
        return _address
    }
    
    var bloodType : String{
        if(_bloodType == nil){
            return ""
        }
        return _bloodType
    }
    
    var phonenumber : String{
        if(_phoneNumber == nil){
            return ""
        }
        return _phoneNumber
    }
    
    var emailId : String{
        if(_emailId == nil){
            return ""
        }
        return _emailId
    }
    
    var profilePicUrl : String{
        if(_profilePicUrl == nil){
            return ""
        }
        return _profilePicUrl
    }
    
    var userName:String {
        if(_userName == nil){
            return _userName
        }
        return _userName
    }
    
    var userRef:FIRDatabaseReference{
        return _userRef
    }
    
    var uid:String{
        return _uid
    }
    
    init(uid:String,firstName : String, lastName : String,address:String,bloodType:String, phoneNumber: String, emailId:String, profilePicUrl : String){
        self._firstName = firstName
        self._lastName = lastName
        self._address = address
        self._bloodType = bloodType
        self._phoneNumber = phoneNumber
        self._emailId = emailId
        self._profilePicUrl = profilePicUrl
        self._uid = uid
    }
    
    init(uid:String,userData:Dictionary<String,AnyObject>) {
       // self._userName = userName
        
        self._uid = uid
        
        if let fName = userData["firstname"] as? String {
            self._firstName = fName
        }
        
        if let lName = userData["lastname"] as? String {
            self._lastName = lName
        }
        
        if let addr = userData["address"] as? String {
            self._address = addr
        }
        
        if let blood = userData["bloodtype"] as? String {
            self._bloodType = blood
        }
        
        if let phone = userData["phone"] as? String {
            self._phoneNumber = phone
        }
        
        if let email = userData["email"] as? String {
            self._emailId = email
        }
        
        if let imgUrl = userData["profilepic"] as? String {
            self._profilePicUrl = imgUrl
        }
        
        _userRef = DataService.ds.REF_USERS.child(uid)
    }
    
    
    //
    init(email:String,uid:String) {
        self._uid = uid
        self._emailId = email
    }
}
