//
//  SegmentButtons.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 14/07/26.
//

import Foundation
import UIKit

#if DEBUG
enum SegmentButtons {
    /// This function will be used by all Previews in order to retrieve all Buttons linked to a UIView
    @MainActor
    static func segmentButtons(in view: UIView) -> [UIButton] {
        view.subviews.reduce(into: [UIButton]()) { result, subview in
            if let button = subview as? UIButton { result.append(button) }
            result.append(contentsOf: segmentButtons(in: subview))
        }
    }
}
#endif
