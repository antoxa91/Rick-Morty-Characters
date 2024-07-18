//
//  CharacterStatus.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
    
    var color: UIColor {
        switch self {
        case .alive:
            return AppColorEnum.green.color
        case .dead:
            return AppColorEnum.red.color
        case .unknown:
            return AppColorEnum.gray.color
        }
    }
}
