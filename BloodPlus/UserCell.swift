//
//  UserCell.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit

class UserCell:UITableViewCell{
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var userObj : User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(user:User,img:UIImage?=nil){
        self.userObj = user
        self.name.text = user.lastName+","+user.firstName
        self.bloodType.text = "Blood :"+user.bloodType
        self.email.text = user.emailId
        self.phone.text = user.phonenumber
        self.address.text = "Address :"+user.address
    }
}
