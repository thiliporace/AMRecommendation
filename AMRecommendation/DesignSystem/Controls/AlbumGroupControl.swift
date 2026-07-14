//
//  AlbumGroupControl.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 14/07/26.
//

import Foundation
import UIKit

class AlbumGroupControl: UIControl {
    
    let segments: [AlbumGroupEnum] = AlbumGroupEnum.allCases
    
    var selectedIndex: [Int] = [] {
        /// Executes code immediately after a property value is altered
        didSet {
            updateSelection()
        }
    }
    
    func updateSelection() {
        
    }
}
