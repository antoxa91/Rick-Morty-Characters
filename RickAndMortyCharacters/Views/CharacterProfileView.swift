//
//  CharacterProfileView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

enum StaticInfoText: String {
    case species = "Species"
    case gender = "Gender"
    case episodes = "Episodes"
    case lastKnownLocation = "Last known location"
}

final class CharacterProfileView: UIView {
    
    // MARK: Private UI Properties
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.appBackground.color
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var episodesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var lastLocationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var vInfoStackView: UIStackView = {
        let vStack = UIStackView()
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
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColorEnum.cellBackground.color
        layer.cornerRadius = 24
        addSubviews(characterImageView, statusLabel, vInfoStackView)
    }
    
    private func getAttributedText(staticText: StaticInfoText, modelText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "\(staticText.rawValue): ",
            attributes: [
                .font: UIFont.IBMPlexSans(fontType: .semiBold, size: 16),
                .foregroundColor: AppColorEnum.text.color
            ]
        )
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.IBMPlexSans(fontType: .regular, size: 16),
            .foregroundColor: AppColorEnum.text.color
        ]
        
        attributedString.append(NSAttributedString(string: modelText, attributes: regularAttributes))
        
        return attributedString
    }
    
    private func listOfEpisodes(model: CharacterModel) -> String {
        model.episode.compactMap { $0.split(separator: "/")
                .last
            .map { String($0)}}
        .joined(separator: ", ")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        characterImageView.layer.cornerRadius = 16
    }
        
    ///TODO - расчитать адаптивные размеры
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            characterImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
            
            statusLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 42),
            
            vInfoStackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            vInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - ConfigurableViewProtocol
extension CharacterProfileView: ConfigurableViewProtocol {
    typealias ConfigirationModel = CharacterModel
    
    func configure(with model: CharacterModel) {
        statusLabel.text = model.status.text
        statusLabel.backgroundColor = model.status.color
        
        speciesLabel.attributedText = getAttributedText(staticText: .species,
                                                        modelText: model.species)
        genderLabel.attributedText = getAttributedText(staticText: .gender,
                                                       modelText: model.gender.text)
        episodesLabel.attributedText = getAttributedText(staticText: .episodes,
                                                         modelText: listOfEpisodes(model: model))
        lastLocationLabel.attributedText = getAttributedText(staticText: .lastKnownLocation,
                                                             modelText: model.location.name)
        
        fetchImage(with: model)
    }
    
    func fetchImage(with model: CharacterModel) {
        guard let url = URL(string: model.image) else {
            debugPrint("Bad URL")
            return
        }
        
        ImageLoaderService.shared.downloadImage(url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                }
            case .failure(let failure):
                debugPrint(failure.localizedDescription)
                break
            }
        }
    }
}
