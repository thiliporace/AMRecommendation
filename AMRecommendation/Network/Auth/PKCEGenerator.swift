//
//  PKCEGenerator.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation
import CryptoKit

struct PKCEGenerator: Sendable {
    func makeCodeVerifier() -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes).base64URLEncodedString()
    }

    func makeCodeChallenge(for verifier: String) -> String {
        let digest = SHA256.hash(data: Data(verifier.utf8))
        return Data(digest).base64URLEncodedString()
    }
}
