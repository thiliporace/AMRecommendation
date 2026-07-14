//
//  ButtonDestructive.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

class ButtonDestructive: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonDestructiveFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    
    override var disabledFillColor: UIColor { return UIColor.clear}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor.clear}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    
    override var normalBorderColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    override var disabledBorderColor: UIColor { return UIColor(resource: .buttonDestructiveBorderDisabled)}
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("ButtonDestructiveDarkMode") {
    previewHost(.dark) {
        let button = ButtonDestructive(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveDarkModeHighlighted") {
    previewHost(.dark) {
        let button = ButtonDestructive(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isHighlighted = true
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveDarkModeDisabled") {
    previewHost(.dark) {
        let button = ButtonDestructive(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isEnabled = false
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveLightMode") {
    let button = ButtonDestructive(buttonTitle: "test")
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveLightModeHighlighted") {
    let button = ButtonDestructive(buttonTitle: "test")
    button.isHighlighted = true
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveLightModeDisabled") {
    let button = ButtonDestructive(buttonTitle: "test")
    button.isEnabled = false
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonDestructiveXXXL") {
    let button = ButtonDestructive(buttonTitle: "test")
    button.traitOverrides.preferredContentSizeCategory = .extraExtraExtraLarge
    return button
}
#endif
