//
//  ButtonSecondary.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 08/07/26.
//

import Foundation
import UIKit

class ButtonSecondary: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonSecondaryFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    
    override var disabledFillColor: UIColor { return UIColor.clear}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor.clear}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    
    override var normalBorderColor: UIColor { return UIColor(resource: .buttonSecondaryBorder)}
    override var disabledBorderColor: UIColor { return UIColor(resource: .buttonSecondaryBorderDisabled)}
}
