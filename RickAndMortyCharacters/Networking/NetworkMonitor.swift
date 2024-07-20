//
//  NetworkMonitor.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import Foundation
import Network

final class NetworkMonitor {
    enum ConnectionType {
        case wifi
        case cellular
        case unknown
    }
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType? = .unknown
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else {
            connectionType = .unknown
        }
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
