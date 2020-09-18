//
//  AuthService.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire

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
    
    func sendSignUpRequest(parameters: Parameters, completion: @escaping  (Result<SignUpResponse, Error>) -> ()) {
        let url = "\(baseUrl)/users/signup/"
        
        AF.request(url, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
                
            guard let data = resp.data else { return }
            do {
                let signUpResp = try JSONDecoder().decode(SignUpResponse.self, from: data)
                guard let _ = signUpResp.data?.token else {
                    fatalError("No token received from server!")
                }
                completion(.success(signUpResp))
            } catch (let err) {
                completion(.failure(err))
            }
        }
    }
    
    func sendLoginRequest(parameters: Parameters, completion: @escaping (Result<LoginResponse, Error>) -> ()) {
        let url = "\(baseUrl)/users/login/"
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding())
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
                guard let data = resp.data else { return }
                do {
                    let loginResp = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(loginResp))
                } catch (let err) {
                    completion(.failure(err))
                }
        }
    }
    
    
    func login(userId _id: String, token: String, fullName: String) {
        AuthService.shared.jwtToken = token
        AuthService.shared.isLoggedIn = true
        AuthService.shared.currentUserId = _id
        AuthService.shared.currentUserFullName = fullName
    }
    
    func logout() {
        AuthService.shared.jwtToken = nil
        AuthService.shared.isLoggedIn = false
        AuthService.shared.currentUserId = nil
        AuthService.shared.currentUserFullName = nil
    }
    
}
