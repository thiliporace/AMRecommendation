//
//  FontEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

enum FontEnum {
    case display
    case title
    case section
    case data
    case annotation
    
    var font: UIFont {
        switch self {
        case .display:
            return UIFont(name: "ArchivoBlack-Regular", size: 900) ?? UIFont.systemFont(ofSize: 34, weight: .black)
        case .title:
            return UIFont(name: "Archivo-VariableFont_wdth,wght", size: 800) ?? UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        case .section:
            return UIFont(name: "Archivo-VariableFont_wdth,wght", size: 700) ?? UIFont.systemFont(ofSize: 13, weight: .bold)
        case .data:
            return UIFont(name: "IBMPlexMono-Regular", size: 400) ?? UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        case .annotation:
            return UIFont(name: "IBMPlexMono-Regular", size: 400) ?? UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        }
    }
    
    var isUppercased: Bool {
        switch self{
        case .display:
            return true
        case .title:
            return true
        case .section:
            return true
        case .data:
            return false
        case .annotation:
            return false
        }
    }
}
