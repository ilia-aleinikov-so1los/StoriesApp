//
//  NetworkService.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation
import Combine

class NetworkService: NetworkServiceProtocol {
    private let jsonFileName = "users"
    
    func fetchUsers(page: Int) -> AnyPublisher<[User], Error> {
        // Simulate network delay
        return Future<[User], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                guard let url = Bundle.main.url(forResource: self.jsonFileName, withExtension: "json") else {
                    promise(.failure(NetworkError.invalidURL))
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let response = try JSONDecoder().decode(UsersResponse.self, from: data)
                    
                    let pageIndex = (page - 1) % response.pages.count
                    let users = response.pages[pageIndex].users
                    
                    DispatchQueue.main.async {
                        promise(.success(users))
                    }
                } catch {
                    promise(.failure(NetworkError.decodingError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
