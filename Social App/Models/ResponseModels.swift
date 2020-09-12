//
//  Response.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation


struct SignUpResponse: Codable {
    var data: User?
    var status: Int
    var message: String?
}

struct LoginResponse: Codable {
    var data: User?
    var status: Int
    var message: String?
    
}

struct FetchedPostsResponse: Codable {
    var data: [Post]?
    var status: Int
    var message: String?
    var total: Int
}

