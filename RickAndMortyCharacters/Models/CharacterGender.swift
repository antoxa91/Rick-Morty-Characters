//
//  CharacterGender.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation

enum CharacterGender: String, Decodable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case unknown = "unknown"
    case genderless = "Genderless"
    
    var text: String {
        switch self {
        case .male, .female, .unknown, .genderless:
            return rawValue.capitalized
        }
    }
}
