//
//  ButtonPrimary.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 07/07/26.
//

import Foundation
import UIKit

class ButtonPrimary: Button {
    override var highlightedFillColor: UIColor { return UIColor(resource: .buttonPrimaryFillPressed)}
    override var highlightedTextColor: UIColor { return UIColor(resource: .buttonPrimaryContent)}
    
    override var disabledFillColor: UIColor { return UIColor(resource: .buttonPrimaryFillDisabled)}
    override var disabledTextColor: UIColor { return UIColor(resource: .contentDisabled)}
    
    override var normalFillColor: UIColor { return UIColor(resource: .buttonPrimaryFill)}
    override var normalTextColor: UIColor { return UIColor(resource: .buttonPrimaryContent)}
    
    override var normalBorderColor: UIColor { return UIColor.clear }
    override var disabledBorderColor: UIColor { return UIColor.clear }
}
