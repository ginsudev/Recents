//
//  RCNTSViewController.swift
//  
//
//  Created by Noah Little on 7/1/2022.
//

import UIKit

class RCNTSViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(RCNTSView(frame: view.bounds))
    }
}
