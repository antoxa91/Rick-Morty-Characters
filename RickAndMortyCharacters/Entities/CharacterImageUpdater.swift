//
//  CharacterImageUpdater.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import UIKit
import OSLog

protocol CharacterImageDelegate: AnyObject {
    func didUpdateImage(_ model: CharacterImageUpdater, image: UIImage?)
}

final class CharacterImageUpdater {
    weak var delegate: CharacterImageDelegate?
    
    func fetchImage(with url: URL) {
        ImageLoaderService.shared.downloadImage(url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.delegate?.didUpdateImage(self, image: image)
                }
            case .failure(let failure):
                Logger.network.error("Ошибка при загрузке character image: \(failure.localizedDescription)")
                DispatchQueue.main.async {
                    self.delegate?.didUpdateImage(self, image: nil)
                }
            }
        }
    }
}
