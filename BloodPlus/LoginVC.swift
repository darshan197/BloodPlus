//
//  ViewController.swift
//  BloodPlus
//
//  Created by Darshan Hosakote  on 11/23/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func loginButtonTapped(sender: AnyObject) {
        if let userName = userNameField.text ,let password = passwordField.text{
            FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                if error == nil {
                    print ("user exists and successfully logged in")
                }
                else{
                    FIRAuth.auth()?.createUserWithEmail(userName, password: password,completion: {(user,error) in
                        if error != nil {
                            print("cannot sign in")
                        }
                        else{
                            print("user created and authenticated")
                        }
                    })
                }
            })
            
        }
    }


}

