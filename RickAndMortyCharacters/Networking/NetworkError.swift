//
//  NetworkError.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import Foundation

enum NetworkError: Error {
    case badData
    case badResponse
    case badRequest
    case notFound
    case serverError
    case badDecode
    case invalidURL
    case unknownStatusCode(Int)
}
