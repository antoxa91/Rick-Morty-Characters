//
//  NetworkService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation
import OSLog

protocol EpisodesLoader: AnyObject {
    func fetchEpisodes(urls: [String], completion: @escaping (String) -> Void)
}

protocol CharactersLoader: AnyObject {
    func fetchInitialCharacters(completion: @escaping () -> Void)
    func fetchAdditionalCharacters(completion: @escaping ([IndexPath]) -> Void)
    func filterBy(name: String?, parameters: FilterParameters?, completion: @escaping ([CharacterModel]) -> Void)

    var isShouldLoadMore: Bool { get }
    var apiInfo: AllCharactersResponse.Info? { get }
    var isLoadingMoreCharacters: Bool { get }
    var characters: [CharacterModel] { get }
}

final class NetworkService {
    private enum ConstantsQueryItem {
        static let name = "name"
        static let status = "status"
        static let gender = "gender"
        static let page = "page"
    }
    
    private enum ConstantsURLComponents {
        static let scheme = "https"
        static let host = "rickandmortyapi.com"
        static let path = "/api/character"
    }
    
    private let decoder = JSONDecoder()
    private let session: URLSession
        
    var characters: [CharacterModel] = []
    var apiInfo: AllCharactersResponse.Info? = nil
    var isLoadingMoreCharacters = false
    private var pageNumber = 2
    
    var isShouldLoadMore: Bool {
        return apiInfo?.next != nil
    }
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private func buildURL(queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = ConstantsURLComponents.scheme
        urlComponents.host = ConstantsURLComponents.host
        urlComponents.path = ConstantsURLComponents.path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func fetchData<T: Decodable>(awaiting type: T.Type, url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
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

// MARK: - CharactersLoadable
extension NetworkService: CharactersLoader {
    func fetchInitialCharacters(completion: @escaping () -> Void) {
        guard let url = buildURL(queryItems: nil) else { return }
        
        fetchData(awaiting: AllCharactersResponse.self, url: url) {[weak self] result in
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
        guard let url = buildURL(queryItems: [
            URLQueryItem(name: ConstantsQueryItem.page, value: "\(pageNumber)")
        ]) else { return }
        
        fetchData(awaiting: AllCharactersResponse.self, url: url) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let moreResults = response.results
                self.apiInfo = response.info
                
                let newCount = moreResults.count
                let totalCount = self.characters.count + newCount
                let startingIndex = totalCount - newCount
                let indexPathsToAdd = (startingIndex..<startingIndex + moreResults.count).map {
                    IndexPath(row: $0, section: 0)
                }
                
                self.characters.append(contentsOf: moreResults)
                self.isLoadingMoreCharacters = false
                DispatchQueue.main.async {
                    completion(indexPathsToAdd)
                }
            case .failure(let error):
                self.isLoadingMoreCharacters = false
                Logger.network.error("Не удается загрузить доп персонажей: \(error.localizedDescription)")
                completion([])
            }
        }
        
        pageNumber += 1
    }
    
    func filterBy(name: String? = nil, parameters: FilterParameters? = nil, completion: @escaping ([CharacterModel]) -> Void) {
        guard let url = buildURL(queryItems: [
            URLQueryItem(name: ConstantsQueryItem.name, value: name),
            URLQueryItem(name: ConstantsQueryItem.status, value: parameters?.status),
            URLQueryItem(name: ConstantsQueryItem.gender, value: parameters?.gender)
        ]) else {
            return
        }
        
        fetchData(awaiting: AllCharactersResponse.self, url: url) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(response.results)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    completion([])
                }
                Logger.network.error("Не могу загрузить список отфильтрованных персонажей: \(failure.localizedDescription) ")
            }
        }
    }
}

// MARK: - EpisodesLoader
extension NetworkService: EpisodesLoader {
    func fetchEpisodes(urls: [String], completion: @escaping (String) -> Void) {
        let group = DispatchGroup()
        var episodeNames: [String] = []
        
        for url in urls {
            guard let episodeURL = URL(string: url) else { continue }
            group.enter()
            fetchData(awaiting: Episode.self, url: episodeURL) { result in
                defer { group.leave() }
                switch result {
                case .success(let episode):
                    episodeNames.append(episode.name)
                case .failure(let error):
                    Logger.network.error("Ошибка при загрузке эпизода: \(error)")
                }
            }
        }
        
        group.notify(queue: .main) {
            let episodesString = episodeNames.joined(separator: ", ")
            completion(episodesString)
        }
    }
}
