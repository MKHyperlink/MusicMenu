//
//  KeyboardShift.swift
//  portal_network_iOS
//
//  Created by Mike on 04/01/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import UIKit


protocol KeyboardShiftDelegate {
    
    var viewDelegate: UIView! { get set }
    func registerForKeyboardNotifications()
    func unregisterFromKeyboardNotifications()
    func calculatePositionY(_ textField: UITextField)
}

public class KeyboardShift: NSObject, KeyboardShiftDelegate {

    // View delegate
    var viewDelegate: UIView! {
        didSet {
            self.setTapRecognizer()
        }
    }

    // Keyboard
    private var keyboardSize: CGFloat = 0
    private var keyboardAlreadyShow: Bool = false
    private var currentResponderPositionY: CGFloat = 0
    
    
    //    public override init() {
    //        super.init()
    //    }
    
    private func setTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(KeyboardShift.dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        self.viewDelegate.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShown(notification: NSNotification) {
        keyboardAlreadyShow = true
        if let info = notification.userInfo,
            let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardSize = frame.cgRectValue.height
            updateScreen()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        keyboardAlreadyShow = false
        var newFrame = self.viewDelegate.frame
        newFrame.origin.y = 0
        self.viewDelegate.frame = newFrame
    }
    
    @objc func dismissKeyboard() {
        self.viewDelegate.endEditing(true)
    }
    
    private func updateScreen() {
        let offset = UIScreen.main.bounds.height - currentResponderPositionY - keyboardSize
        if offset < 0 {
            var newFrame = self.viewDelegate.frame
            newFrame.origin.y = offset - 30
            self.viewDelegate.frame = newFrame
        }
    }
    
    func registerForKeyboardNotifications() {
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(KeyboardShift.keyboardWillShown(notification:)),
                           name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(KeyboardShift.keyboardWillBeHidden(notification:)),
                           name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications () {
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func calculatePositionY(_ textField: UITextField) {
        self.currentResponderPositionY = textField.convert(textField.bounds.origin, to: self.viewDelegate).y + textField.bounds.height
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
