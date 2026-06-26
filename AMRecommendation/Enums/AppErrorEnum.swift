//
//  AppErrorEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

public enum AppErrorEnum: Error, LocalizedError, Equatable {
    case unauthorized(repositoryType: String)
    case forbidden(repositoryType: String)
    case rateLimited(repositoryType: String)
    case serverError(repositoryType: String, code: Int)
    case networkError(repositoryType: String)
    case decodingError(repositoryType: String)
    
    public var errorDescription: String? {
        switch self {
        case .unauthorized(let repo):
            return "Session expired while loading \(repo). Please log in again."
            
        case .forbidden(let repo):
            return "Access denied to \(repo). You do not have the required permissions."
            
        case .rateLimited(let repo):
            return "Too many requests for \(repo). Please slow down and try again later."
            
        case .serverError(let repo, let code):
            return "A server error (\(code)) occurred while fetching \(repo). Please try again later."
            
        case .networkError(let repo):
            return "Network connection lost while trying to load \(repo). Check your internet connection."
            
        case .decodingError(let repo):
            return "We encountered an issue reading the \(repo) data. Please check for app updates."
        }
    }
}
