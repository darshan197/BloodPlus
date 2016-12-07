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

class UserVC: UIViewController , UITextFieldDelegate, ShowAlert, ShakeTextField,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {

    //firebase reference and currently signed in user
    let curUser = FIRAuth.auth()?.currentUser
    var userref = DataService.ds.REF_USERS

    var profileDetails:User!
    
    //bools to check edit
    var isProfileEdit = false
    var isImageChanged = false
    var isEmailChanged = false
    var isPasswordChanged = false
    var isImagePressed = false
    var newImage:UIImage!
    //label outlets
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var profilePic: RoundPic!
    @IBOutlet weak var phoneFIeld: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    //button outlet
    @IBOutlet weak var editButtonOutlet: RoundButton!

    
    var imagePicker:UIImagePickerController! // to pick the image from mobile
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
       // self.tabBarController?.tabBar.items![2].image = UIImage(named: "iconTab2.png")
        RoundPic.roundPicture.roundPic(profilePic)

        
        //delegates
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

        //update password gesture
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self,action:#selector(updateLabelTapped))
        updateLabel.userInteractionEnabled = true
        updateLabel.addGestureRecognizer(tapGestureRecognizer2)
        
        //disable edit on load
        phoneFIeld.userInteractionEnabled = false
        addressField.userInteractionEnabled = false
        
        //sign out button
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: #selector(performSignOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //load all user profile details
        if let uid = curUser?.uid {
        
            //firebase observer to get user datas
            userref.child((curUser?.uid)!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                //print("url is :\(snapshot.value)")
                //go through snap shot
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots{
                        
                        print("Snap key:\(snap.key) with Snap value\(snap.value)")
                        switch snap.key {
                        
                            case "phone" :
                                self.phoneFIeld.text = snap.value as? String
                            case "address" :
                                self.addressField.text = snap.value as? String
                            case "profilepic" :
                                //download image with url
                                let ref = FIRStorage.storage().referenceForURL(snap.value as! String)
                                ref.dataWithMaxSize(2*1024*1024, completion: {(data,error) in
                                    print("profile pic - \(snap.value)")
                                    if error != nil{
                                        print("Firbase download error")
                                    }else {
                                        if let imgData = data {
                                            if let image = UIImage(data: imgData) {
                                                self.profilePic.image = image
                                                self.newImage = image//save downloaded image
                                                print("image downloaded")
                                            }
                                        }
                                    }
                                    
                                })//datawithmaxsize

                            default :
                                print("Default \(snap.value)")
                        }
                    }
                }
                
            })//observe singleevent type
        }

    }
    
    // save and exit
    @IBAction func updatePressed(sender: AnyObject) {
        //enable user interaction
        if isProfileEdit == false && isImagePressed == false {
            //dont save yet
            sender.setTitle("Save", forState: .Normal)//button title
            isProfileEdit = true
            isImagePressed = true
            //move cursor to end of phone field
            phoneFIeld.userInteractionEnabled = true
            phoneFIeld.becomeFirstResponder()
            phoneFIeld.selectedTextRange = phoneFIeld.textRangeFromPosition(phoneFIeld.endOfDocument, toPosition: phoneFIeld.endOfDocument)
            addressField.userInteractionEnabled = true
            
        }else {
        
            //save now
            let saveAlert = UIAlertController(title: "Save and exit?", message: "App needs to logout to save changes", preferredStyle: UIAlertControllerStyle.Alert)
            
            saveAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                //save to firebase
                //phone and address
                self.userref.child("\(self.curUser!.uid)/phone").setValue(self.phoneFIeld.text)
                self.userref.child("\(self.curUser!.uid)/address").setValue(self.addressField.text)
                
                //image save to firebase
                if self.isImagePressed {
                     self.saveImageToFirebase()
                }
               
             
                //signout and go to home page
                try! FIRAuth.auth()?.signOut()
                self.performSegueWithIdentifier("uservc", sender: nil)
                print("save here")
            }))
            
            saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(saveAlert, animated: true, completion: nil)

        }
    }
    

    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //////
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
   
        phoneFIeld.resignFirstResponder()
        addressField.resignFirstResponder()
    }
    
    // check field after edit
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text!.isBlank {
            addAnimationToTextField(textField)
            textField.attributedPlaceholder = NSAttributedString(string:"Please fill all fields",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == phoneFIeld {
            if textField.text!.characters.count != 10 {
                addAnimationToTextField(textField)
                textField.text = ""
                textField.attributedPlaceholder = NSAttributedString(string:"10 numbers only",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            }
        }
      
    }
    
    // set placeholders
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == phoneFIeld {
            textField.attributedPlaceholder = NSAttributedString(string:"Phone Numbers",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        
        if textField == addressField {
            textField.attributedPlaceholder = NSAttributedString(string:"Address",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
    }
    
    // block unnecessary characters
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        ///////
        let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }
        //popover
        let popupController = storyboard?.instantiateViewControllerWithIdentifier("myPopUp") as! MessagePopUpViewCOntroller
        popupController.modalPresentationStyle = .Popover
        popupController.preferredContentSize = CGSizeMake(textField.frame.size.width  ,textField.frame.size.height )
        if let popoverController = popupController.popoverPresentationController {
            popoverController.sourceView = textField as UIView
            popoverController.sourceRect = textField.bounds
            popoverController.preferredContentSize
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverController.sourceRect = CGRectMake(0, 0, textField.frame.size.width, textField.frame.size.height)
        }
        
        

        //phone
        if textField == phoneFIeld {
            let numSet = NSCharacterSet(charactersInString: "0123456789")
            if (string.rangeOfCharacterFromSet(numSet) != nil) && textField.text!.characters.count < 10 {
                return true
            }else {
                popupController.message = "Only numbers allowed"
                presentViewController(popupController, animated: true, completion: nil)
                delayPopUpDismiss()
                return false
            }
        }
        
        
        //addr
        if textField == addressField {
            let addrSet = NSCharacterSet(charactersInString: "0123456789ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ,-.\"").invertedSet
            if (string.rangeOfCharacterFromSet(addrSet) != nil){
                popupController.message = "only letters,numbers,- allowed"
                presentViewController(popupController, animated: true, completion: nil)
                delayPopUpDismiss()
                return false
            }else {
                return true
            }
            
        }
        return true
        ///////
    }
    
    
    ///////////tap gesture functions
    func profileTapped(){
        profilePic.userInteractionEnabled = true
        phoneFIeld.userInteractionEnabled = true
        addressField.userInteractionEnabled = true
        isImagePressed = true
        //allow users to choose
        editButtonOutlet.setTitle("Save", forState: .Normal)

        let optionMenu = UIAlertController(title: "", message: "Choose image method", preferredStyle: .ActionSheet)

        let mediaAction = UIAlertAction(title: "Choose from device", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            //
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        

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
 
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(mediaAction)
        optionMenu.addAction(backCameraAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }

    
    ////////// tap gesture functions
    
    ////image picker
    // finished choosing image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = img //set image locally
            newImage = img//save new image
            isImageChanged = true
            isImagePressed = true
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
            
         //   if let imageData = UIImageJPEGRepresentation(newImage, 0.2){
   
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
                            print("new profile pic - \(url)")
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
    // delay dismiss
    func delayPopUpDismiss(){
        let delay = 0.75 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //// go to update screen
    func updateLabelTapped(){
        performSegueWithIdentifier("update", sender: nil)
    }
    
    // sign out
    func performSignOut(){
        
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("uservc", sender: nil)
        
    }
    //
    
}
