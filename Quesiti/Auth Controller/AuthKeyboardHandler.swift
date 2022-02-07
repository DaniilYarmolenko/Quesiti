//
//  AuthKeyyboardHandler.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 26.10.2021.
//

import UIKit

class AuthKeyboardHandler {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var view: UIView!
    var keyboardIsShown = false
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: NOTIF CENTER
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardOnTap()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: WILL SHOW METHOD
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        keyboardIsShown = true
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: WILL HIDE METHOD
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        keyboardIsShown = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HIDE KEYBOARD ON TAP
    
    private func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func hideKeyboard(){
        view.endEditing(true)
        keyboardIsShown = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
