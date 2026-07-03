//
//  NetworkSessionProtocol.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// Required for Unit Testing API requests inside APIClient.
protocol NetworkSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// URLSession already has this exact method, so conformance is free.
extension URLSession: NetworkSessionProtocol {}
