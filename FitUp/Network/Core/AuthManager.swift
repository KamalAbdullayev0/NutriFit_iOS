//
//  AuthManager.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.04.25.
//

import Foundation
import KeychainAccess

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let keychain = Keychain()

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    var accessToken: String? {
        get {
            let token = try? keychain.get(accessTokenKey)
            print("[AuthManager] Retrieved access token: \(token?.prefix(4) ?? "nil")...")
            return token
        }
        set {
            if let value = newValue {
                try? keychain.set(value, key: accessTokenKey)
                print("[AuthManager] Saved access token: \(value.prefix(4))...")
            } else {
                try? keychain.remove(accessTokenKey)
                print("[AuthManager] Removed access token")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            let token = try? keychain.get(refreshTokenKey)
            print("[AuthManager] Retrieved refresh token: \(token?.prefix(4) ?? "nil")...")
            return token
        }
        set {
            if let value = newValue {
                try? keychain.set(value, key: refreshTokenKey)
                print("[AuthManager] Saved refresh token: \(value.prefix(4))...")
            } else {
                try? keychain.remove(refreshTokenKey)
                print("[AuthManager] Removed refresh token")
            }
        }
    }
    
    func clearTokens() {
        print("[AuthManager] Clearing all tokens...")
        try? keychain.remove(accessTokenKey)
        try? keychain.remove(refreshTokenKey)
    }
}
