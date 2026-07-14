//
//  TitleHeaderView.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 14/07/26.
//

import Foundation
import UIKit

class TitleHeaderView: UIView {
    private let stackView = UIStackView()
    
    private let titleLabel: AppLabel
    private let annotationLabel: AppLabel
    
    private let segmentSpacing: CGFloat = 10

    /// Gap between the title and the decorative stripe block
    private let titleBarsSpacing: CGFloat = 16

    init(titleString: String, annotationString: String) {
        self.titleLabel = AppLabel(fontEnum: .display, text: titleString, color: .contentPrimary)
        self.annotationLabel = AppLabel(fontEnum: .annotation, text: annotationString, color: .accentPrimary)
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        configureTitleText()
        layoutStack()
    }
    
    private func configureTitleText(){
        
    }
    
    private func layoutStack(){
        stackView.axis = .vertical
        stackView.distribution = .fill
        /// Hug content on the left so the title row stays next to the text instead of stretching full width
        stackView.alignment = .leading

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = segmentSpacing

        /// Bottom row: the title with the accent stripe block beside it, vertically centred on the text
        let titleRow = UIStackView(arrangedSubviews: [titleLabel, StripesView()])
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = titleBarsSpacing

        stackView.addArrangedSubview(annotationLabel)
        stackView.addArrangedSubview(titleRow)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

/// The repeating vertical-stripe accent block from the design.
/// Mirrors the CSS `repeating-linear-gradient(90deg, #B6FF2E 0 4px, transparent 4px 8px)`
/// at a fixed 34×10: a 4pt accent stripe, a 4pt gap, repeating and clipped to the box.
final class StripesView: UIView {
    private let stripeWidth: CGFloat
    private let stripeGap: CGFloat
    private let fixedSize: CGSize

    init(width: CGFloat = 34, height: CGFloat = 10, stripeWidth: CGFloat = 4, stripeGap: CGFloat = 4) {
        self.stripeWidth = stripeWidth
        self.stripeGap = stripeGap
        self.fixedSize = CGSize(width: width, height: height)
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        /// Redraw on bounds/trait changes so the accent colour tracks light/dark
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Fixed decorative size, exactly as specified in the design
    override var intrinsicContentSize: CGSize { fixedSize }

    override func draw(_ rect: CGRect) {
        UIColor.accentPrimary.setFill()
        let period = stripeWidth + stripeGap
        var x: CGFloat = 0
        while x < bounds.width {
            /// Clip the final stripe to the box edge, matching the repeating gradient
            let clippedWidth = min(stripeWidth, bounds.width - x)
            UIBezierPath(rect: CGRect(x: x, y: 0, width: clippedWidth, height: bounds.height)).fill()
            x += period
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("TitleHeaderDarkMode"){
    PreviewHost.previewHost(.dark, fillWidth: true) {
        let titleHeaderView = TitleHeaderView(titleString: "for you", annotationString: "USR//AUTH OK · SESSION 4A2F")
        
        return titleHeaderView
    }
}

@available(iOS 17.0, *)
#Preview("TitleHeaderLightMode"){
    PreviewHost.previewHost(.light, fillWidth: true) {
        let titleHeaderView = TitleHeaderView(titleString: "for you", annotationString: "USR//AUTH OK · SESSION 4A2F")
        
        return titleHeaderView
    }
}
#endif
