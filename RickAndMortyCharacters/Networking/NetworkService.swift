//
//  NetworkService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation

///TODO - посмотреть еще как улучшить
protocol NetworkServiceProtocol {
    func fetchCharacters<T: Decodable>(awaiting type: T.Type, url: URL,
                                       completion: @escaping (Result <T, NetworkError>) -> Void)
}

final class NetworkService {
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
}

// MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    func fetchCharacters<T: Decodable>(awaiting type: T.Type, url: URL,
                                       completion: @escaping (Result <T, NetworkError>) -> Void) {
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.badResponse))
            }
            
            switch response.statusCode {
            case 200..<300:
                do {
                    let decodedData = try self.decoder.decode(type.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.badDecode))
                }
            case 404:
                completion(.failure(.notFound))
            case 500:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownStatusCode(response.statusCode)))
            }
        }
        
        task.resume()
    }
}
