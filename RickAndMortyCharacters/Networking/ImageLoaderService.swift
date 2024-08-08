//
//  ImageLoaderService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import UIKit
import OSLog

protocol ImageLoaderProtocol {
    func fetchImage(with url: URL, completion: @escaping (UIImage) -> Void)
}

protocol ImageLoaderCacheCleaner {
    func clearCache()
}

final class ImageLoaderService {
    private var imageDataCache = NSCache<NSString, NSData>()
    private let cacheQueue = DispatchQueue(label: "com.RickAndMortyCharacters.ImageLoaderService.cacheQueue", qos: .background, attributes: .concurrent)

    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private func downloadData(_ url: URL, completion: @escaping (Result <Data, NetworkError>) -> Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let data, error == nil else {
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.badResponse))
            }
            
            
            self?.handleResponse(response, data: data, key: key, completion: completion)
        }
        
        task.resume()
    }
    
    private func handleResponse(_ response: HTTPURLResponse, data: Data, key: NSString, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        switch response.statusCode {
        case 200..<300:
            let value = data as NSData
            cacheQueue.async {
                self.imageDataCache.setObject(value, forKey: key)
            }
            completion(.success(data))
        case 404:
            completion(.failure(.notFound))
        case 500:
            completion(.failure(.serverError))
        default:
            completion(.failure(.unknownStatusCode(response.statusCode)))
        }
    }
}

// MARK: - ImageLoaderProtocol
extension ImageLoaderService: ImageLoaderProtocol {
    func fetchImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        downloadData(url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    completion(image)
                case .failure(let failure):
                    Logger.network.error("Ошибка при загрузке character image: \(failure.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - ImageLoaderCacheCleaner
extension ImageLoaderService: ImageLoaderCacheCleaner {
    func clearCache() {
        imageDataCache.removeAllObjects()
    }
}
