//
//  NetworkError.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
}
