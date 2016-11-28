//
//  DetailsVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/26/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import UIKit
import Foundation

class DetailsVC: UIViewController{

    @IBOutlet weak var addrField: UITextField!
    @IBOutlet weak var pinField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func searchPressed(sender: RoundButton) {
        
        performSegueWithIdentifier("search", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if addrField.text != "" || pinField != ""{
            let searchDetails = SearchDetails(addr: addrField.text!, pincode: pinField.text!)
            if let destViewController = segue.destinationViewController as? TableVC{
                destViewController.searchObject = searchDetails
            }
            
        }
    }

}
