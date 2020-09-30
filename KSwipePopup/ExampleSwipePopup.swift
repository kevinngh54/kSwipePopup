//
//  ExampleSwipePopup.swift
//  KSwipePopup
//
//  Created by NHK on 9/30/20.
//  Copyright © 2020 NHK. All rights reserved.
//

import UIKit

class ExampleSwipePopup: KSwipePopup {
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func getPopupView() -> UIView {
        return popupView
    }
    
    @IBAction func closeAction(_ sender: Any) {
        swipeDown()
    }
    
    deinit {
        print("Of course it work :3")
    }
}
