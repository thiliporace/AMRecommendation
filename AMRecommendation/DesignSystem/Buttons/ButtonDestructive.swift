//
//  ButtonDestructive.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

class ButtonDestructive: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonDestructiveFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    
    override var disabledFillColor: UIColor { return UIColor.clear}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor.clear}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    
    override var normalBorderColor: UIColor { return UIColor(resource: .buttonDestructiveBorder)}
    override var disabledBorderColor: UIColor { return UIColor(resource: .buttonDestructiveBorderDisabled)}
}
