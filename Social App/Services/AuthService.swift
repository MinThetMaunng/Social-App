//
//  AuthService.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation
import KeychainSwift

enum Keys: String {
    case token = "jsonwebtoken"
    case isLoggedIn = "isLoggedIn"
    case currentUserId = "userId"
    case currentUserFullName = "fullName"
}

class AuthService : NSObject {
    
    public static let shared = AuthService()
    
    private let keychain = KeychainSwift()
    private let defaults = UserDefaults.standard
    
    var currentUserId: String? {
        get {
            return defaults.string(forKey: Keys.currentUserId.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.currentUserId.rawValue)
        }
    }
    
    var currentUserFullName: String? {
        get {
            return defaults.string(forKey: Keys.currentUserFullName.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.currentUserFullName.rawValue)
        }
    }
    
    var jwtToken: String? {
        get {
            return keychain.get(Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            keychain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: Keys.isLoggedIn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.isLoggedIn.rawValue)
        }
    }
    
}
