//
//  Logger + Extension.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import Foundation
import OSLog

extension Logger {
    private static var appIdentifier = Bundle.main.bundleIdentifier ?? ""
    static let network = Logger(subsystem: appIdentifier, category: "network")
    static let appDelegate = Logger(subsystem: appIdentifier, category: "appDelegate")
}
