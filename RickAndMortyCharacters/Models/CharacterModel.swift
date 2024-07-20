//
//  CharacterModel.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation

struct AllCharactersResponse: Decodable {
    struct Info: Decodable {
        let count: Int
        let next: String?
    }
    
    let info: Info
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: CharacterGender
    let location: CharacterLocation
    let image: String
    let episode: [String]
}
