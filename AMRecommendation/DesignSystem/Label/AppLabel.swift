//
//  AppLabel.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 06/07/26.
//

import Foundation
import UIKit

/// This class will help to mitigate potential implementation issues such as forgetting to make certain texts uppercased
final class AppLabel: UILabel {
    let fontEnum: FontEnum
    
    init(fontEnum: FontEnum, text: String) {
        self.fontEnum = fontEnum
        super.init(frame: .zero)
        
        /// Re-scale automatically when the user changes their Larger Text setting.
        adjustsFontForContentSizeCategory = true
        
        /// Enlarged text wraps instead of truncating
        numberOfLines = 0
        setText(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String){
        let finalText = fontEnum.isUppercased ? text.uppercased() : text
        attributedText = NSAttributedString(string: finalText, attributes: [
            .font: fontEnum.font,
            .kern: fontEnum.kern
        ])
    }
}
