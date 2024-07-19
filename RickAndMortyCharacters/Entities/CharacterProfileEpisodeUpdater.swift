//
//  CharacterProfileEpisodeUpdater.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import UIKit
import OSLog

protocol CharacterProfileEpisodeDelegate: AnyObject {
    func didUpdateEpisodes(_ model: CharacterProfileEpisodeUpdater, episodes: String)
}

final class CharacterProfileEpisodeUpdater {
    weak var delegate: CharacterProfileEpisodeDelegate?
    
    func fetchEpisodes(urls: [String]) {
        let group = DispatchGroup()
        var episodeNames: [String] = []
        let networkService = NetworkService()

        for url in urls {
            guard let episodeURL = URL(string: url) else { continue }
            group.enter()
            networkService.fetchData(awaiting: Episode.self, url: episodeURL) { result in
                defer { group.leave() }
                switch result {
                case .success(let episode):
                    episodeNames.append(episode.name)
                case .failure(let error):
                    Logger.network.error("Ошибка при загрузке эпизода: \(error)")
                }
            }
        }
        
        group.notify(queue: .main) {
            let episodesString = episodeNames.joined(separator: ", ")
            self.delegate?.didUpdateEpisodes(self, episodes: episodesString)
        }
    }
}
