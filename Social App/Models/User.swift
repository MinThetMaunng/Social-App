//
//  User.js.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var _id: String
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var fullName: String?
    var email: String?
    var password: String?
    var createdAt: String?
    var updatedAt: String?
    var token: String?
    var __v: Int?
    
    func login() {
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
