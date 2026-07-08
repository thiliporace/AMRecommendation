//
//  TimeRangeControlSnapshotTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import XCTest
import SnapshotTesting
import UIKit
@testable import AMRecommendation

class TimeRangeControlSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let names = [
            "Archivo-VariableFont_wdth,wght",
            "ArchivoBlack-Regular",
            "IBMPlexMono-Regular",
            "IBMPlexMono-SemiBold"
        ]
        for name in names {
            guard let url = Bundle(for: TimeRangeControlSnapshotTests.self)
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
    
    private func createControlView() -> UIView {
        let controlView = TimeRangeControl()
        controlView.frame = CGRect(origin: .zero, size: controlView.intrinsicContentSize)

        // Match the 390-wide design-system snapshot card so fonts are directly comparable.
        // Centre the control so each segment renders at its intrinsic square size instead of
        // being stretched to the card width.
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: controlView.bounds.height))
        view.backgroundColor = .systemBackground
        controlView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(controlView)

        return view
    }

    /// Finds the control's segment buttons in on-screen (left-to-right) order.
    private func segmentButtons(in view: UIView) -> [UIButton] {
        view.subviews.reduce(into: [UIButton]()) { result, subview in
            if let button = subview as? UIButton { result.append(button) }
            result.append(contentsOf: segmentButtons(in: subview))
        }
    }

    func testTimeRangeControl() {
        let variants: [(name: String, style: UIUserInterfaceStyle)] = [
            ("LightMode", .light),
            ("DarkMode", .dark)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for variant in variants {
                let viewToSnapshot = createControlView()
                // The 390x63 frame matches the design card; rendered at 2x for a crisp, small
                // reference whose control/font proportions line up with the card.
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: variant.style),
                    UITraitCollection(displayScale: 3.0)
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
    func testTimeRangeControlDynamicType() {
        let categories: [(name: String, category: UIContentSizeCategory)] = [
            ("ExtraSmall", .extraSmall),
            ("Default", .large),
            ("AccessibilityXXXL", .accessibilityExtraExtraExtraLarge)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for entry in categories {
                let viewToSnapshot = createControlView()
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: .light),
                    UITraitCollection(preferredContentSizeCategory: entry.category),
                    UITraitCollection(displayScale: 3.0)
                ])

                assertSnapshot(
                    of: viewToSnapshot,
                    as: .image(precision: 0.98, traits: traits),
                    named: entry.name
                )
            }
        }
    }

    /// Verifies that *tapping* a segment moves the highlight: the reference for each case
    /// shows a different segment filled than the default first-segment selection.
    func testTimeRangeControlSelectionOnTap() {
        let cases: [(name: String, tappedIndex: Int)] = [
            ("SecondSelected", 1),
            ("ThirdSelected", 2)
        ]

        withSnapshotTesting(diffTool: .init { reference, failure in
            return "open \"\(reference)\" \"\(failure)\""
        }) {
            for entry in cases {
                let viewToSnapshot = createControlView()
                let buttons = segmentButtons(in: viewToSnapshot)

                // Drive the real touch path so the snapshot reflects a genuine interaction.
                buttons[entry.tappedIndex].sendActions(for: .touchUpInside)

                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: .light),
                    UITraitCollection(displayScale: 3.0)
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
