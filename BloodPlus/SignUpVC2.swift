//
//  SignUpVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class SignUpVC2 : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate ,
    ShowAlert,ShakeLabel, ShakeTextField , UIPopoverPresentationControllerDelegate {
    
    var newUser:UserDetails! // object to access user email, password
    
    var 😄 = "Smiley" //smiley to display success
    
    @IBOutlet weak var bloodTypePicker: UIPickerView! //to choose blood type
    
    var imagePicker:UIImagePickerController! // to pick the image from mobile
    
    // outlets
    @IBOutlet weak var imagePressed: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //
    var bloodType:String = "B+" // initial picker value
    //
    var signUpSuccess:Bool = false
    var pickerArray : [String] = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    
    var thisVC :UIViewController!
    
    var isPopOverPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         thisVC = self.presentingViewController
    
        //picker view customization and delegates
        bloodTypePicker.delegate = self
        bloodTypePicker.dataSource = self
        bloodTypePicker.selectRow(4, inComponent: 0, animated: true)
        bloodTypePicker.layer.borderWidth = 3
        bloodTypePicker.layer.cornerRadius = 10
        bloodTypePicker.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).CGColor
        
        //text field delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneField.delegate = self
        addressField.delegate = self
        
        //image tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        imagePressed.userInteractionEnabled = true
        imagePressed.addGestureRecognizer(tapGestureRecognizer)
        RoundPic.roundPicture.roundPic(imagePressed)
        
        //image picker delegate
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //tap gesture for background tap
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(SignUpVC1.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        //adjusting view for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC2.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC2.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
     
    }
    
    //remove observers
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //remove lines in picker view
        pickerView.subviews.forEach({
            $0.hidden = $0.frame.height == 0.5
        })
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    //title for each picker view row
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = pickerArray[row]
        let pickerTitle = NSAttributedString(string: titleData, attributes: [ NSFontAttributeName:UIFont(name:"Georgia",size:20)!,NSForegroundColorAttributeName : UIColor.redColor()])
        return pickerTitle
        
    }
    
    //
    func imageTapped(){
        //allow users to choose
        
        // create view controller
        let optionMenu = UIAlertController(title: "", message: "Choose image method", preferredStyle: .ActionSheet)
        

        // pick from phone
        let mediaAction = UIAlertAction(title: "Choose from device", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            //
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })

        
        // take pic
        let backCameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            //
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                    self.imagePicker.sourceType = .Camera
                    self.imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(self.imagePicker, animated: true, completion: {})
                } else {
                    let alert = UIAlertController(title: "No rear camera", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "No camera available", message: "Check your app settings for camera", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            //
        })
        // cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        // add actions to sheet
        optionMenu.addAction(mediaAction)
        optionMenu.addAction(backCameraAction)
        optionMenu.addAction(cancelAction)
        
        // present the alert
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // finished choosing image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePressed.image = img
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)

    }
    //dismiss if cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //sign up button
    @IBAction func signUpTapped(sender: RoundButton) {
        
        print("signup tapped")
        
        // handle all blank case
        if firstNameField.text!.isBlank {
            addAnimationToTextField(firstNameField)
        }
        if lastNameField.text!.isBlank{
            addAnimationToTextField(lastNameField)
        }
        if phoneField.text!.isBlank {
            addAnimationToTextField(phoneField)
        }
        if addressField.text!.isBlank {
            addAnimationToTextField(addressField)
        }
        
        
        //no fields must be empty
        if firstNameField.text!.isBlank == false && lastNameField.text!.isBlank == false
            && phoneField.text!.isBlank == false && addressField.text!.isBlank == false {
            
                //create user email in firebase
                FIRAuth.auth()?.signInWithEmail(newUser.email , password: newUser.password, completion: {(user,error) in
                    
                    if error == nil {
                        
                        print ("user exists ")
                        
                        self.showAlert("User already exists", message: "Please enter different username/password")
                        
                        
                    }else{
                        //create new user with recieved details from previous screen
                        FIRAuth.auth()?.createUserWithEmail(self.newUser.email, password: self.newUser.password,completion: {(user,error) in
                            
                            if error != nil {
                                
                                print("cannot sign in")
                               // self.showAlert("Account creation error", message: "Please try again")
                                self.showAlert("Email/Password already exists", message: "Please enter different username/password")
                                
                            } else{
                                //self.savedUID =  user?.uid
                                print("user created and authenticated")
                                self.signUpSuccess = true
                             
                                if let fireUser = user {
                                    //save user id
                                    self.newUser.uid = fireUser.uid
                                }
                                //MARK: upload images
                                //
                                // image upload
                                if let img = self.imagePressed.image {
                                    
                                    if let imageData = UIImageJPEGRepresentation(img, 0.2){
                                        
                                        let imageUid = NSUUID().UUIDString
                                        let metadata = FIRStorageMetadata()
                                        metadata.contentType = "image/jpeg"
                                        
                                        //store image in Firebase storage
                                        DataService.ds.REF_USER_IMAGES.child(imageUid).putData(imageData, metadata: metadata){
                                            (metadata,error) in
                                            
                                            //
                                            if error != nil{
                                                print("ImageErr: Unable to upload image - \(error.debugDescription)")
                                            }else{
                                                print("ImageSuccess: Successfully uploaded to firbase")
                                                
                                                let downloadUrl = metadata?.downloadURL()?.absoluteString
                                                
                                                if let url = downloadUrl{
                                                        self.signUpSuccess = true
                                                    
                                                    //post data to firebase
                                                    self.postToFirebase(url, success: true)

                                                    
                                                }
                                                
                                            }
                                            //
                                            
                                        }
                                        //
                                        
                                    }
                                }
                                // image upload
                                //
                            }
                            
                        })
                        
                    }
                    
                })
        //completion of firebase authentication
        }
        
    }
    //
    // posting to firebase
    func postToFirebase(imgUrl:String,success: Bool)  {
        
        //dictionary keys match the firebase keys
        let userToAdd = [
         
            "address": addressField.text! as String,
            "bloodtype":bloodType,
            "email":newUser.email,
            "firstname":firstNameField.text! as String,
            "lastname":lastNameField.text! as String,
            "phone":phoneField.text! as String,
            "profilepic": imgUrl as String,
            
            ] as [String : AnyObject]
        
        
        // auto id created by firebase
        //let firebasePost = DataService.ds.REF_USERS.childByAutoId()
        
        //post with userid
        DataService.ds.REF_USERS.child(self.newUser.uid).setValue(userToAdd)
      
        //create alert
        print("success status : \(success)")
        if success  {
            //user has entered valid fields, complete sign up
   
            // alert controller for successfully signing up
            print("Success Alert!")
            let alertController = UIAlertController(title: "Sucess!Thank you for signing up 😄", message: "Welcome to Blood+ community.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            print("After success alert")
            
        }
    }
    
    // selected row in picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBloodType = pickerArray[row]
        bloodType = selectedBloodType
    }
    
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.phoneField.resignFirstResponder()
        self.addressField.resignFirstResponder()
        if isPopOverPresent {
            popoverPresentationController?.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
            isPopOverPresent = false
        }

        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.phoneField.resignFirstResponder()
        self.addressField.resignFirstResponder()
        if isPopOverPresent {
        popoverPresentationController?.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
            isPopOverPresent = false

        }

    }
    
    //text delegate checks
    func textFieldDidEndEditing(textField: UITextField) {

        //popover presentation controller to show error
        let popupController = storyboard?.instantiateViewControllerWithIdentifier("myPopUp") as! MessagePopUpViewCOntroller
        popupController.modalPresentationStyle = .Popover
        popupController.preferredContentSize = CGSizeMake(textField.frame.width * 0.75 ,textField.frame.height * 0.75)
        
        if let popoverController = popupController.popoverPresentationController {
            popoverController.sourceView = textField as UIView
            popoverController.sourceRect = textField.bounds
            popoverController.preferredContentSize
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self

        }
        // empty field
        if textField.text!.isBlank {
            addAnimationToTextField(textField)
            textField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        
        //phone field 10 numbers
        if textField == phoneField {
            if textField.text!.characters.count != 10 {
                addAnimationToTextField(textField)
                textField.text = ""
            textField.attributedPlaceholder = NSAttributedString(string:"10 numbers only",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
    }

    //start editing
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }
        //popover
        let popupController = storyboard?.instantiateViewControllerWithIdentifier("myPopUp") as! MessagePopUpViewCOntroller
        popupController.modalPresentationStyle = .Popover
        popupController.preferredContentSize = CGSizeMake(textField.frame.width  ,textField.frame.height )
        if let popoverController = popupController.popoverPresentationController {
            popoverController.sourceView = textField as UIView
            popoverController.sourceRect = textField.bounds
            popoverController.preferredContentSize
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            
        }
        
        
        //fname and lname
        if textField == firstNameField || textField == lastNameField {
            let alphaSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ")
            if (string.rangeOfCharacterFromSet(alphaSet) != nil) {
                if isPopOverPresent {
                //    dismissViewControllerAnimated(true, completion: nil)
                    isPopOverPresent = false
                }
                return true
            }else {
                popupController.message = "Letters and whitespace only"
                presentViewController(popupController, animated: true, completion: nil)
                
                delayPopUpDismiss()
                isPopOverPresent = true
                return false
            }
        }
        //phone
        if textField == phoneField {
            let numSet = NSCharacterSet(charactersInString: "0123456789")
            if (string.rangeOfCharacterFromSet(numSet) != nil) && textField.text!.characters.count < 10 {
                if isPopOverPresent {
                //   dismissViewControllerAnimated(true, completion: nil)
                    isPopOverPresent = false
                }
                return true
            }else {
                popupController.message = "Numbers only"
                presentViewController(popupController, animated: true, completion: nil)
                delayPopUpDismiss()
                isPopOverPresent = true
                return false
            }
        }

        
        //address
        if textField == addressField {
            let addrSet = NSCharacterSet(charactersInString: "0123456789ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ,-.\"").invertedSet
            if (string.rangeOfCharacterFromSet(addrSet) != nil){
                popupController.message = "Letters and numbers only"
                presentViewController(popupController, animated: true, completion: nil)
                delayPopUpDismiss()
                isPopOverPresent = true
                return false
            }else {
                if isPopOverPresent {
                    //   dismissViewControllerAnimated(true, completion: nil)
                    isPopOverPresent = false
                }
                return true
            }
        
        }
        return true
    }
    
    //assign placeholders back
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField == firstNameField {
            textField.attributedPlaceholder = NSAttributedString(string:"First Name",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == lastNameField {
            textField.attributedPlaceholder = NSAttributedString(string:"Last Name",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == phoneField {
            textField.attributedPlaceholder = NSAttributedString(string:"Phone Number",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        if textField == addressField {
            textField.attributedPlaceholder = NSAttributedString(string:"Address",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
    }
    
    //show keyboard after adjusting view height
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    //hide keyboard
    func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    //
    //popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //assign a 0.75 sec delay before dismissing popover view controller
    func delayPopUpDismiss(){
        let delay = 0.75 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
