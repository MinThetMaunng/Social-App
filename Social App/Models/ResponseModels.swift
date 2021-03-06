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
    var total: Int?
}

struct DeletePostResponse: Codable {
    var data: Post?
    var status: Int
    var message: String?
}

struct SearchUsersResponse: Codable {
    var data: [User]?
    var status: Int
    var message: String?
}

struct FollowUnfollowResponse: Codable {
    var data: Follow?
    var status: Int
    var message: String?
}

struct FetchedUsersResponse: Codable {
    var data: User?
    var status: Int
    var message: String?
}
