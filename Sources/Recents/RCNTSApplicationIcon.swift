//
//  RCNTSApplicationIcon.swift
//  
//
//  Created by Noah Little on 4/1/2022.
//

import UIKit
import RecentsC

class RCNTSApplicationIcon: SBApplicationIcon {
    override func iconImageViewClass(forLocation arg1: Any!) -> AnyClass! {
        return RCNTSIconImageView.self
    }
}
