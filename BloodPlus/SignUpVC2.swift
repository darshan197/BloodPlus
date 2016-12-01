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
    
    var newUser:User!
    
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    
    var imagePicker:UIImagePickerController! // to pick the image from mobile
    
    @IBOutlet weak var imagePressed: UIImageView!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //
    var bloodType:String = "B+"
    //
    var signUpSuccess:Bool = false
    var pickerArray : [String] = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                //print("recieved object is \(newUser.uid) with email \(newUser.emailId)")
        bloodTypePicker.delegate = self
        bloodTypePicker.dataSource = self
        bloodTypePicker.selectRow(4, inComponent: 0, animated: true)
        bloodTypePicker.layer.borderWidth = 3
        bloodTypePicker.layer.cornerRadius = 10
        bloodTypePicker.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).CGColor
        //text delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneField.delegate = self
        addressField.delegate = self
        
        //image tap
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        imagePressed.userInteractionEnabled = true
        imagePressed.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //tap gesture
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(SignUpVC1.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        //keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC2.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC2.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = pickerArray[row]
        let pickerTitle = NSAttributedString(string: titleData, attributes: [ NSFontAttributeName:UIFont(name:"Georgia",size:20)!,NSForegroundColorAttributeName : UIColor.redColor()])
        return pickerTitle
        
    }
    //
    func imageTapped(){
        //allow users to choose
        
        // 1
        let optionMenu = UIAlertController(title: "", message: "Choose image method", preferredStyle: .ActionSheet)
        
        // 2
        let mediaAction = UIAlertAction(title: "Choose from device", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            //
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })

        
        //
        let backCameraAction = UIAlertAction(title: "Back camera", style: .Default, handler: {
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
        // 4
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        // 5
        optionMenu.addAction(mediaAction)
        optionMenu.addAction(backCameraAction)
        optionMenu.addAction(cancelAction)
        
        // 6
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // finished choosing image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePressed.image = img
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)

    }
    //imaeg picking cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    @IBAction func signUpTapped(sender: RoundButton) {
        

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
        
        //check for empty fields
        if firstNameField.text!.isBlank == false && lastNameField.text!.isBlank == false
            && phoneField.text!.isBlank == false && addressField.text!.isBlank == false {
            //
            if let img = imagePressed.image {
                
                if let imageData = UIImageJPEGRepresentation(img, 0.2){
                    
                    let imageUid = NSUUID().UUIDString
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    DataService.ds.REF_USER_IMAGES.child(imageUid).putData(imageData, metadata: metadata){
                        (metadata,error) in
                        
                        //
                        if error != nil{
                            print("ImageErr: Unable to upload image - \(error.debugDescription)")
                        }else{
                            print("ImageSuccess: Successfully uploaded to firbase")
                            let downloadUrl = metadata?.downloadURL()?.absoluteString
                            
                            if let url = downloadUrl{
                                self.postToFirebase(url)
                                self.signUpSuccess = true
                            }
                            
                        }
                        //
                        
                    }
                    //
                    
                }
            }
            //
        }
        
        if signUpSuccess{
            //user has entered valid fields, complete sign up
            // alert controller for successfully signing up
            let alertController = UIAlertController(title: "Sucess!Thank you for signing up :)" , message: "Welcome to Blood+ community.", preferredStyle: UIAlertControllerStyle.Alert)
            let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (_) -> Void in
                self.performSegueWithIdentifier("signup2", sender: self)
            }
            alertController.addAction(acceptAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    //
    // posting to firebase
    func postToFirebase(imgUrl:String)  {
        //dictionary keys need to match the firebase keys
        let userToAdd = [
            
            "address": addressField.text! as String,
            "bloodtype":bloodType,
            "email":newUser.emailId,
            "firstname":firstNameField.text! as String,
            "lastname":lastNameField.text! as String,
            "phone":phoneField.text! as String,
            "profilepic": imgUrl as String,
            ] as [String : AnyObject]
        
        let firebasePost = DataService.ds.REF_USERS.childByAutoId()
        firebasePost.setValue(userToAdd)
        
               //
    }
    //
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
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.phoneField.resignFirstResponder()
        self.addressField.resignFirstResponder()

    }
    
    //text delegate checks
    func textFieldDidEndEditing(textField: UITextField) {

        //pop
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
            if textField.text!.isBlank {
                addAnimationToTextField(textField)
                popupController.message = "Empty Field"
                presentViewController(popupController, animated: true, completion: nil)
            }
        if textField == phoneField {
            if textField.text!.characters.count != 10 {
                addAnimationToTextField(textField)
                textField.text = ""
                popupController.message = "Enter 10 digits"
                presentViewController(popupController, animated: true, completion: nil)
            }
        }
    }

    //start editing
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //fname and lname
        if textField == firstNameField || textField == lastNameField {
            let alphaSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ")
            if (string.rangeOfCharacterFromSet(alphaSet) != nil) {
                return true
            }else {
                return false
            }
        }
        //phone
        if textField == phoneField {
            let numSet = NSCharacterSet(charactersInString: "0123456789")
            if (string.rangeOfCharacterFromSet(numSet) != nil) && textField.text!.characters.count < 10 {
                return true
            }else {
                return false
            }
        }

        
        //addr
        if textField == addressField {
            let addrSet = NSCharacterSet(charactersInString: "0123456789ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ,-.\"")
            if (string.rangeOfCharacterFromSet(addrSet) != nil){
                return true
            }else {
                return false
            }
        
        }
        return true
    }
    
    //keyboard hide
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    //
    //popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    
    
}
