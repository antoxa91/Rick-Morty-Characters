//
//  Episode.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
