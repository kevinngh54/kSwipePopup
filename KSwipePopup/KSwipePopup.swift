//
//  KSwipePopup.swift
//  KSwipePopup
//
//  Created by NHK on 9/30/20.
//  Copyright © 2020 NHK. All rights reserved.
//

import UIKit

class KSwipePopup: UIViewController {
    //MARK: Var
    ///duration to show/hide popup
    var duration = 0.3
    ///range allow to move popup up and down
    var rangeAllowToMove: CGFloat = 50
    ///save value of popup's origin center y
    var originCenterY: CGFloat = 0
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopupView()
    }
    
    //MARK: Public function
    ///Override this function to return child viewcontroller's popup view
    func getPopupView() -> UIView {
        return UIView()
    }
    
    ///Show popup in a viewcontroller
    func showPopup(in viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.modalPresentationStyle = .overFullScreen
        self.loadViewIfNeeded()
        let popup = self.getPopupView()
        popup.isHidden = true
        viewController.present(self, animated: false, completion: { [weak self] in
            guard let self = self else { return }
            popup.isHidden = false
            let originFrame = popup.frame
            popup.frame = CGRect(x: popup.frame.origin.x,
                                 y: self.view.frame.height,
                                 width: popup.frame.size.width,
                                 height: popup.frame.size.height)
            UIView.animate(withDuration: self.duration, animations: {
                popup.frame = originFrame
            }, completion: { _ in
                self.originCenterY = self.getPopupView().center.y
                if let completion = completion {
                    completion()
                }
            })
        })
        
    }
    
    ///Dismiss popup with a swipe down animation
    func swipeDown(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            let popup = self.getPopupView()
            popup.frame = CGRect(x: popup.frame.origin.x,
                                 y: self.view.frame.height,
                                 width: popup.frame.size.width,
                                 height: popup.frame.size.height)
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: completion)
        })
    }
    
    //MARK: Private function
    ///Add panGesture to popup view
    private func setupPopupView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        getPopupView().addGestureRecognizer(panGesture)
    }
    
    ///handle panGesture to hide popup when swipe down or move popup to original position
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else { return }
        //begin interact
        if gestureRecognizer.state == .changed || gestureRecognizer.state == .began {
            let translation = gestureRecognizer.translation(in: self.view)
            //if move up outside allow range, move to original position
            if gestureView.center.y < originCenterY - rangeAllowToMove {
                moveToCenterY(gestureView, to: originCenterY)
            } else {
                //else move the popup with the gesture
                gestureView.center = CGPoint(x: gestureView.center.x,
                                             y: gestureView.center.y + translation.y)
            }
            //reset pan's velocity
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        //end interact
        if gestureRecognizer.state == .ended {
            //if move down outside allow range, hide
            if gestureView.center.y > originCenterY + rangeAllowToMove {
                self.swipeDown()
            } else {
                //else move to original position
                moveToCenterY(gestureView, to: originCenterY)
            }
        }
    }
    
    ///set a new centerY to a view
    private func moveToCenterY(_ view: UIView, to centerY: CGFloat) {
        UIView.animate(withDuration: duration) {
            view.center = CGPoint(x: view.center.x, y: centerY)
        }
    }
}
