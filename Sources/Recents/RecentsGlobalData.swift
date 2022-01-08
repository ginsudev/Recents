//
//  RecentsGlobalData.swift
//  
//
//  Created by Noah Little on 4/1/2022.
//

import Foundation
import RecentsC
import AudioToolbox

final class RecentsGlobalData: NSObject {
    static let sharedInstance = RecentsGlobalData()
        
    private override init() { }
    
    func iconFromBundleID(_ id: String) -> UIImage? {

        let icon: SBIcon? = SBIconController.sharedInstance().model.expectedIcon(forDisplayIdentifier: id)
        let imageSize = CGSize(width: 60, height: 60)
        let imageInfo = SBIconImageInfo(size: imageSize,
                                        scale: UIScreen.main.scale,
                                        continuousCornerRadius: 12)
        
        let img = icon?.generateImage(with: imageInfo) as? UIImage ?? UIImage(systemName: "questionmark.square.fill")
        return img
    }
    
    func openAppFromBundleID(_ id: String) {
        (UIApplication.shared as? SpringBoard)?.launchApplication(withIdentifier: id, suspended: false)
    }
}
