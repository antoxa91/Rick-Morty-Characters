//
//  CharactersLoaderService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import Foundation
import OSLog

protocol CharactersLoadable: AnyObject {
    typealias DownloadHandler = (Result<AllCharactersResponse, NetworkError>) -> Void

    func fetchInitialCharacters(completion: @escaping DownloadHandler)
    func fetchAdditionalCharacters(url: URL, completion: @escaping DownloadHandler)
    func fetchSearchableCharacters(name: String, completion: @escaping DownloadHandler)
}

final class CharactersLoaderService {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    private func buildURL(queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func fetchData(from url: URL?, completion: @escaping DownloadHandler) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkService.fetchData(awaiting: AllCharactersResponse.self, url: url) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                Logger.network.error("Ошибка: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - CharactersLoadable
extension CharactersLoaderService: CharactersLoadable {
    func fetchInitialCharacters(completion: @escaping DownloadHandler) {
        let url = buildURL(queryItems: nil)
        fetchData(from: url, completion: completion)
    }
    
    func fetchAdditionalCharacters(url: URL, completion: @escaping DownloadHandler) {
        fetchData(from: url, completion: completion)
    }
    
    func fetchSearchableCharacters(name: String, completion: @escaping DownloadHandler) {
        let url = buildURL(queryItems: [URLQueryItem(name: "name", value: name)])
        fetchData(from: url, completion: completion)
    }
}
