//
//  KeyboardLayoutHelper.swift
//  PJFDataSource
//
//  Created by Mike Thole on 7/26/19.
//  Copyright © 2019 Square, Inc. All rights reserved.
//

import UIKit

@objc protocol KeyboardLayoutHelperDelegate: NSObjectProtocol {
    func prepareForKeyboardAppearance()
    func prepareForKeyboardDisappearance()
}

@objc(PJFKeyboardLayoutHelper) public class KeyboardLayoutHelper: NSObject {
    private let bottomPadding: CGFloat
    private let view: UIView
    private let bottomConstraint: NSLayoutConstraint
    
    @objc weak var delegate: KeyboardLayoutHelperDelegate?
    
    @objc public init(view: UIView, bottomConstraint: NSLayoutConstraint) {
        self.view = view
        self.bottomConstraint = bottomConstraint
        self.bottomPadding = bottomConstraint.constant
        super.init()
        
        beginObservingKeyboardNotifications()
    }
    
    @objc public func beginObservingKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc public func endObservingKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Private methods
    
    @objc private func keyboardWillChangeFrame(_ notification: NSNotification) {
        guard
            let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [UIView.AnimationOptions(rawValue: animationCurve << 16)], animations: { [weak self] in
            guard let strongSelf = self else { return }
            if keyboardEndFrame.minY >= UIScreen.main.bounds.height {
                strongSelf.bottomConstraint.constant = strongSelf.bottomPadding
                strongSelf.delegate?.prepareForKeyboardDisappearance()
                
            } else {
                let viewFrameInScreenCoordinates = strongSelf.view.convert(strongSelf.view.bounds, to: nil)
                let intersection = viewFrameInScreenCoordinates.intersection(keyboardEndFrame)
                strongSelf.bottomConstraint.constant = -intersection.height
                strongSelf.delegate?.prepareForKeyboardAppearance()
            }
            
            strongSelf.view.layoutIfNeeded()
            
            }, completion: nil)
    }
}
