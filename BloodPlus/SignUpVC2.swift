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

class SignUpVC2 : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate{
    
    var newUser:User!
    
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    
    var imagePicker:UIImagePickerController! // to pick the image from mobile
    
    @IBOutlet weak var imagePressed: UIImageView!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    //
    var bloodType:String = "O+"
    //
    
    var pickerArray : [String] = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                //print("recieved object is \(newUser.uid) with email \(newUser.emailId)")
        bloodTypePicker.delegate = self
        bloodTypePicker.dataSource = self

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
        let pickerTitle = NSAttributedString(string: titleData, attributes: [ NSFontAttributeName:UIFont(name:"Georgia",size:20)!,NSForegroundColorAttributeName : UIColor.whiteColor()])
        return pickerTitle
        
    }
    //
    func imageTapped(){
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePressed.image = img
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    //
    @IBAction func signUpTapped(sender: RoundButton) {
        
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
                        }
                        
                    }
                    //
                    
                }
                //
        
            }
        }
        
        
        ////
        // alert controller
        let alertController = UIAlertController(title: "Sucess!Thank you for signing up :)" , message: "Welcome to Blood+ community.", preferredStyle: UIAlertControllerStyle.Alert)
        let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (_) -> Void in
            self.performSegueWithIdentifier("signup2", sender: self)
        }
        alertController.addAction(acceptAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        //segue
       // performSegueWithIdentifier("signup2", sender: self)
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
//        if (pickerArray[row] == ""){
//            bloodType = "O+"
//        }
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


}
