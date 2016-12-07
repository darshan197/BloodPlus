//
//  CredentialsVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/3/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CredentialsVC:UIViewController , UITextFieldDelegate, ShowAlert, ShakeTextField {

    let curUser = FIRAuth.auth()?.currentUser
    var userref = DataService.ds.REF_USERS
    
    //outlets
    @IBOutlet weak var newEmailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var newConfirmPasswordField: UITextField!
    @IBOutlet weak var presentEmailLabel: UILabel!
    
    var presentEmail:String!
    var presentPassword:String!
    
    var passwordConfirmed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //text delegates
        newEmailField.delegate = self
        newPasswordField.delegate = self
        newConfirmPasswordField.delegate = self
        
        navigationController?.navigationItem.title = "Update email/password"
        
        //current user email
        presentEmailLabel.text = "Current Email id: "+(curUser?.email)!
        
        //
        
    }
    
    // update credentials
    @IBAction func updatePressed(sender: AnyObject) {
        print("update pressed")
        if newEmailField.text!.isBlank  {
        
            if newEmailField.text!.isBlank {
                addAnimationToTextField(newEmailField)
            }

        }
       

        //check for empty fields
        if newEmailField.text!.isBlank == false  {
        
            
                //save now
                let saveAlert = UIAlertController(title: "Save and exit?", message: "App needs to logout to save changes", preferredStyle: UIAlertControllerStyle.Alert)
                
                saveAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
    
                    self.performUpdate() //change password
                    //
                    print("save here")
                }))
                
                saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                presentViewController(saveAlert, animated: true, completion: nil)
            
            
            
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == newEmailField {
            if textField.text!.isBlank || textField.text!.isEmail == false {
                textField.text = ""
                self.addAnimationToTextField(newEmailField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"abc@xyz.com",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
        
        if textField == newPasswordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(newPasswordField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"Atleast 6 characters",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
        
        if textField == newConfirmPasswordField {
            if textField.text!.isBlank || textField.text!.characters.count < 6 {
                textField.text = ""
                self.addAnimationToTextField(newConfirmPasswordField)
                
                textField.attributedPlaceholder = NSAttributedString(string:"Atleast 6 characters",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == newEmailField {
            textField.attributedPlaceholder = NSAttributedString(string:"New Email",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == newPasswordField {
            textField.attributedPlaceholder = NSAttributedString(string:"New Password",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == newConfirmPasswordField {
            textField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    ///// background tap
    func backgroundTapped()  {
        newEmailField.resignFirstResponder()
        newPasswordField.resignFirstResponder()
        newConfirmPasswordField.resignFirstResponder()
    }
    
    // do firebase update
    func performUpdate(){
        print("perform update called")
        
        //// email
        self.curUser?.updateEmail(newEmailField.text!, completion: {(error) in
            if error == nil {
                print("email changed")
                self.userref.child("\(self.curUser!.uid)/email").setValue(self.newEmailField?.text!)
                try! FIRAuth.auth()?.signOut()
                self.performSegueWithIdentifier("credential", sender: nil)
            }else {
                self.showAlert("Email change error", message: "Its been a while since you logged in,please relogin to change email")
            }
        })
        ////
    }
    
    
    //password action
    @IBAction func updatePass(sender: AnyObject) {
        
        if  newPasswordField.text!.isBlank || newConfirmPasswordField.text!.isBlank {
            
            if newPasswordField.text!.isBlank{
                addAnimationToTextField(newPasswordField)
            }
            if newConfirmPasswordField.text!.isBlank {
                addAnimationToTextField(newConfirmPasswordField)
            }
        }
        ///
        //check password matching
        if newPasswordField.text!.isBlank == false && newConfirmPasswordField.text?.isBlank == false  {
            if newPasswordField.text != newConfirmPasswordField.text {
                passwordConfirmed = false
                newConfirmPasswordField.text = ""
                addAnimationToTextField(newConfirmPasswordField)
                
                newConfirmPasswordField.attributedPlaceholder = NSAttributedString(string:"Password Mismatch",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }else{
                passwordConfirmed = true
            }
        }
        ///
        //check for empty fields
        if newPasswordField.text!.isBlank == false && newConfirmPasswordField.text!.isBlank == false {
            
            if passwordConfirmed {
            //save now
            let saveAlert = UIAlertController(title: "Save and exit?", message: "App needs to logout to save changes", preferredStyle: UIAlertControllerStyle.Alert)
            
            saveAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.updateFirebasePassword()//change password
                //
                print("save here")
            }))
            
            saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(saveAlert, animated: true, completion: nil)
                
          }
       
        }
        
    }
    
    
    
    //perform password update
    func updateFirebasePassword() {
        ////passowrd
        self.curUser?.updatePassword(newPasswordField.text!, completion: {(error) in
        
            if error == nil {
                print("password changed")
                try! FIRAuth.auth()?.signOut()
                self.performSegueWithIdentifier("credential", sender: nil)
            }else {
                print("Passerror: "+error.debugDescription)
                self.showAlert("Password change error", message: "Its been a while since you logged in,please relogin to change password")
                
            }
            
        })
    
        ////
    }
}
