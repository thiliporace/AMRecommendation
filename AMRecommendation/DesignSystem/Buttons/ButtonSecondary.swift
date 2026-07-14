//
//  ButtonSecondary.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

class ButtonSecondary: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonSecondaryFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    
    override var disabledFillColor: UIColor { return UIColor.clear}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor.clear}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    
    override var normalBorderColor: UIColor { return UIColor(resource: .buttonSecondaryBorder)}
    override var disabledBorderColor: UIColor { return UIColor(resource: .buttonSecondaryBorderDisabled)}
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("ButtonSecondaryDarkMode") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonSecondary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryDarkModeHighlighted") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonSecondary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isHighlighted = true
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryDarkModeDisabled") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonSecondary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isEnabled = false
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryLightMode") {
    let button = ButtonSecondary(buttonTitle: "test")
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryLightModeHighlighted") {
    let button = ButtonSecondary(buttonTitle: "test")
    button.isHighlighted = true
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryLightModeDisabled") {
    let button = ButtonSecondary(buttonTitle: "test")
    button.isEnabled = false
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonSecondaryXXXL") {
    let button = ButtonSecondary(buttonTitle: "test")
    button.traitOverrides.preferredContentSizeCategory = .extraExtraExtraLarge
    return button
}
#endif
