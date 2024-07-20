//
//  CharactersLoaderService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import Foundation
import OSLog

protocol CharactersLoaderProtocol {
    func fetchInitialCharacters(completion: @escaping (Result<AllCharactersResponse, NetworkError>) -> Void)
    func fetchAdditionalCharacters(url: URL, completion: @escaping (Result<AllCharactersResponse, NetworkError>) -> Void)
}

final class CharactersLoaderService: CharactersLoaderProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchInitialCharacters(completion: @escaping (Result<AllCharactersResponse, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkService.fetchData(awaiting: AllCharactersResponse.self, url: url) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                Logger.network.error("Ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAdditionalCharacters(url: URL, completion: @escaping (Result<AllCharactersResponse, NetworkError>) -> Void) {
        networkService.fetchData(awaiting: AllCharactersResponse.self, url: url) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                Logger.network.error("Ошибка: \(error.localizedDescription)")
            }
        }
    }
}
