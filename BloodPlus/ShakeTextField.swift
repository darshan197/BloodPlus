//
//  ShakeTextField.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/30/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit

protocol ShakeTextField {}

extension ShakeTextField where Self:UIViewController {

    func addAnimationToTextField (txtField:UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(txtField.center.x - 10, txtField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(txtField.center.x + 10, txtField.center.y))
        txtField.layer.addAnimation(animation, forKey: "position")
    }

}
