//
//  UserCell.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI

//tableview cell class that has all the cell outlets
class UserCell:UITableViewCell,MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userObj : User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //round pic
        RoundPic.roundPicture.roundPic(profileImage)
    }
    
    //assigns values recieved from user class to outlets
    func configureCell(user:User,img:UIImage?=nil){
        
        self.userObj = user
        self.name.text = user.lastName+","+user.firstName
        self.bloodType.text = "Blood :"+user.bloodType
        self.email.text = user.emailId
        self.phone.text = user.phonenumber
        self.address.text = "Address :"+user.address
        
        if img != nil {
            self.profileImage.image = img
        }else{
            //download pic with firebase reference url
            let ref = FIRStorage.storage().referenceForURL(user.profilePicUrl)
            ref.dataWithMaxSize(2*1024*1024, completion: {(data,error) in
            
                if error != nil{
                    print("Firbase download error")
                }else {
                    if let imgData = data {
                        if let image = UIImage(data: imgData) {
                            self.profileImage.image = image
                            TableVC.imageCache.setObject(image, forKey: user.profilePicUrl)
                        }
                    }
                }
            
            })//datawithmaxsize
        }//download pic
    }

}
