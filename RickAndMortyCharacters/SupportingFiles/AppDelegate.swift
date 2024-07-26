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
        NetworkMonitor.shared.startMonitoring()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        do {
            let assembly = CharactersViewControllerAssembly(networkService: NetworkService())
            window.rootViewController = try assembly.create()
        } catch {
            Logger.appDelegate.error("Не удалось создать CharactersListViewController: \(error.localizedDescription)")
        }
        self.window = window
        
        return true
    }
}

