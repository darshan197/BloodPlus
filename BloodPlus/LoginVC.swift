//
//  ViewController.swift
//  BloodPlus
//
//  Created by Darshan Hosakote  on 11/23/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController, UITextFieldDelegate , ShowAlert ,ShakeTextField {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //back button color
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //text field delegates
        userNameField.delegate = self
        passwordField.delegate = self
        
        //tap gesture for background tap
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(LoginVC.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
    }

    @IBAction func loginBtnPressed(sender: RoundButton) {
        print("login called")
        
                //login press
                if let userName = self.userNameField.text ,let password = self.passwordField.text{
                    
                    //add animation to empty yext fields
                    if self.userNameField.text!.isEmpty  {
                       
                        self.addAnimationToTextField(self.userNameField)
                        self.userNameField.attributedPlaceholder = NSAttributedString(string:"Empty Field",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                        
                    }
                    if self.passwordField.text!.isEmpty {
                        self.addAnimationToTextField(self.passwordField)
                        
                        self.passwordField.attributedPlaceholder = NSAttributedString(string:"Empty Field",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                    }
                    //sign in with firebase
                    FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                        
                        if error == nil {
                            
                            print ("user exists and successfully logged in")
                            self.completeSignIn()
                        }
                            
                        else{
                            print("No user found")
                            //let user know that account doesnt exisy
                            if self.userNameField.text!.isEmpty == false
                                && self.passwordField.text!.isEmpty == false {
                                
                                self.showAlert("No account exists", message: "Please sign up")
                                
                                //clear both fields
                                self.userNameField.text = ""
                                self.passwordField.text = ""
                            }
                      
                        }
                        
                    })       
                }
                //login

    }
    
    
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //resign text responsders
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        return true
    }

    ///// background tap
    func backgroundTapped()  {
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
    //
    @IBAction func signUpBtnPressed(sender: RoundButton) {
        performSegueWithIdentifier("signup", sender:self)
    }
    
    func completeSignIn(){
       performSegueWithIdentifier("login1", sender: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    //reset
    @IBAction func resetPassword(sender: AnyObject) {
        
        if userNameField.text!.isBlank  {
            //empty field, cannot reset
            self.showAlert("Email field empty", message: "Please fill the email for password reset")
            
        } else {
            
            if let email = userNameField.text {
                //call firebase method to reset
                FIRAuth.auth()?.sendPasswordResetWithEmail(email, completion: {(error) in
                    if error != nil {
                        print("error resetting")
                        
                        self.showAlert("Error Resetting password", message: "")
                        
                    } else {
                        print("success to reset")
                        
                        self.showAlert("Link to reset password sent to your mail inbox", message: "")
                        
                    }
                })
            }
            //
        }
    }
    
    //email and password check
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == userNameField {
            if textField.text!.isBlank || textField.text!.isEmail == false {
                textField.text = ""
                self.addAnimationToTextField(userNameField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"abc@xyz.com",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
        
        if textField == passwordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(passwordField)
                
        textField.attributedPlaceholder = NSAttributedString(string:"Atleast 6 characters",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }

    }
    // set placeholders back when editing begins
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == userNameField {
            textField.attributedPlaceholder = NSAttributedString(string:"Email Id",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == passwordField {
            textField.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
    }
    //
}



//string extensions for validations
extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = self.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  self == filtered
        
    }
}
