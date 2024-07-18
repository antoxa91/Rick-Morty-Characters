//
//  NetworkService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias DownloadCompletion = (Result<[CharacterModel],NetworkError>) -> Void
    
    func fetchCharacters(completion: @escaping DownloadCompletion)
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
    func fetchCharacters(completion: @escaping DownloadCompletion) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.invalidURL))
        }
        
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
                    let decodedData = try self.decoder.decode(AllCharactersResponse.self, from: data)
                    completion(.success(decodedData.results))
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
