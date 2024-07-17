//
//  CharacterModel.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import Foundation


struct AllCharactersResponse: Decodable {
    let results: [CharacterModel]
}

///TODO - проверить на лишние поля
struct CharacterModel: Decodable {
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
}
