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
        
        //call tap
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(callUser))
        phone.userInteractionEnabled = true
        phone.addGestureRecognizer(tapGestureRecognizer)
        
        //mail tap
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(mailUser))
        email.userInteractionEnabled = true
        email.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    
    
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
            //download pic
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
        }
    }
    
    //call
    func callUser(){
        
        print("call user called")
        let callAlert = UIAlertController(title: "Call?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        callAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
           
            let CleanphoneNumber = self.phone.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(CleanphoneNumber)") {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL);
                } else {
                    let alertController = UIAlertController(title: "Error making call!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        }))
        
        callAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.window?.rootViewController!.presentViewController(callAlert, animated: true, completion: nil)
    }
    
    //mail
    func mailUser(){
        print("mail user called")
        let mailAlert = UIAlertController(title: "Mail?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        mailAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            //
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([self.email.text!])
                mail.setSubject("Mail from Blood+")
                mail.setMessageBody("<p>Please help by donating blood..</p>", isHTML: true)
                self.window?.rootViewController!.presentViewController(mail, animated: true, completion: nil)
            } else {
                print("Cant send mail")
            }

            
            //
            }))
        
        mailAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.window?.rootViewController!.presentViewController(mailAlert, animated: true, completion: nil)
    }
    
    //
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
