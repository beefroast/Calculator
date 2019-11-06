//
//  CopyableLabel.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Based heavily on: https://stephenradford.me/make-uilabel-copyable/
//

import Foundation
import UIKit


class CopyableLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool { get { return true }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPressed(sender:))))
    }
    
    @objc func onLongPressed(sender: Any?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        guard menu.isMenuVisible == false else { return }
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
}
