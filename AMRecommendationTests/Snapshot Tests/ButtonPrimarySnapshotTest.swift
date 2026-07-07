//
//  ButtonPrimarySnapshotTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 07/07/26.
//

import Foundation
import XCTest
import UIKit
import SnapshotTesting
@testable import AMRecommendation

class ButtonPrimarySnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let names = [
            "Archivo-VariableFont_wdth,wght",
            "ArchivoBlack-Regular",
            "IBMPlexMono-Regular"
        ]
        for name in names {
            guard let url = Bundle(for: ButtonPrimarySnapshotTests.self)
                    .url(forResource: name, withExtension: "ttf") else {
                print("⚠️ NOT in test bundle: \(name).ttf")
                continue
            }
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
                print("⚠️ register failed for \(name):", error.debugDescription)
            }
        }
    }
    
    func testDumpFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   →", name)
            }
        }
    }
    
    private func createButtonsView() -> UIView {
        let view = UIView()

        view.backgroundColor = .systemBackground
        view.frame = CGRect(x: 0, y: 0, width: 780, height: 440)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.frame = view.bounds.insetBy(dx: 16, dy: 16)
        stackView.distribution = .fillEqually
        view.addSubview(stackView)

        let normalButtonTitle = AppLabel(fontEnum: .section, text: "connect spotify")
        let normalButton = ButtonPrimary(buttonTitle: normalButtonTitle.text!)

        let pressedButtonTitle = AppLabel(fontEnum: .section, text: "pressed")
        let pressedButton = ButtonPrimary(buttonTitle: pressedButtonTitle.text!)
        pressedButton.isHighlighted = true

        let disabledButtonTitle = AppLabel(fontEnum: .section, text: "disabled")
        let disabledButton = ButtonPrimary(buttonTitle: disabledButtonTitle.text!)
        disabledButton.isEnabled = false

        stackView.addArrangedSubview(normalButton)
        stackView.addArrangedSubview(pressedButton)
        stackView.addArrangedSubview(disabledButton)

        return view
    }

    func testButtonPrimary() {
        let variants: [(name: String, style: UIUserInterfaceStyle)] = [
            ("LightMode", .light),
            ("DarkMode", .dark)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for variant in variants {
                let viewToSnapshot = createButtonsView()
                let traits = UITraitCollection(userInterfaceStyle: variant.style)

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
    func testButtonPrimaryDynamicType() {
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
                    UITraitCollection(preferredContentSizeCategory: entry.category)
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

