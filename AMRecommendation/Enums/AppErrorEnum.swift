//
//  AppErrorEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

public enum AppErrorEnum: Error, LocalizedError, Equatable {
    case unauthorized
    case forbidden
    case rateLimited
    case serverError(code: Int)
    case networkError
    case decodingError
    case accessTokenMissing

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Session expired. Please log in again."

        case .forbidden:
            return "Access denied. You do not have the required permissions."

        case .rateLimited:
            return "Too many requests. Please slow down and try again later."

        case .serverError(let code):
            return "A server error (\(code)) occurred while fetching the repository. Please try again later."

        case .networkError:
            return "Network connection lost while trying to load the repository. Check your internet connection."

        case .decodingError:
            return "We encountered an issue reading the repository data. Please check for app updates."
            
        case .accessTokenMissing:
            return "There was an issue trying to retrieve an access token. Please try again."
        }
    }
}
