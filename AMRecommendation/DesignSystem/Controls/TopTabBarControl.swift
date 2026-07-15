//
//  TopTabBarControl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 14/07/26.
//

import Foundation
import UIKit

class TopTabBarControl: UIControl {
    private let stackView = UIStackView()
    
    private let tabBarOptions: [String]
    
    var maximumTitlePointSize: CGFloat = 20 
    
    private let segmentSpacing: CGFloat = 20
    private let horizontalSpacing: CGFloat = 20
    
    var selectedIndex: Int = 0 {
        didSet {
            guard oldValue != selectedIndex else { return }
            updateSelection()
            sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    
    init(options tabBarOptions: [String]) {
        self.tabBarOptions = tabBarOptions
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        configureButtons()
        layoutStack()
        updateSelection()
        
        /// Update the Button Configuration if the user alters its Larger Text preference
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) {
                (self: Self, previousTraitCollection: UITraitCollection) in
                for button in self.buttons {
                    button.setNeedsUpdateConfiguration()
                }
            }
        }
    }
    
    private func configureButtons(){
        buttons = tabBarOptions.enumerated().map { index, tabBarOption in
            var config = UIButton.Configuration.plain()
            config.titleAlignment = .center
            config.title = tabBarOption.uppercased()
            
            config.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
            
            let button = UIButton(configuration: config)
            
            /// Setup button bottom border
            let frame = CGRect(x: 0, y: 0, width: 10, height: 2)
            let border = UIView(frame: frame)
            
            border.translatesAutoresizingMaskIntoConstraints = false
            
            button.addSubview(border)
            
            NSLayoutConstraint.activate([
                border.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                border.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                border.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                border.heightAnchor.constraint(greaterThanOrEqualToConstant: 2)
            ])
            
            button.configurationUpdateHandler = { [weak self] button in
                guard let self, var config = button.configuration else { return }
                
                let isSelected = index == self.selectedIndex
                let traits = button.traitCollection
                let scaledFont = FontEnum.section.font(compatibleWith: traits, maximumPointSize: self.maximumTitlePointSize)
                let scaledKern = FontEnum.section.kern(compatibleWith: traits, maximumPointSize: self.maximumTitlePointSize)
                
                var attributes = AttributeContainer()
                attributes.font = scaledFont
                attributes.kern = scaledKern
                
                let currentColor =
                isSelected ? UIColor(resource: .buttonPrimaryFill) : UIColor(resource: .contentSecondary)
                
                attributes.foregroundColor = currentColor
                
                config.attributedTitle = AttributedString(tabBarOption.uppercased(), attributes: attributes)

                /// UIButton.Configuration substitutes its own default font over the one set
                /// on attributedTitle. Re-apply the font through the transformer so it survives.
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = scaledFont
                    outgoing.kern = scaledKern
                    return outgoing
                }
                
                button.configuration = config
                
                border.backgroundColor = currentColor
                border.isHidden = !isSelected
            }
            button.addTarget(self, action: #selector(didTapSegment(_:)), for: .touchUpInside)
            
            return button
        }
    }
    
    @objc private func didTapSegment(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectedIndex = index
    }
    
    private func layoutStack(){
        stackView.axis = .horizontal
        /// Instead of stretching to occupy the entire width of the screen (.fillEqually),
        /// we use .fill so we can later use a Spacer to stick this to the left
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = segmentSpacing

        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        
        let stackViewBorder = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1))
        stackViewBorder.backgroundColor = UIColor(resource: .contentSecondary)
        stackViewBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackViewBorder)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: segmentSpacing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -segmentSpacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -horizontalSpacing),

            stackViewBorder.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackViewBorder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpacing),
            stackViewBorder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalSpacing),
            stackViewBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    /// Ask every segment to re-run its `configurationUpdateHandler`
    private func updateSelection(){
        for button in buttons {
            button.setNeedsUpdateConfiguration()
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("TopTabBarDarkMode"){
    PreviewHost.previewHost(.dark, fillWidth: true){
        let topTabBarControl = TopTabBarControl(options: ["tracks","artists"])
        let buttons = SegmentButtons.segmentButtons(in: topTabBarControl)
        buttons[0].sendActions(for: .touchUpInside)
        return topTabBarControl
    }
}

@available(iOS 17.0, *)
#Preview("TopTabBarLightMode"){
    PreviewHost.previewHost(.light, fillWidth: true){
        let topTabBarControl = TopTabBarControl(options: ["tracks","artists"])
        let buttons = SegmentButtons.segmentButtons(in: topTabBarControl)
        buttons[0].sendActions(for: .touchUpInside)
        return topTabBarControl
    }
}
#endif
