//
//  UIViewController+Extension.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 8.06.2023.
//

import UIKit


extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate () -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
    
}
