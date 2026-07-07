//
//  DataExtension.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation

extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
