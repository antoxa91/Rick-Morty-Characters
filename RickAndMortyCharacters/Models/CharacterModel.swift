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
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let location: CharacterLocation
    let image: String
    let episode: [String] // стучать к эпизодам надо
    //  let episode: [Episode] // стучать к эпизодам надо
    let url: String
    
    func formattedEpisodes() -> String {
        episode.compactMap {
            $0.split(separator: "/")
                .last
            .map { String($0) }}
        .joined(separator: ", ")
    }
}
