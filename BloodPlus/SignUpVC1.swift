//
//  SignUpVC1.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpVC1 : UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var signUpSuccess:Bool = false
    var savedUID :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // FIRApp.configure()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //tap gesture
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(SignUpVC1.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @IBAction func nextBtnPressed(sender: RoundButton) {
        
        
        if let userName = emailField.text ,let password = passwordField.text{
            
            FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                
                if error == nil {
                    
                    print ("user exists ")
                    let alertController = UIAlertController(title: "User already exists!", message: "Please give different email/password", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)

                    
                }
                    
                else{
                    
                    FIRAuth.auth()?.createUserWithEmail(userName, password: password,completion: {(user,error) in
                        
                        if error != nil {
                            
                            print("cannot sign in")
                            let alertController = UIAlertController(title: "Account creation error!", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)

                            
                        }
                            
                        else{
                            self.savedUID =  user?.uid
                            print("user created and authenticated")
                            self.signUpSuccess = true
                            self.completeSignUp()
                        }
                        
                    })
                    
                }
                
            })
            
            
            
        }
        


        
    }
    
    //
    func completeSignUp(){
        performSegueWithIdentifier("signup1", sender: nil)
    }
    
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let signUpUser = User(email: emailField.text!, uid: savedUID!)
        if let destViewController = segue.destinationViewController as? SignUpVC2 {
            destViewController.newUser = signUpUser
        }
    }
    //
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }

}
