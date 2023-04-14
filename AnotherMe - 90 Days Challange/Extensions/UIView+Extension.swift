//
//  UIView+Extension.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 2.02.2023.
//

import UIKit


extension UIView {
   @IBInspectable var cornerRadius: CGFloat {
       get { return self.cornerRadius }
        set {
            layer.cornerRadius = newValue
        }
        
    }
}
