//
//  RCNTSViewController.swift
//  
//
//  Created by Noah Little on 7/1/2022.
//

import UIKit

class RCNTSViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissMe), name: NSNotification.Name("Recents_Dismiss"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if view.subviews.count == 1 {
            return
        }
        
        view.addSubview(RCNTSView(frame: view.bounds))
    }
    
    @objc func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
}
