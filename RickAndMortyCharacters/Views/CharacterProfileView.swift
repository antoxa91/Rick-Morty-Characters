//
//  CharacterProfileView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

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
    
    weak var alertDelegate: AlertDisplaying?
    
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
        episodesLabel.setAttributedText(leadingText: .episodes,
                                        trailingText: model.formattedEpisodes())
        lastLocationLabel.setAttributedText(leadingText: .lastKnownLocation,
                                            trailingText: model.location.name)
        
        guard let url = URL(string: model.image) else {
            self.alertDelegate?.showErrorAlert(with: .invalidURL)
            return
        }
        
        fetchImage(with: url)
    }
    
    func fetchImage(with url: URL) {
        ImageLoaderService.shared.downloadImage(url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                }
            case .failure(let failure):
                self.alertDelegate?.showErrorAlert(with: failure)
                break
            }
        }
    }
}
