//
//  CharacterProfileView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit
import OSLog

enum CharacterInfoLabel: String {
    case species = "Species: "
    case gender = "Gender: "
    case episodes = "Episodes: "
    case lastKnownLocation = "Last known location: "
}

final class CharacterProfileView: UIView {
    private enum ConstraintConstants {
        static let padding: CGFloat = 16.0
        static let statusHeight: CGFloat = 42.0
        static let imageHeightMultiplier: CGFloat = 0.92
    }
    
    private var episodesLoader: EpisodesLoaderService?
    private var imageLoader: ImageLoaderService?

    // MARK: Private UI Properties
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.appBackground.color
        return imageView
    }()
    
    private lazy var statusLabel = BaseLabel(font: .IBMPlexSans(fontType: .semiBold, size: 16),
                                             textAlignment: .center,
                                             cornerRadius: 16,
                                             clipsToBounds: true
    )
    private lazy var speciesLabel = BaseLabel()
    private lazy var genderLabel = BaseLabel()
    private lazy var episodesLabel = BaseLabel()
    private lazy var lastLocationLabel = BaseLabel()
    
    private lazy var vInfoStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [speciesLabel, genderLabel, episodesLabel, lastLocationLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.addArrangedSubview(speciesLabel)
        vStack.addArrangedSubview(genderLabel)
        vStack.addArrangedSubview(episodesLabel)
        vStack.addArrangedSubview(lastLocationLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
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
    
    // MARK: Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColorEnum.cellBackground.color
        layer.cornerRadius = 24
        addSubviews(characterImageView, statusLabel, vInfoStackView)
        imageLoader = ImageLoaderService()
        imageLoader?.delegate = self
        episodesLoader = EpisodesLoaderService()
        episodesLoader?.delegate = self
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.layer.cornerRadius = 16
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor,
                                                    constant: ConstraintConstants.padding),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                        constant: ConstraintConstants.padding),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                         constant: -ConstraintConstants.padding),
            characterImageView.heightAnchor.constraint(equalTo: widthAnchor,
                                                       multiplier: ConstraintConstants.imageHeightMultiplier),
            
            statusLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,
                                             constant: ConstraintConstants.padding),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: ConstraintConstants.padding),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -ConstraintConstants.padding),
            statusLabel.heightAnchor.constraint(equalToConstant: ConstraintConstants.statusHeight),
            
            vInfoStackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor,
                                                constant: ConstraintConstants.padding),
            vInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -ConstraintConstants.padding),
            vInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: ConstraintConstants.padding),
            vInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -ConstraintConstants.padding)
        ])
    }
}

// MARK: - ConfigurableViewProtocol
extension CharacterProfileView: ConfigurableViewProtocol {
    typealias ConfigirationModel = CharacterModel
    
    func configure(with model: CharacterModel) {
        statusLabel.text = model.status.text
        statusLabel.backgroundColor = model.status.color
        speciesLabel.setAttributedText(leadingText: .species,
                                       trailingText: model.species)
        genderLabel.setAttributedText(leadingText: .gender,
                                      trailingText: model.gender.text)
        lastLocationLabel.setAttributedText(leadingText: .lastKnownLocation,
                                            trailingText: model.location.name)
        
        episodesLoader?.fetchEpisodes(urls: model.episode)
        
        guard let url = URL(string: model.image) else {
            Logger.network.error("Ошибка: Invalid URL")
            return
        }
        imageLoader?.fetchImage(with: url)
    }
}

// MARK: - CharacterProfileImageDelegate
extension CharacterProfileView: ImageLoaderDelegate {
    func didUpdateImage(_ model: ImageLoaderProtocol, image: UIImage?) {
        characterImageView.image = image
    }
}

// MARK: - CharacterProfileeEpisodeDelegate
extension CharacterProfileView: EpisodesLoaderDelegate {
    func didUpdateEpisodes(_ model: EpisodesLoaderService, episodes: String) {
        episodesLabel.setAttributedText(leadingText: .episodes, trailingText: episodes)
    }
}
