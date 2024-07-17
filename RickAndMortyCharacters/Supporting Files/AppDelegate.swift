//
//  AppDelegate.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        
        ///TODO: - отрефакторить это
        ///
        let networkService = NetworkService()
        let navVC = UINavigationController(rootViewController: CharactersListViewController(networkService: networkService))
        navVC.navigationBar.standardAppearance = UINavigationBarAppearance()
        navVC.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navVC.navigationBar.standardAppearance.backgroundColor = AppColorEnum.appBackground.color
        navVC.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColorEnum.text.color]
        
        window.rootViewController = navVC
        
        self.window = window
        return true
    }
}

