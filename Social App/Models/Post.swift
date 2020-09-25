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
    var imageName: String?
    var imageUrl: String?
    var createdAt: String?
    var updatedAt: String?
    var timeAgo: String?
    var __v: Int?
}

