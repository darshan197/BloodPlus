//
//  ViewController.swift
//  BloodPlus
//
//  Created by Darshan Hosakote  on 11/23/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userNameField.delegate = self
        passwordField.delegate = self
        
       // FIRApp.configure()
        
        //tap gesture
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(LoginVC.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }


<<<<<<< HEAD
    @IBAction func loginBtnPressed(sender: RoundButton) {
        
        if let userName = userNameField.text ,let password = passwordField.text{
            
            FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                
                if error == nil {
                    
                    print ("user exists and successfully logged in")
                
                }
                    
                else{
                    print("No user found")
                    let alertController = UIAlertController(title: "No account exists!", message: "Please sign up!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
=======
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
>>>>>>> origin/master

                }
                
            })       
        }
        
    }
    
    // perform segue if login credentials are correct
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "login1" {
            return true
        }else{
            return false
        }
    }
    
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        return true
    }

    
    //


    ///// background tap
    func backgroundTapped()  {
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
    //
    @IBAction func signUpBtnPressed(sender: RoundButton) {
        performSegueWithIdentifier("signup", sender:self)
    }
    

}

