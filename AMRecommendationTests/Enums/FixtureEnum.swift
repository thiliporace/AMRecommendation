//
//  FixtureEnum.swift
//  AMRecommendationTests
//
//  Created by Thiago Liporace on 30/06/26.
//

import Foundation
import Testing
@testable import AMRecommendation

enum FixtureEnum {
    // Loads a JSON fixture (file containing a fixed, static set of data formatted in JSON) by file name
    static func data(_ name: String) throws -> Data {
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw FixtureError.notFound(name)
        }
        return try Data(contentsOf: url)
    }
}

enum FixtureError: Error, CustomStringConvertible {
    case notFound(String)
    var description: String {
        switch self {
        case .notFound(let n): return "Fixture '\(n).json' not found in test bundle"
        }
    }
}

// Because BundleToken is compiled directly into the AMRecommendationTests target,
// asking the system for "the bundle that contains BundleToken" guarantees that you are
// targeting the exact bundle where your JSON files live.
private final class BundleToken {}
