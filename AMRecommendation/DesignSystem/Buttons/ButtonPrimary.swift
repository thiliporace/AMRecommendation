//
//  ButtonPrimary.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 07/07/26.
//

import Foundation
import UIKit

class ButtonPrimary: UIButton {
    let buttonTitle: String
    
    init(buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: CGRect(origin: .zero, size: .init(width: 358, height: 56)))
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(){
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
            guard let buttonPrimary = button as? ButtonPrimary else { return }
            buttonPrimary.updateStates()
        }

        /// Update the Button Configuration if the user alters its Larger Text preference
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) { (button: ButtonPrimary, _) in
                button.setNeedsUpdateConfiguration()
            }
        }
    }
    
    private func updateStates() {
        var config = self.configuration
        
        let fillColor: UIColor
        let textColor: UIColor
        
        switch self.state {
        case .highlighted:
            fillColor = UIColor(resource: .buttonPrimaryFillPressed)
            textColor = UIColor(resource: .buttonPrimaryContent)
        case .disabled:
            fillColor = UIColor(resource: .buttonPrimaryFillDisabled)
            textColor = UIColor(resource: .contentDisabled)
        default:
            fillColor = UIColor(resource: .buttonPrimaryFill)
            textColor = UIColor(resource: .buttonPrimaryContent)
        }
        
        config?.background.backgroundColor = fillColor

        /// TraitCollection: The traits, such as the size class and scale factor, that describe the current environment of the object.
        /// The custom typography system uses UIFontMetrics behind the scenes. By feeding it the traits,
        /// your system knows exactly how much to scale up the font size and the letter-spacing (kern) to match
        /// the user's system text configuration
        let traits = self.traitCollection
        let scaledFont = FontEnum.section.font(compatibleWith: traits)
        let scaledKern = FontEnum.section.kern(compatibleWith: traits)

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
