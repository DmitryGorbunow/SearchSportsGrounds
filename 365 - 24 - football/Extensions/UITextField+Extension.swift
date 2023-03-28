//
//  UITextField+Extension.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/9/23.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Добавить картинку к левой стороне TextField
    func addLeft(image: UIImage) {
//        layer.masksToBounds = true
        
        let inset: CGFloat = 5
        
        let containerView = UIView(frame: CGRect(x: 5,
                                                 y: 0,
                                                 width: 30,
                                                 height: frame.height))
        
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: frame.height - inset * 5,
                                                  height: frame.height - inset * 5))
        
        imageView.image = image
        imageView.center = containerView.center
        containerView.addSubview(imageView)
        
        leftView = containerView
        leftViewMode = .always
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextField {

    var isEmpty: Bool {
        
        if let text = text, !text.isEmpty {
             return false
        }
        return true
    }
}
