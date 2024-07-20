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
    
    func fetchInitialCharacters(completion: @escaping () -> Void)
    func fetchAdditionalCharacters(completion: @escaping ([IndexPath]) -> Void)
    func fetchSearchableCharacters(name: String, completion: @escaping DownloadHandler)
    
    var isShouldLoadMore: Bool { get }
    var apiInfo: AllCharactersResponse.Info? { get }
    var isLoadingMoreCharacters: Bool { get }
    var characters: [CharacterModel] { get }
}

final class CharactersLoaderService {
    private let networkService: NetworkServiceProtocol
    
    var characters: [CharacterModel] = []
    var apiInfo: AllCharactersResponse.Info? = nil
    var isLoadingMoreCharacters = false
    
    var isShouldLoadMore: Bool {
        return apiInfo?.next != nil
    }
    
    private var pageNumber = 2
    
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
    func fetchInitialCharacters(completion: @escaping () -> Void) {
        let url = buildURL(queryItems: nil)
        fetchData(from: url) {[weak self] result in
            switch result {
            case .success(let response):
                self?.characters = response.results
                self?.apiInfo = response.info
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                Logger.network.error("Ошибка при загрузке персонажей: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    func fetchAdditionalCharacters(completion: @escaping ([IndexPath]) -> Void) {
        guard !isLoadingMoreCharacters else { return }
        isLoadingMoreCharacters = true
        let url = buildURL(queryItems: [URLQueryItem(name: "page", value: "\(pageNumber)")])

        fetchData(from: url) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                self.apiInfo = responseModel.info
                
                let newCount = moreResults.count
                let totalCount = self.characters.count + newCount
                let startingIndex = totalCount - newCount
                let indexPathsToAdd = (startingIndex..<startingIndex + moreResults.count).map {
                    IndexPath(row: $0, section: 0)
                }
                
                self.characters.append(contentsOf: moreResults)
                self.isLoadingMoreCharacters = false
                completion(indexPathsToAdd)
            case .failure(let error):
                self.isLoadingMoreCharacters = false
                Logger.network.error("Не удается загрузить доп персонажей: \(error.localizedDescription)")
                completion([])
            }
        }
        
        pageNumber += 1
    }
    
    ///TODO - доделать по аналогии с фильтром
    func fetchSearchableCharacters(name: String, completion: @escaping DownloadHandler) {
        let url = buildURL(queryItems: [URLQueryItem(name: "name", value: name)])
        fetchData(from: url, completion: completion)
    }
}
