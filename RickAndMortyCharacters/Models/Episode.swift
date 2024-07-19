//
//  Episode.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import Foundation

struct AllEpisodesResponse: Decodable {
    let results: [Episode]
}

struct Episode: Decodable {
    let name: String
}
