//
//  RoundButton.swift
//  BloodPlus
//
//  Created by Chiranth Bangalore Sathyaprakash on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit

class RoundButton : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
    

}
