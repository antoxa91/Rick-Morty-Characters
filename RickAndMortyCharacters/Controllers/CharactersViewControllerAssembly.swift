//
//  CharactersViewControllerAssembly.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

struct CharactersViewControllerAssembly {
    let charactersLoader: CharactersLoadable
    
    func create() throws -> UIViewController {
        
        let vc = CharactersListViewController(charactersLoader: charactersLoader)
        let navVC = UINavigationController(rootViewController: vc)
        configureNavigationBar(for: navVC)
        
        return navVC
    }
    
    private func configureNavigationBar(for navController: UINavigationController) {
        navController.navigationBar.standardAppearance = UINavigationBarAppearance()
        navController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navController.navigationBar.standardAppearance.backgroundColor = AppColorEnum.appBackground.color
        navController.navigationBar.standardAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "IBMPlexSans-Bold", size: 24) ?? .systemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: AppColorEnum.text.color
        ]
    }
}
