//
//  TimeRangeControlTests.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 08/07/26.
//

import XCTest
import UIKit
@testable import AMRecommendation

/// Interaction / behaviour tests for `TimeRangeControl`.
/// (Its rendered appearance is covered separately by `TimeRangeControlSnapshotTests`.)
final class TimeRangeControlTests: XCTestCase {

    private func makeControl() -> TimeRangeControl {
        let control = TimeRangeControl()
        control.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        control.layoutIfNeeded()
        return control
    }

    /// Flattens the control's view hierarchy to its segment buttons, in on-screen order.
    private func segmentButtons(in control: TimeRangeControl) -> [UIButton] {
        func collect(_ view: UIView) -> [UIButton] {
            view.subviews.reduce(into: [UIButton]()) { result, subview in
                if let button = subview as? UIButton { result.append(button) }
                result.append(contentsOf: collect(subview))
            }
        }
        return collect(control)
    }

    // MARK: - Initial state

    func testStartsOnFirstSegment() {
        let control = makeControl()

        XCTAssertEqual(control.selectedIndex, 0)
        XCTAssertEqual(control.selectedRange, TimeRangeEnum.allCases.first)
    }

    func testRendersOneButtonPerTimeRange() {
        let control = makeControl()

        XCTAssertEqual(segmentButtons(in: control).count, TimeRangeEnum.allCases.count)
    }

    // MARK: - Tapping segments

    func testTappingSegmentSelectsItAndFiresValueChanged() {
        let control = makeControl()
        let buttons = segmentButtons(in: control)

        var changeCount = 0
        control.addAction(UIAction { _ in changeCount += 1 }, for: .valueChanged)

        buttons[1].sendActions(for: .touchUpInside)

        XCTAssertEqual(control.selectedIndex, 1)
        XCTAssertEqual(control.selectedRange, TimeRangeEnum.allCases[1])
        XCTAssertEqual(changeCount, 1, "Tapping a new segment should fire .valueChanged exactly once")
    }

    func testTappingEachSegmentTracksSelection() {
        let control = makeControl()
        let buttons = segmentButtons(in: control)

        for (index, range) in TimeRangeEnum.allCases.enumerated() {
            buttons[index].sendActions(for: .touchUpInside)
            XCTAssertEqual(control.selectedIndex, index)
            XCTAssertEqual(control.selectedRange, range)
        }
    }

    func testTappingAlreadySelectedSegmentDoesNotFireValueChanged() {
        let control = makeControl()
        let buttons = segmentButtons(in: control)

        var changeCount = 0
        control.addAction(UIAction { _ in changeCount += 1 }, for: .valueChanged)

        // Segment 0 is selected on launch; tapping it again should be a no-op.
        buttons[0].sendActions(for: .touchUpInside)

        XCTAssertEqual(control.selectedIndex, 0)
        XCTAssertEqual(changeCount, 0, "Re-tapping the current segment must not fire .valueChanged")
    }

    // MARK: - Programmatic selection

    func testSettingSelectedRangeUpdatesIndexAndFires() {
        let control = makeControl()

        var changeCount = 0
        control.addAction(UIAction { _ in changeCount += 1 }, for: .valueChanged)

        let target = TimeRangeEnum.allCases[2]
        control.selectedRange = target

        XCTAssertEqual(control.selectedIndex, 2)
        XCTAssertEqual(control.selectedRange, target)
        XCTAssertEqual(changeCount, 1)
    }

    func testSettingSameIndexDoesNotFire() {
        let control = makeControl()

        var changeCount = 0
        control.addAction(UIAction { _ in changeCount += 1 }, for: .valueChanged)

        control.selectedIndex = 0 // unchanged

        XCTAssertEqual(changeCount, 0)
    }
}
