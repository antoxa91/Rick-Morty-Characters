//
//  NetworkService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation

///TODO: удалить неиспользуемое
enum NetworkError: Error {
    case badData
    case badResponse
    case badRequest
    case badDecode
    case invalidURL
    case unknownStatusCode(Int)
}

protocol NetworkServiceProtocol {
    typealias DownloadCompletionHandler = (Result<[CharacterModel],NetworkError>) -> Void
    
    func fetchCharacters(completion: @escaping DownloadCompletionHandler)
}

final class NetworkService {
    private let decoder = JSONDecoder()
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
}

// MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    func fetchCharacters(completion: @escaping DownloadCompletionHandler) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        session.dataTask(with: request) { data, response, error in
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
            case 400:
                completion(.failure(.badRequest))
            default:
                completion(.failure(.unknownStatusCode(response.statusCode)))
            }
        }
        .resume()
    }
}
