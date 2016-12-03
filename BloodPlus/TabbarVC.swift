//
//  TabbarVC.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 12/2/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabbarVC: UITabBarController {

    @IBAction func signoutPressed(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        performSegueWithIdentifier("tabvc", sender: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        print("tab bar")
        
        let tabBarItems = tabBar.items! as [UITabBarItem]
        /*
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "iconTab0.png")
        self.tabBarController?.tabBar.items![1].image = UIImage(named: "iconTab1.png")
        self.tabBarController?.tabBar.items![2].image = UIImage(named: "iconTab2.png")
         */
        tabBarItems[0].image = UIImage(named: "iconTab0")
        tabBarItems[1].image = UIImage(named: "iconTab1")
        tabBarItems[2].image = UIImage(named: "iconTab2")
    }
}
