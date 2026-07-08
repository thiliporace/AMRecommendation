//
//  TimeRangeControl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

/// UIControl: Visual elements that convey a specific action or intention in response to user interactions
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
    
    var maximumTitlePointSize: CGFloat { 20 }

    private let borderWidth: CGFloat = 1
    private let segmentSpacing: CGFloat = 1

    /// The component renders at a fixed 174 × 33: the width is capped at 174 and never grows past it
    private let width: CGFloat = 174
    private let controlHeight: CGFloat = 33

    private let stackView = UIStackView()
    private var buttons: [UIButton] = []

    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: controlHeight)
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

            /// Remove the default padding so the short "4W"/"6M"/"1Y" labels fit on one line
            config.contentInsets = .zero

            /// No per-segment stroke: the outer border + dividers come from the control's own background
            config.background.strokeWidth = 0

            let button = UIButton(configuration: config)

            /// Recompute the styling on every configuration update so the title font tracks
            /// Dynamic Type and the fill/text colours follow the current selection.
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
        stackView.spacing = segmentSpacing

        for button in buttons {
            stackView.addArrangedSubview(button)
        }

        /// The background shows through as the outer border and the segment dividers
        backgroundColor = UIColor(resource: .borderStrong)
        addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        /// Inset by the border so the background shows as a 1pt frame around the segments
        stackView.frame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
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
