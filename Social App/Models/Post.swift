//
//  Post.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation

struct Post: Codable {
    var _id: String
    var text: String?
    var user: User
    var createdAt: String?
    var updatedAt: String?
    var __v: Int?
}

