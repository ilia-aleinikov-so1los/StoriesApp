//
//  User.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let profilePictureURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePictureURL = "profile_picture_url"
    }
}

struct UsersPage: Codable {
    let users: [User]
}

struct UsersResponse: Codable {
    let pages: [UsersPage]
}
