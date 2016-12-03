//
//  UserVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/2/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserVC: UIViewController , UITextFieldDelegate, ShowAlert, ShakeTextField,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let curUser = FIRAuth.auth()?.currentUser
    var userref = DataService.ds.REF_USERS

    var profileDetails:User!
    var isProfileEdit = false
    var isImageChanged = false
    var isEmailChanged = false
    var isPasswordChanged = false
    
    @IBOutlet weak var profilePic: RoundPic!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneFIeld: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var editButtonOutlet: RoundButton!

    
    var imagePicker:UIImagePickerController! // to pick the image from mobile
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBarController?.tabBar.items![2].image = UIImage(named: "iconTab2.png")
        RoundPic.roundPicture.roundPic(profilePic)
        //firstField.delegate = self
        //keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserVC.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        //delegates
        emailField.delegate = self
        passwordField.delegate = self
        addressField.delegate = self
        phoneFIeld.delegate = self
        
        //background taps
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(UserVC.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        //round buttons
        RoundPic.roundPicture.roundPic(profilePic)

        
        //image picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //image tap gestures
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self,action:#selector(profileTapped))
        profilePic.userInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer1)

        
        //disable edit on load
        emailField.userInteractionEnabled = false
        passwordField.userInteractionEnabled = false
        phoneFIeld.userInteractionEnabled = false
        addressField.userInteractionEnabled = false
        profilePic.userInteractionEnabled = false
        //
    
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: #selector(performSignOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //load all user profile details
        if let uid = curUser?.uid {
        
            userref.child((curUser?.uid)!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                //print("url is :\(snapshot.value)")
                //go through snap shot
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots{
                        
                        print("Snap key:\(snap.key) with Snap value\(snap.value)")
                        switch snap.key {
                        
                            case "email" :
                                self.emailField.text = snap.value as? String
                            case "phone" :
                                self.phoneFIeld.text = snap.value as? String
                            case "address" :
                                self.addressField.text = snap.value as? String
                            case "profilepic" :
                                //download image with url
                                //download pic
                                
                                let ref = FIRStorage.storage().referenceForURL(snap.value as! String)
                                ref.dataWithMaxSize(2*1024*1024, completion: {(data,error) in
                                    
                                    if error != nil{
                                        print("Firbase download error")
                                    }else {
                                        if let imgData = data {
                                            if let image = UIImage(data: imgData) {
                                                self.profilePic.image = image
                                            }
                                        }
                                    }
                                    
                                })//datawithmaxsize

                            default :
                                print("Default \(snap.value)")
                        }
                    }
                }
                //
                
            })//observe singleevent type
        }

    }
    
    // save and exit
    @IBAction func updatePressed(sender: AnyObject) {
        //enable user interaction
        if isProfileEdit == false {
            //dont save yet
            editButtonOutlet.titleLabel?.text = "Save"
            isProfileEdit = true
            emailField.userInteractionEnabled = true
            emailField.becomeFirstResponder()
            emailField.selectedTextRange = emailField.textRangeFromPosition(emailField.endOfDocument, toPosition: emailField.endOfDocument)
            passwordField.userInteractionEnabled = true
            phoneFIeld.userInteractionEnabled = true
            addressField.userInteractionEnabled = true
            
        }else {
        
            //save now
            let saveAlert = UIAlertController(title: "Save and exit?", message: "App needs to logout to save changes", preferredStyle: UIAlertControllerStyle.Alert)
            
            saveAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                //save to firebase here
                //phone and address
                self.userref.child("\(self.curUser!.uid)/phone").setValue(self.phoneFIeld.text)
                self.userref.child("\(self.curUser!.uid)/address").setValue(self.addressField.text)
                
                //image save to firebase
                if self.isImageChanged {
                    self.saveImageToFirebase()
                }
                
                //email and password
                let credential = FIREmailPasswordAuthProvider.credentialWithEmail(self.emailField.text!, password: self.passwordField.text!)
                
                self.curUser?.reauthenticateWithCredential(credential) { error in
                    if let error = error {
                        // An error happened.
                        print("error saving email :\(error.description)")
                        self.showAlert("Error saving email/password", message: "Please try again later")
                    } else {
                        // User re-authenticated.
                        print("email password change success")
                        self.performSegueWithIdentifier("uservc", sender: nil)
                    }
                }
                //
                print("save here")
            }))
            
            saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(saveAlert, animated: true, completion: nil)

        }
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
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //////
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        phoneFIeld.resignFirstResponder()
        addressField.resignFirstResponder()
     
    }
    //
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    //
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    //
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    ///////////tap gesture functions
    func profileTapped(){
        profilePic.userInteractionEnabled = true
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
        // 4
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        // 5
        optionMenu.addAction(mediaAction)
        optionMenu.addAction(backCameraAction)
        optionMenu.addAction(cancelAction)
        
        // 6
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }

    
    ////////// tap gesture functions
    
    ////image picker
    // finished choosing image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = img //set image locally
            isImageChanged = true
            profilePic.userInteractionEnabled = false//disable user intercation
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //image picking cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// image picker
    func saveImageToFirebase(){
        
        //MARK: upload images
        //
        // image upload
        if let img2 = profilePic.image {
            
            if let imageData = UIImageJPEGRepresentation(img2, 0.2){
                
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
                            
                            //change in database also
                            self.userref.child("\(self.curUser!.uid)/profilepic").setValue(url)
                            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                            print("now tableview will be reloaded")
                        }
                        
                    }
                    //
                    
                }
                //
                
            }
        }
        // image upload
    
    }
    //////
    //
    func performSignOut(){
        
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("uservc", sender: nil)
        
    }
}
