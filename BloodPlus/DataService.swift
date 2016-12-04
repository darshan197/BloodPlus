//
//  DataService.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService{

    //static class available throughout the project
    static let ds = DataService()
    
    //firebase references
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USER_IMAGES = STORAGE_BASE.child("user-pics")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS:FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_IMAGES:FIRStorageReference{
        return _REF_USER_IMAGES
    }
}
