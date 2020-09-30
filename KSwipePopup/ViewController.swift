//
//  ViewController.swift
//  KSwipePopup
//
//  Created by NHK on 9/30/20.
//  Copyright © 2020 NHK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var examplePopup: KSwipePopup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func showPopupAction(_ sender: Any) {
        examplePopup = ExampleSwipePopup()
        examplePopup?.showPopup(in: self)
    }
}

