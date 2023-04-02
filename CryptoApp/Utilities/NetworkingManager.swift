//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Alik Nigay on 03.04.2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var description: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occurred."
            }
        }
    }
    
    static func download(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .tryMap { try handleURLResponse(output: $0, url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, _ url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else { throw NetworkError.badURLResponse(url: url) }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
