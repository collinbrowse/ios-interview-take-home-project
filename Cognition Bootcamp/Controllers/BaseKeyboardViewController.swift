//
//  BaseKeyboardViewController.swift
//  Axon Sports Lab
//
//  Created by Greg DeJong on 3/1/19.
//  Copyright © 2019 AxonSports. All rights reserved.
//

import UIKit

class BaseKeyboardViewController: UIViewController {
    
    private(set) var isTransitioningKeyboard:Bool = false
    private(set) var keyboardIsVisible:Bool = false
    private(set) var keyboardFrame:CGRect = CGRect.zero
    var statusBarHeight:CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        changeStatusBarSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.cancelsTouchesInView = false
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        let center = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc internal func dismissKeyboard() {
        self.isTransitioningKeyboard = false
        self.keyboardIsVisible = false
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        self.keyboardFrame = keyboardValue.cgRectValue
        if (!self.keyboardIsVisible) {
            self.keyboardIsVisible = true
            moveViewUpFromKeyboard(force:true)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue != nil else {
            return
        }
        self.keyboardFrame = CGRect.zero
        self.keyboardIsVisible = false
        if !isTransitioningKeyboard {
            UIView.animate(withDuration: 0.1, animations: {
                self.performKeyboardHideActions()
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func changeStatusBarSize() {
        moveViewUpFromKeyboard(force: true)
    }
    private func moveViewUpFromKeyboard(force:Bool) {
        if (self.keyboardIsVisible) {
            UIView.animate(withDuration: 0.1, animations: {
                self.performKeyboardShowActions()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    internal func performKeyboardHideActions() {}
    internal func performKeyboardShowActions() {}

}
