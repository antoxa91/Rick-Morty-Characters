//
//  ImageLoaderService.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import Foundation

final class ImageLoaderService {
    static let shared = ImageLoaderService()
    private init() {}
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    
    typealias DownloadImageCompletion = (Result <Data, NetworkError>) -> Void
    
    func downloadImage(_ url: URL, completion: @escaping DownloadImageCompletion) {
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
            
            
            switch response.statusCode {
            case 200..<300:
                let value = data as NSData
                self?.imageDataCache.setObject(value, forKey: key)
                completion(.success(data))
            case 400:
                completion(.failure(.badRequest))
            default:
                completion(.failure(.unknownStatusCode(response.statusCode)))
            }
        }
        
        task.resume()
    }
}
