//
//  AppLabel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

// This class will help to mitigate potential implementation issues such as forgetting to make certain texts uppercased
final class AppLabel: UILabel {
    let fontEnum: FontEnum
    
    init(fontEnum: FontEnum) {
        self.fontEnum = fontEnum
        super.init(frame: .zero)
        self.font = fontEnum.font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        get { return super.text }
        set {
            if fontEnum.isUppercased { super.text = newValue?.uppercased() }
            else { super.text = newValue }
        }
    }
    
}
