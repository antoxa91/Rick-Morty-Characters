//
//  AppDelegate.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit
import OSLog

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        do {
            window.rootViewController = try CharactersViewControllerAssembly().create()
        } catch {
            let logger = Logger()
            logger.error("Не удалось создать CharactersListViewController: \(error.localizedDescription)")
        }
        
        self.window = window
        return true
    }
}

