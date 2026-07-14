//
//  ButtonPrimary.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 07/07/26.
//

import Foundation
import UIKit

class ButtonPrimary: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonPrimaryFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonPrimaryContent)}
    
    override var disabledFillColor: UIColor { return UIColor(resource: .buttonPrimaryFillDisabled)}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonPrimaryContent)}
    
    override var normalBorderColor: UIColor { return UIColor.clear }
    override var disabledBorderColor: UIColor { return UIColor.clear }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("ButtonPrimaryDarkMode") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonPrimary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryDarkModeHighlighted") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonPrimary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isHighlighted = true
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryDarkModeDisabled") {
    PreviewHost.previewHost(.dark) {
        let button = ButtonPrimary(buttonTitle: "test")
        button.traitOverrides.userInterfaceStyle = .dark
        button.isEnabled = false
        return button
    }
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryLightMode") {
    let button = ButtonPrimary(buttonTitle: "test")
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryLightModeHighlighted") {
    let button = ButtonPrimary(buttonTitle: "test")
    button.isHighlighted = true
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryLightModeDisabled") {
    let button = ButtonPrimary(buttonTitle: "test")
    button.isEnabled = false
    return button
}

@available(iOS 17.0, *)
#Preview("ButtonPrimaryXXXL") {
    let button = ButtonPrimary(buttonTitle: "test")
    button.traitOverrides.preferredContentSizeCategory = .extraExtraExtraLarge
    return button
}
#endif
