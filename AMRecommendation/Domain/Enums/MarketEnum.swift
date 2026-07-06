//
//  MarketEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// This is a Type-Safe Extensible Struct (Fake Enum)
// You can pass any valid string or use the already created static properties to autocomplete.
// RawRepresentable gives this struct the capacity to be used as a .rawValue, and return a String.
// Sendable is a protocol that indicates a specific type is safe to share across concurrent boundaries
// (like passing it between different Tasks, threads, or actors) without causing data races.
public struct MarketEnum: RawRepresentable, Equatable, Sendable {
    // Needed for RawRepresentable
    public let rawValue: String

    // Also needed for RawRepresentable
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // Most common ones you can use as static properties
    public static let us = MarketEnum(rawValue: "US")
    public static let uk = MarketEnum(rawValue: "GB")
    public static let brazil = MarketEnum(rawValue: "BR")
    public static let spain = MarketEnum(rawValue: "ES")
}
