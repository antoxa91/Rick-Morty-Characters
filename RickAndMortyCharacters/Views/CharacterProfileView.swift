//
//  CharacterProfileView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

final class CharacterProfileView: UIView {
    
    
    // MARK: Private UI Properties
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        /// FIXME: - не забыть изменить
        imageView.image = UIImage(resource: .launchBackground)
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodesLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // создать функцию которая вернет горизонт стек со статичным лейблом и из сети
    // вставить это потом в вертикальный
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        
        return stack
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColorEnum.cellBackground.color
        addSubviews(characterImageView, statusLabel, infoStackView)
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            //
        ])
    }
}

// MARK: - ConfigurableViewProtocol
extension CharacterProfileView: ConfigurableViewProtocol {
    func configure(with model: CharacterModel) {
        statusLabel.text = model.status.text
        statusLabel.backgroundColor = model.status.color
        
        // стек
        // картинка еще нужна
    }
    
    typealias ConfigirationModel = CharacterModel
}
