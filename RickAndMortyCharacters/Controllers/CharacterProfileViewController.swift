//
//  CharacterDetailsViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit
import OSLog

final class CharacterProfileViewController: UIViewController {
    private let character: CharacterModel
    private let constant: CGFloat = 20
    
    private lazy var characterProfileView = CharacterProfileView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: Init
    init(character: CharacterModel) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    // MARK: Setup
    private func setupView() {
        view.backgroundColor = AppColorEnum.appBackground.color
        title = character.name
        view.addSubview(scrollView)
        scrollView.addSubview(characterProfileView)
        characterProfileView.configure(with: character)
    }
    
    // MARK: Layout
    private func setConstraints() {
            NSLayoutConstraint.activate([
                scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                characterProfileView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: constant),
                characterProfileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: constant),
                characterProfileView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -constant),
                characterProfileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -constant),
                characterProfileView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*constant)
            ])
        }
}
