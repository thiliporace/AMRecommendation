//
//  AppLabel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

/// This class will help to mitigate potential implementation issues such as forgetting to make certain texts uppercased
final class AppLabel: UILabel {
    let fontEnum: FontEnum
    
    init(fontEnum: FontEnum, text: String, color: UIColor) {
        self.fontEnum = fontEnum
        super.init(frame: .zero)
        
        /// Re-scale automatically when the user changes their Larger Text setting.
        adjustsFontForContentSizeCategory = true
        
        /// Enlarged text wraps instead of truncating
        numberOfLines = 0
        setText(text: text)
        setColor(color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setText(text: String){
        let finalText = fontEnum.isUppercased ? text.uppercased() : text
        attributedText = NSAttributedString(string: finalText, attributes: [
            .font: fontEnum.font,
            .kern: fontEnum.kern
        ])
    }
    
    private func setColor(color: UIColor){
        self.textColor = color
    }
}

#if DEBUG
/// One AppLabel per FontEnum style, stacked, so a preview shows the whole type scale at once
@available(iOS 17.0, *)
@MainActor
private func appLabelShowcase() -> UIView {
    let styles: [(FontEnum, String)] = [
        (.display, "Display"),
        (.title, "Title"),
        (.section, "Section"),
        (.data, "Data 1234"),
        (.control, "Control"),
        (.annotation, "Annotation"),
    ]

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = 16

    for (fontEnum, text) in styles {
        let label = AppLabel(fontEnum: fontEnum, text: text, color: UIColor(resource: .contentPrimary))
        stackView.addArrangedSubview(label)
    }

    return stackView
}

@available(iOS 17.0, *)
#Preview("AppLabelDarkMode"){
    PreviewHost.previewHost(.dark, fillWidth: true){
        appLabelShowcase()
    }
}

@available(iOS 17.0, *)
#Preview("AppLabelLightMode"){
    PreviewHost.previewHost(.light, fillWidth: true){
        appLabelShowcase()
    }
}

@available(iOS 17.0, *)
#Preview("AppLabelDarkModeXXXL"){
    PreviewHost.previewHost(.dark, contentSizeCategory: .extraExtraExtraLarge, fillWidth: true){
        appLabelShowcase()
    }
}
#endif
