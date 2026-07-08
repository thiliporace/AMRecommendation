//
//  ButtonDestructiveSnapshotTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 07/07/26.
//

import Foundation
import XCTest
import UIKit
import SnapshotTesting
@testable import AMRecommendation

class ButtonDestructiveSnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let names = [
            "Archivo-VariableFont_wdth,wght",
            "ArchivoBlack-Regular",
            "IBMPlexMono-Regular"
        ]
        for name in names {
            guard let url = Bundle(for: ButtonDestructiveSnapshotTests.self)
                    .url(forResource: name, withExtension: "ttf") else {
                print("font not in test bundle: \(name).ttf")
                continue
            }
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
                print("font register failed for \(name):", error.debugDescription)
            }
        }
    }
    
    private func createButtonsView() -> UIView {
        let view = UIView()

        view.backgroundColor = .systemBackground
        // Match the 390x220 design-system snapshot card so fonts are directly comparable.
        view.frame = CGRect(x: 0, y: 0, width: 390, height: 220)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.frame = view.bounds.insetBy(dx: 16, dy: 16)
        stackView.distribution = .fillEqually
        view.addSubview(stackView)

        let normalButton = ButtonDestructive(buttonTitle: "log out")

        let pressedButton = ButtonDestructive(buttonTitle: "pressed")
        pressedButton.isHighlighted = true

        let disabledButton = ButtonDestructive(buttonTitle: "disabled")
        disabledButton.isEnabled = false

        stackView.addArrangedSubview(normalButton)
        stackView.addArrangedSubview(pressedButton)
        stackView.addArrangedSubview(disabledButton)

        return view
    }

    func testButtonDestructive() {
        let variants: [(name: String, style: UIUserInterfaceStyle)] = [
            ("LightMode", .light),
            ("DarkMode", .dark)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for variant in variants {
                let viewToSnapshot = createButtonsView()
                // Render at the design card's 390x220 point size with a low displayScale so the
                // exported image stays small (780x440) and its button/font proportions match the card.
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: variant.style),
                    UITraitCollection(displayScale: 2.0)
                ])

                assertSnapshot(
                    of: viewToSnapshot,
                    as: .image(precision: 0.98, traits: traits),
                    named: variant.name
                )
            }
        }
    }

    /// Verifies the buttons honour Dynamic Type: the title font grows with the
    /// user's Larger Text setting instead of staying at its fixed design size.
    func testButtonDestructiveDynamicType() {
        let categories: [(name: String, category: UIContentSizeCategory)] = [
            ("ExtraSmall", .extraSmall),
            ("Default", .large),
            ("AccessibilityXXXL", .accessibilityExtraExtraExtraLarge)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for entry in categories {
                let viewToSnapshot = createButtonsView()
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: .light),
                    UITraitCollection(preferredContentSizeCategory: entry.category),
                    UITraitCollection(displayScale: 2.0)
                ])

                assertSnapshot(
                    of: viewToSnapshot,
                    as: .image(precision: 0.98, traits: traits),
                    named: entry.name
                )
            }
        }
    }
}

