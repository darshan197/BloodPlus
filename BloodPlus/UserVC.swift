//
//  UserVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/2/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserVC: UIViewController , UITextFieldDelegate {

    var user = FIRAuth.auth()?.currentUser
    var userref = DataService.ds.REF_USERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstField.delegate = self
    }
    
    @IBOutlet var firstField:UITextField!

    @IBAction func update(sender: AnyObject) {
        if !firstField.text!.isEmpty {
            userref.child("\(user!.uid)/firstname").setValue(firstField?.text)
            try! FIRAuth.auth()?.signOut()
            performSegueWithIdentifier("uservc", sender: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        firstField.resignFirstResponder()
        return true
    }

}
