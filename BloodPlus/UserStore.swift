//
//  UserStore.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/1/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation

class UserStore {

    //stores all the users
    var allUsers = [User]()
    
    //filtered users based on search criteria
    var filteredUsers = [User]()
    
    init(allUsers:[User],filteredUsers:[User]) {
        self.allUsers = allUsers
        self.filteredUsers = filteredUsers
    }
}
