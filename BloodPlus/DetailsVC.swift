//
//  DetailsVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/26/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import UIKit
import Foundation

class DetailsVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,
UINavigationControllerDelegate{

    @IBOutlet weak var addrField: UITextField!
    @IBOutlet weak var pinField: UITextField!

    @IBOutlet weak var bloodPicker: UIPickerView!
    
    var bloodType:String = "O+"
    
     var pickerArray : [String] = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addrField.delegate = self
        pinField.delegate = self
        
        bloodPicker.delegate = self
        bloodPicker.dataSource = self
        
        
        //tap gesture
        view.userInteractionEnabled = true
        let aSelector :Selector = #selector(DetailsVC.backgroundTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func searchPressed(sender: RoundButton) {
        
        performSegueWithIdentifier("search", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if addrField.text != "" || pinField != ""{
            let searchDetails = SearchDetails(addr: addrField.text!, pincode: pinField.text!, blood: bloodType)
            if let destViewController = segue.destinationViewController as? TableVC{
                destViewController.searchObject = searchDetails
            }
            
        }
    }
    
    //
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBloodType = pickerArray[row]
        bloodType = selectedBloodType
    }
    
    // textfield return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.addrField.resignFirstResponder()
        self.pinField.resignFirstResponder()
        return true
    }
    
    ///// background tap
    func backgroundTapped()  {
        self.addrField.resignFirstResponder()
        self.pinField.resignFirstResponder()
    }


}
