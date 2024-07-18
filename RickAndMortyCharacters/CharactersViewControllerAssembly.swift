//
//  CharactersViewControllerAssembly.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

struct CharactersViewControllerAssembly {
    func create() throws -> UIViewController {
        let networkService: NetworkServiceProtocol = NetworkService()
        let vc = CharactersListViewController(networkService: networkService)
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.standardAppearance = UINavigationBarAppearance()
        navVC.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navVC.navigationBar.standardAppearance.backgroundColor = AppColorEnum.appBackground.color
        navVC.navigationBar.standardAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "IBMPlexSans-Bold", size: 24) ?? .systemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: AppColorEnum.text.color
        ]

        return navVC
    }
}
