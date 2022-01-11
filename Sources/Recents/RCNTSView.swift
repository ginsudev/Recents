//
//  RCNTSView.swift
//  
//
//  Created by Noah Little on 7/1/2022.
//

import UIKit
import RecentsC

class RCNTSView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    private var bgBlur: MTMaterialView!
    private var titleLabel: UILabel!
    private var appCollectionView: UICollectionView!
    private var clearButton: RCNTSClearButton!
    
    private var appsArray = UserDefaults.standard.stringArray(forKey: "Recents_app_bundle_identifiers_list") ?? ["com.apple.Preferences", "com.apple.camera", "com.apple.AppStore", "com.apple.MobileSMS"]
    
    //Grid config
    private var numberOfItemsInRow: Int {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return 4
        }
        return 8
    }
    
    private var margin = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgBlur = MTMaterialView(recipe: 19, configuration: 1)
        bgBlur.frame = self.bounds
        addSubview(bgBlur)
        
        let insets = UIEdgeInsets(top: 20,
                                  left: 20,
                                  bottom: 40,
                                  right: 20)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = insets
        
        let collectionFrame = CGRect(x: 0, y: frame.size.height - (self.frame.height/1.5), width: self.frame.width, height: self.frame.height/1.5)
        appCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        appCollectionView.register(RCNTSCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        appCollectionView.backgroundColor = .clear
        appCollectionView.alwaysBounceVertical = true
        appCollectionView.dataSource = self
        appCollectionView.delegate = self
        self.addSubview(appCollectionView)
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: appCollectionView.frame.minY - 50 - 20, width: self.frame.width - 80, height: 50))
        titleLabel.text = RecentsGlobalData.sharedInstance.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 56)
        titleLabel.textColor = .white
        addSubview(titleLabel)
        
        clearButton = RCNTSClearButton(frame: CGRect(x: frame.maxX - 30 - 30, y: titleLabel.frame.midY - 15, width: 30, height: 30))
        addSubview(clearButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMe))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard (touch.view is RCNTSCollectionViewCell) || (touch.view is RCNTSClearButton) else {
            return true
        }
        return false
    }
    
    @objc func dismissMe() {
        self._viewControllerForAncestor().dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RCNTSCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RCNTSCollectionViewCell
        cell.configCellForBundleID(appsArray[indexPath.row])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = collectionView.cellForItem(at: indexPath) as! RCNTSCollectionViewCell
        RecentsGlobalData.sharedInstance.openAppFromBundleID(selected.bundleID)
        self._viewControllerForAncestor().dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsInRow))
        return CGSize(width: size, height: size)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin*2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}
