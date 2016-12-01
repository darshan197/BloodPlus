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
    @IBOutlet weak var mismatchMessage: UILabel!
    
    var signUpSuccess:Bool = false
    var passwordMatched:Bool = false
    var savedUID :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmPassword.delegate = self
        mismatchMessage.hidden = true
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
                confirmPassword.text = ""
                addAnimationToTextField(confirmPassword)
                mismatchMessage.text = "Passwords do not match"
                mismatchMessage.hidden = false
                addAnimationToLabelField(mismatchMessage)
                passwordMatched = false

            } else {
                mismatchMessage.hidden = true
                passwordMatched = true
            }
        }
        
        if emailField.text!.isBlank || passwordField.text!.isBlank || confirmPassword.text!.isBlank{
            
            emailField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            passwordField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            confirmPassword.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            
            
            
        } else {
            if passwordMatched {
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

                textField.attributedPlaceholder = NSAttributedString(string:"Email format : abc@xyz.com",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            }
        }
        
        if textField == passwordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(passwordField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"Password: Atleast 6 characters",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            }
        }
        
        
    }
    //
    func textFieldDidBeginEditing(textField: UITextField) {

        
        if textField == emailField {
            textField.attributedPlaceholder = NSAttributedString(string:"Email Id",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == passwordField {
            textField.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == confirmPassword {
            textField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }

    }
    //
}
