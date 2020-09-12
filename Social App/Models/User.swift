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
    var email: String?
    var password: String?
    var createdAt: String?
    var updatedAt: String?
    var token: String?
    var __v: Int?
    
    var fullName: String {
        get {
            var fullNameString = ""
            if let firstName = self.firstName {
                fullNameString += firstName
            }
            if self.middleName != nil && self.middleName != "" {
                fullNameString += " \(self.middleName!)"
            }
            if self.lastName != nil && self.lastName != "" {
                fullNameString += " \(self.lastName!)"
            }
            return fullNameString
        }
    }
    
    func logIn() {
        AuthService.shared.jwtToken = token
        AuthService.shared.isLoggedIn = true
        AuthService.shared.currentUserId = _id
        AuthService.shared.currentUserFullName = fullName
    }
    
    func logOut() {
        AuthService.shared.jwtToken = nil
        AuthService.shared.isLoggedIn = false
        AuthService.shared.currentUserId = nil
        AuthService.shared.currentUserFullName = nil
    }
    
   
}
