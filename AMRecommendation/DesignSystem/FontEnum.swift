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
    
    var size: CGFloat {
        switch self {
        case .display: return 34
        case .title: return 20
        case .section: return 13
        case .data: return 12
        case .annotation: return 10
        }
    }
    
    var tracking: CGFloat {
        switch self {
        case .display: return -0.01
        case .title:   return 0
        case .section: return 0.14
        case .data:    return 0
        case .annotation: return 0.12
        }
    }
    
    /// Kerning: Process of adjusting the horizontal spacing between specific pairs of letters in a font
    var kern: CGFloat { size * tracking }

    /// UIFont.TextStyle: Constants that describe the preferred styles for fonts.
    var textStyle: UIFont.TextStyle {
        switch self {
        case .display:    return .largeTitle
        case .title:      return .title1
        case .section:    return .headline
        case .data:       return .body
        case .annotation: return .caption1
        }
    }

    /// The custom typeface at its fixed design size, before Dynamic Type scaling.
    private var baseFont: UIFont {
        switch self {
        case .display:
            return UIFont(name: "ArchivoBlack-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .black)
        case .title:
            return UIFont(name: "ArchivoRoman-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
        case .section:
            return UIFont(name: "ArchivoRoman-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        case .data, .annotation:
            return UIFont(name: "IBMPlexMono-Regular", size: size) ?? UIFont.monospacedSystemFont(ofSize: size, weight: .regular)
        }
    }

    /// UIFontMetrics: A utility object for obtaining custom fonts that scale to support Dynamic Type.
    /// If it wasn't for custom fonts, you could use UIFont.preferredFont(forTextStyle:)
    /// forTextStyle: The text style that you want to apply to the font
    var font: UIFont {
        UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }

    /// Same as `font`, but scaled for an explicit trait collection.
    func font(compatibleWith traitCollection: UITraitCollection) -> UIFont {
        UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont, compatibleWith: traitCollection)
    }

    /// Letter spacing scaled alongside the font.
    func kern(compatibleWith traitCollection: UITraitCollection) -> CGFloat {
        UIFontMetrics(forTextStyle: textStyle).scaledValue(for: kern, compatibleWith: traitCollection)
    }

    var isUppercased: Bool {
        switch self{
        case .display, .title, .section:
            return true
        case .data, .annotation:
            return false
        }
    }
}
