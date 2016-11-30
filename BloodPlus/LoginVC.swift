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
        
        
        //monitor log in status, if user already logged in take to home page
        FIRAuth.auth()?.addAuthStateDidChangeListener({(auth,user) in
            if user != nil {
                self.performSegueWithIdentifier("login1", sender: nil)
            }
        })
    }



    @IBAction func loginBtnPressed(sender: RoundButton) {
        
        if let userName = userNameField.text ,let password = passwordField.text{
            
            if userName.isBlank || userName.isEmail == false  {
                let alertController = UIAlertController(title: "Invalid Email!", message: "Please enter email in the form of abc@xyz.com", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Re-Enter", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            if password.isBlank || password.characters.count < 6  {
                let alertController = UIAlertController(title: "Invalid Password!", message: "Please enter atlease 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Re-Enter", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            FIRAuth.auth()?.signInWithEmail(userName, password: password, completion: {(user,error) in
                
                if error == nil {
                    
                    print ("user exists and successfully logged in")
                    self.completeSignIn()

                
                }
                    
                else{
                    print("No user found")
                    let alertController = UIAlertController(title: "No account exists!", message: "Please sign up!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                

                }
                
            })       
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
    
    func completeSignIn(){
        performSegueWithIdentifier("login1", sender: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }

}
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
