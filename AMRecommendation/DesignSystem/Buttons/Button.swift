//
//  ButtonProtocol.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

protocol ButtonProtocol {
    func setupButton()
    func updateStates()
    
    // Colors that inherited classes can override later
    var highlightedFillColor: UIColor {get}
    var highlightedTextColor: UIColor {get}
    
    var disabledFillColor: UIColor {get}
    var disabledTextColor: UIColor {get}
    
    var normalFillColor: UIColor {get}
    var normalTextColor: UIColor {get}
    
    var normalBorderColor: UIColor {get}
    var disabledBorderColor: UIColor {get}
}

/// Super class for other buttons to inherit from
class Button: UIButton, ButtonProtocol {
    let buttonTitle: String
    
    /// Placeholder values
    var highlightedFillColor: UIColor { return UIColor(white: 255, alpha: 1) }
    var highlightedTextColor: UIColor { return UIColor(white: 255, alpha: 1) }
    
    var disabledFillColor: UIColor { return UIColor(white: 255, alpha: 1) }
    var disabledTextColor: UIColor { return UIColor(white: 255, alpha: 1) }
    
    var normalFillColor: UIColor { return UIColor(white: 255, alpha: 1) }
    var normalTextColor: UIColor { return UIColor(white: 255, alpha: 1) }
    
    var normalBorderColor: UIColor { return UIColor(white: 255, alpha: 1)}
    var disabledBorderColor: UIColor { return UIColor(white: 255, alpha: 1)}

    /// Upper bound for Dynamic Type growth on the title.
    var maximumTitlePointSize: CGFloat { 20 }
    
    init(buttonTitle: String) {
        self.buttonTitle = buttonTitle.uppercased()
        super.init(frame: CGRect(origin: .zero, size: .init(width: 358, height: 56)))
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton(){
        /// Initializing a button filled with a solid color
        var config = UIButton.Configuration.filled()

        /// Setting title config
        config.titleAlignment = .center
        config.title = buttonTitle

        /// Setting corner details
        config.background.cornerRadius = 0
        config.cornerStyle = .fixed

        self.configuration = config

        /// Built-in block that iOS automatically triggers whenever the button's state changes
        self.configurationUpdateHandler = { button in
            guard let button = button as? Button else { return }
            button.updateStates()
        }

        /// Update the Button Configuration if the user alters its Larger Text preference
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) { (button: Button, _) in
                button.setNeedsUpdateConfiguration()
            }
        }
    }
    
    func updateStates() {
        var config = self.configuration
        
        let fillColor: UIColor
        let textColor: UIColor
        let borderColor: UIColor
        
        switch self.state {
        case .highlighted:
            fillColor = highlightedFillColor
            textColor = highlightedTextColor
            borderColor = normalBorderColor
        case .disabled:
            fillColor = disabledFillColor
            textColor = disabledTextColor
            borderColor = disabledBorderColor
        default:
            fillColor = normalFillColor
            textColor = normalTextColor
            borderColor = normalBorderColor
        }
        
        config?.background.backgroundColor = fillColor
        config?.background.strokeWidth = 1
        config?.background.strokeColor = borderColor

        /// TraitCollection: The traits, such as the size class and scale factor, that describe the current environment of the object.
        /// The custom typography system uses UIFontMetrics behind the scenes. By feeding it the traits,
        /// your system knows exactly how much to scale up the font size and the letter-spacing (kern) to match
        /// the user's system text configuration
        let traits = self.traitCollection
        let scaledFont = FontEnum.section.font(compatibleWith: traits, maximumPointSize: maximumTitlePointSize)
        let scaledKern = FontEnum.section.kern(compatibleWith: traits, maximumPointSize: maximumTitlePointSize)

        var attributes = AttributeContainer()
        attributes.font = scaledFont
        attributes.kern = scaledKern
        attributes.foregroundColor = textColor
        config?.attributedTitle = AttributedString(buttonTitle, attributes: attributes)

        /// UIButton.Configuration substitutes its own default font over the one set
        /// on attributedTitle. Re-apply the font through the transformer so it survives.
        config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = scaledFont
            outgoing.kern = scaledKern
            return outgoing
        }

        self.configuration = config
    }
}


