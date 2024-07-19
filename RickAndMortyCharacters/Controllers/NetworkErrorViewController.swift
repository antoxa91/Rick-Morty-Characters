//
//  NetworkErrorViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import UIKit

final class NetworkErrorViewController: UIViewController {
    
    // MARK: Private UI Properties
    private lazy var networkErrorView = NetworkErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.addSubviews(networkErrorView)
        networkErrorView.delegate = self
        
        NSLayoutConstraint.activate([
            networkErrorView.topAnchor.constraint(equalTo: view.topAnchor),
            networkErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkErrorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - NetworkErrorViewDelegate
extension NetworkErrorViewController: NetworkErrorViewDelegate {
    func retryButtonTapped() {
        if NetworkMonitor.shared.isConnected {
            self.dismiss(animated: true)
        }
    }
}
