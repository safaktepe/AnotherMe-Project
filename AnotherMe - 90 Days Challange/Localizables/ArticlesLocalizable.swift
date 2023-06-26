//
//  ArticlesLocalizable.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 23.06.2023.
//

import Foundation

enum ArticlesLocalizable: String {
    
    case article1 = "article1"
    case article2 = "article2"
    case article3 = "article3"
    case article4 = "article4"
    case article5 = "article5"
    case article6 = "article6"
    
    func localized() -> String { rawValue.localized(.accessibility) }
}
