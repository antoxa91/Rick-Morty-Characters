//
//  FooterLoaderView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import UIKit

final class FooterLoaderView: UIView {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColorEnum.appBackground.color
        addSubview(spinner)
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 40),
            spinner.heightAnchor.constraint(equalToConstant: 40),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
}
