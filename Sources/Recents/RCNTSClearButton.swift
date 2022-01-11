//
//  RCNTSClearButton.swift
//  Recents
//
//  Created by Noah Little on 11/1/2022.
//

import UIKit
import RecentsC

class RCNTSClearButton: UIView {
    private var blurBG: MTMaterialView!
    private var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        
        blurBG = MTMaterialView(recipe: 19, configuration: 1)
        blurBG.frame = bounds
        addSubview(blurBG)
        
        button = UIButton(type: .custom)
        button.frame = bounds
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        addSubview(button)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissVC() {
        UserDefaults.standard.removeObject(forKey: "Recents_app_bundle_identifiers_list")
        _viewControllerForAncestor().dismiss(animated: true, completion: nil)
    }
}
