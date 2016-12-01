//
//  ShakeLabel.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/30/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit

protocol ShakeLabel {}

extension ShakeLabel where Self:UIViewController {
    
    func addAnimationToLabelField (labelField:UILabel){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(labelField.center.x - 10, labelField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(labelField.center.x + 10, labelField.center.y))
        labelField.layer.addAnimation(animation, forKey: "position")
    }
    
}
