//
//  Userdefaults+Extensions.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 8.06.2023.
//

import Foundation


extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
    }
    
}
