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
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
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
            
            if emailField.text!.isBlank {
                emailField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
            if passwordField.text!.isBlank {
                passwordField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
            if confirmPassword.text!.isBlank {
                confirmPassword.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
         
        } else {
            if passwordMatched {
                completeSignUp()
            }
        }
    }
    
    //
    func completeSignUp(){
        performSegueWithIdentifier("signup1", sender: nil)
    }
    
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let signUpUser = User(email: emailField.text!, uid: savedUID!)
        if let destViewController = segue.destinationViewController as? SignUpVC2 {
            //destViewController.newUser = signUpUser
            destViewController.newUser = UserDetails(email: emailField.text!, password: passwordField.text!)
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

                textField.attributedPlaceholder = NSAttributedString(string:"abc@xyz.com",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            }
        }
        
        if textField == passwordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(passwordField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"Atleast 6 characters",attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            }
        }
        
        
    }
    //
    func textFieldDidBeginEditing(textField: UITextField) {

        mismatchMessage.hidden = true
        
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if mismatchMessage.hidden == false {
            mismatchMessage.hidden = true
        }
        return true
    }
    //
    
}
