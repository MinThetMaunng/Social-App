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
}

class AuthService : NSObject {
    public static let shared = AuthService()
    
    private let keychain = KeychainSwift()
    var jwtToken: String {
        get {
            return keychain.get(Keys.token.rawValue) ?? ""
        }
        set {
            keychain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
