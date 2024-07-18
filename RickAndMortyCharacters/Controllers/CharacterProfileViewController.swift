//
//  CharacterDetailsViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

final class CharacterProfileViewController: UIViewController {
    
    private lazy var characterProfileView = CharacterProfileView()
    private let character: CharacterModel
    
    // MARK: Init
    init(character: CharacterModel) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = AppColorEnum.appBackground.color
        title = "Brad"
        view.addSubview(characterProfileView)
        characterProfileView.configure(with: character)
    }
    
    // MARK: Layout
    private func setConstraints() {
        //
    }
}
