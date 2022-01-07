//
//  RCNTSIconImageView.swift
//  
//
//  Created by Noah Little on 5/1/2022.
//

import Foundation
import RecentsC

class RCNTSIconImageView: SBIconImageView {
    private var materialBlur: MTMaterialView!
    private var imageView1: UIImageView!
    private var imageView2: UIImageView!
    private var imageView3: UIImageView!
    private var imageView4: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Listen for icon change requests.
        NotificationCenter.default.addObserver(self, selector: #selector(setIcons), name: NSNotification.Name("Recents_UpdateIcons"), object: nil)
        
        layer.cornerRadius = 14.4
        clipsToBounds = true
        
        materialBlur = MTMaterialView(recipe: 19, configuration: 1)
        addSubview(materialBlur)
        
        //icons
        imageView1 = UIImageView()
        imageView2 = UIImageView()
        imageView3 = UIImageView()
        imageView4 = UIImageView()
        
        addSubview(imageView1)
        addSubview(imageView2)
        addSubview(imageView3)
        addSubview(imageView4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        materialBlur.frame = self.bounds
        
        let spacing = 7.0
        let iconSize: CGFloat = frame.width/2 - 10
        
        imageView1.frame = CGRect(x: spacing,
                                  y: spacing,
                                  width: iconSize,
                                  height: iconSize)
        
        imageView2.frame = CGRect(x: frame.maxX - iconSize - spacing,
                                  y: spacing,
                                  width: iconSize,
                                  height: iconSize)
        
        imageView3.frame = CGRect(x: spacing,
                                  y: frame.maxY - iconSize - spacing,
                                  width: iconSize,
                                  height: iconSize)
        
        imageView4.frame = CGRect(x: frame.maxX - iconSize - spacing,
                                  y: frame.maxY - iconSize - spacing,
                                  width: iconSize,
                                  height: iconSize)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setIcons()
    }
    
    @objc func setIcons() {
        DispatchQueue.main.async {
            let array = UserDefaults.standard.stringArray(forKey: "Recents_app_bundle_identifiers") ?? ["", "", "", ""]
            let global = RecentsGlobalData.sharedInstance
            
            self.imageView1.image = global.iconFromBundleID(array[0])
            self.imageView2.image = global.iconFromBundleID(array[1])
            self.imageView3.image = global.iconFromBundleID(array[2])
            self.imageView4.image = global.iconFromBundleID(array[3])
        }
    }
}
