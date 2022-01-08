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
        
        let iconSize = frame.width
        icon = UIImageView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: iconSize,
                                         height: iconSize))
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCellForBundleID(_ id: String) {
        self.icon.image = RecentsGlobalData.sharedInstance.iconFromBundleID(id)
        if self.icon.image?.isSymbolImage == true {
            self.icon.tintColor = .white
        }
        
        self.bundleID = id
    }
}
