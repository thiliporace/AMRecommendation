//
//  TimeRangeControl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

/// UIControl: Visual elements that convey a specific action or intention in response to user interactions
/// Perfect for a static number of tabs with no scrolling
class TimeRangeControl: UIControl {
    
    let segments: [TimeRangeEnum] = TimeRangeEnum.allCases
    
    var selectedRange: TimeRangeEnum {
        get { segments[selectedIndex] }
        set { selectedIndex = segments.firstIndex(of: newValue) ?? 0 }
    }

    var selectedIndex: Int = 0 {
        didSet {
            guard oldValue != selectedIndex else { return }
            updateSelection()
            sendActions(for: .valueChanged)
        }
    }
    
    var maximumTitlePointSize: CGFloat = 20

    private let borderWidth: CGFloat = 1
    private let segmentSpacing: CGFloat = 1

    /// The buttons render at a minimum 44 height
    private let minimumButtonHeight: CGFloat = 44

    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: minimumButtonHeight)
    }

    init() {
        super.init(frame: .zero)
        setup()
        frame = CGRect(origin: .zero, size: intrinsicContentSize)
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
        buttons = segments.enumerated().map { index, segment in
            /// Initializing a button filled with a solid color
            var config = UIButton.Configuration.filled()

            /// Setting title config
            config.titleAlignment = .center
            config.title = segment.displayString

            /// Setting corner details
            config.background.cornerRadius = 0
            config.cornerStyle = .fixed

            /// Add padding to each button
            config.contentInsets = .init(top: 8, leading: 20, bottom: 8, trailing: 20)

            /// No per-segment stroke: the outer border + dividers come from the control's own background
            config.background.strokeWidth = 0

            let button = UIButton(configuration: config)

            /// Recompute the styling on every configuration update so the title font tracks
            /// Dynamic Type and the fill/text colours follow the current selection.
            /// If we did not use [weak self] here, this View and the Button would create a Strong Reference Cycle
            button.configurationUpdateHandler = { [weak self] button in
                guard let self, var config = button.configuration else { return }

                let isSelected = index == self.selectedIndex
                let traits = button.traitCollection
                let scaledFont = FontEnum.control.font(compatibleWith: traits, maximumPointSize: self.maximumTitlePointSize)
                let scaledKern = FontEnum.control.kern(compatibleWith: traits, maximumPointSize: self.maximumTitlePointSize)

                config.background.backgroundColor = isSelected
                    ? UIColor(resource: .buttonPrimaryFill)
                    : UIColor(resource: .backgroundPrimary)

                var attributes = AttributeContainer()
                attributes.font = scaledFont
                attributes.kern = scaledKern
                attributes.foregroundColor = isSelected
                    ? UIColor(resource: .buttonPrimaryContent)
                    : UIColor(resource: .contentSecondary)
                config.attributedTitle = AttributedString(segment.displayString, attributes: attributes)

                /// Re-apply the font so UIButton.Configuration doesn't override it
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = scaledFont
                    outgoing.kern = scaledKern
                    return outgoing
                }

                button.configuration = config
            }

            button.addTarget(self, action: #selector(didTapSegment(_:)), for: .touchUpInside)

            return button
        }
    }
    
    private func layoutStack() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = segmentSpacing

        for button in buttons {
            stackView.addArrangedSubview(button)
        }

        /// The background shows through as the outer border and the segment dividers
        backgroundColor = UIColor(resource: .borderStrong)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: borderWidth),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderWidth),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderWidth),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -borderWidth)
        ])
    }
    
    @objc private func didTapSegment(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectedIndex = index
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
#Preview("TimeRangeControlDarkMode"){
    PreviewHost.previewHost(.dark){
        let timeRangeControl = TimeRangeControl()
        let buttons = SegmentButtons.segmentButtons(in: timeRangeControl)
        buttons[0].sendActions(for: .touchUpInside)
        return timeRangeControl
    }
}

@available(iOS 17.0, *)
#Preview("TimeRangeControlLightMode"){
    PreviewHost.previewHost(.light){
        let timeRangeControl = TimeRangeControl()
        let buttons = SegmentButtons.segmentButtons(in: timeRangeControl)
        buttons[0].sendActions(for: .touchUpInside)
        return timeRangeControl
    }
}

@available(iOS 17.0, *)
#Preview("TimeRangeControlDarkModeXXXL"){
    PreviewHost.previewHost(.dark, contentSizeCategory: .extraExtraExtraLarge){
        let timeRangeControl = TimeRangeControl()
        let buttons = SegmentButtons.segmentButtons(in: timeRangeControl)
        buttons[0].sendActions(for: .touchUpInside)
        return timeRangeControl
    }
}
#endif
