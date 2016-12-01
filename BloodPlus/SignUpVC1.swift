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

class SignUpVC1 : UIViewController , UITextFieldDelegate , ShowAlert , ShakeTextField , ShakeLabel{
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet weak var emailFormatMessage: UILabel!
    
    @IBOutlet weak var passwordFormatMessage: UILabel!
    
    @IBOutlet weak var mismatchMessage: UILabel!
    
    var signUpSuccess:Bool = false
    var savedUID :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMessage.hidden = true
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmPassword.delegate = self
        
        //tap gesture
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(SignUpVC1.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @IBAction func nextBtnPressed(sender: RoundButton) {
        
        if emailField.text!.isBlank {
            addAnimationToTextField(emailField)
        }
        if passwordField.text!.isBlank {
            addAnimationToTextField(passwordField)
        }
        if confirmPassword.text!.isBlank{
            addAnimationToTextField(confirmPassword)
        }
        if passwordField.text!.isBlank == false && confirmPassword.text?.isBlank == false  {
            if passwordField.text != confirmPassword.text {
                addAnimationToTextField(confirmPassword)
                mismatchMessage.text = "Passwords do not match"
                mismatchMessage.hidden = false
                addAnimationToLabelField(mismatchMessage)
                
            }
        }
        
        if emailField.text!.isBlank || passwordField.text!.isBlank || confirmPassword.text!.isBlank{
            userMessage.text = "Please fill all fields"
            userMessage.hidden = false
            addAnimationToLabelField(userMessage)
        } else {
        //
        if let userName = emailField.text ,let password = passwordField.text{
            
            
            FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                
                if error == nil {
                    
                    print ("user exists ")
                    
                    self.showAlert("User already exists", message: "Please enter different username/password")

                    
                }
                    
                else{
                    
                    FIRAuth.auth()?.createUserWithEmail(userName, password: password,completion: {(user,error) in
                        
                        if error != nil {
                            
                            print("cannot sign in")
                            self.showAlert("Account creation error", message: "Please try again")

                        } else{
                            self.savedUID =  user?.uid
                            print("user created and authenticated")
                            self.signUpSuccess = true
                            self.completeSignUp()
                        }
                        
                    })
                    
                }
                
            })
            
            
            
        }
        //
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
        self.confirmPassword.resignFirstResponder()
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.confirmPassword.resignFirstResponder()
    }
    
    //email and password checks
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == emailField {
            if textField.text!.isBlank || textField.text!.isEmail == false {
                textField.text = ""
                self.addAnimationToTextField(emailField)
                self.addAnimationToLabelField(emailFormatMessage)
            }
        }
        
        if textField == passwordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(passwordField)
                self.addAnimationToLabelField(passwordFormatMessage)
            }
        }
        
        
    }
    //
    func textFieldDidBeginEditing(textField: UITextField) {
        userMessage.hidden = true
    }
    //
}
