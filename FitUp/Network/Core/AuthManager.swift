//
//  AuthManager.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.04.25.
//
import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    var accessToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: accessTokenKey)
            print("[AuthManager] Retrieved access token: \(token?.prefix(4) ?? "nil")...")
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: accessTokenKey)
            print("[AuthManager] Updated access token: \(newValue?.prefix(4) ?? "nil")...")
        }
    }

    var refreshToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: refreshTokenKey)
            print("[AuthManager] Retrieved refresh token: \(token?.prefix(4) ?? "nil")...")
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: refreshTokenKey)
            print("[AuthManager] Updated refresh token: \(newValue?.prefix(4) ?? "nil")...")
        }
    }

    func clearTokens() {
        print("[AuthManager] Clearing all tokens")
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
