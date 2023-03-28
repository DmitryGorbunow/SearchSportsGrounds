//
//  AppDelegate+Extension.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/13/23.
//

import IQKeyboardManagerSwift

extension AppDelegate {
 
    func IQKeyboardManagerSetup() {
            IQKeyboardManager.shared.enable = true
            
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Готово"
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
}
