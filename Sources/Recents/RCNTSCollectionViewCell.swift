//
//  RCNTSCollectionViewCell.swift
//  
//
//  Created by Noah Little on 7/1/2022.
//

import UIKit

class RCNTSCollectionViewCell: UICollectionViewCell {
    var icon: UIImageView!
    var bundleID: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iconSize = frame.width - 22
        icon = UIImageView(frame: CGRect(x: frame.width/2 - iconSize/2,
                                         y: frame.height/2 - iconSize/2,
                                         width: iconSize,
                                         height: iconSize))
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCellForBundleID(_ id: String) {
        icon.image = RecentsGlobalData.sharedInstance.iconFromBundleID(id)!
        bundleID = id

        if icon.image?.isSymbolImage == true {
            icon.tintColor = .white
        }
    }
}
