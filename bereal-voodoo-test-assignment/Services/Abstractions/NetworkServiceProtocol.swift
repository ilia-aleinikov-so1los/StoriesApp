//
//  NetworkServiceProtocol.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Combine

protocol NetworkServiceProtocol {
    func fetchUsers(page: Int) -> AnyPublisher<[User], Error>
}
