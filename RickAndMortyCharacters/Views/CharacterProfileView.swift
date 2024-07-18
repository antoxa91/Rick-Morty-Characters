//
//  CharacterProfileView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

enum StaticTextForInfo: String {
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
    
    private lazy var speciesLabelForModel = UILabel()
    private lazy var speciesHStack = getInfoForLabel(staticText: .species, labelForModel: speciesLabelForModel)
    
    private lazy var genderLabelForModel = UILabel()
    private lazy var genderHStack = getInfoForLabel(staticText: .gender, labelForModel: genderLabelForModel)
    
    private lazy var episodesLabelForModel = UILabel()
    private lazy var episodesHStack = getInfoForLabel(staticText: .episodes, labelForModel: episodesLabelForModel)
    
    
    private lazy var lastLocationLabelForModel = UILabel()
    private lazy var lastLocationHStack = getInfoForLabel(staticText: .lastKnownLocation, labelForModel: lastLocationLabelForModel)
    
    private lazy var vInfoStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.addArrangedSubview(speciesHStack)
        vStack.addArrangedSubview(genderHStack)
        vStack.addArrangedSubview(episodesHStack)
        vStack.addArrangedSubview(lastLocationHStack)
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
    
    /// FIXME - исправить абзац у текста
    func getInfoForLabel(staticText: StaticTextForInfo, labelForModel: UILabel) -> UIStackView {
        let staticLabel = UILabel()
        staticLabel.textColor = AppColorEnum.text.color
        staticLabel.font = .IBMPlexSans(fontType: .semiBold, size: 16)
        staticLabel.text = "\(staticText.rawValue): "

        labelForModel.textColor = AppColorEnum.text.color
        labelForModel.font = .IBMPlexSans(fontType: .regular, size: 16)
        labelForModel.numberOfLines = 0
        
        var hStack: UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .top
            stack.distribution = .fill
            stack.addArrangedSubview(staticLabel)
            stack.addArrangedSubview(labelForModel)
            return stack
        }
        
        return hStack
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
            characterImageView.heightAnchor.constraint(equalToConstant: 320),
            
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
        speciesLabelForModel.text = model.species
        genderLabelForModel.text = model.gender.text
        
        episodesLabelForModel.text = listOfEpisodes(model: model)
        lastLocationLabelForModel.text = model.location.name
        fetchImage(with: model)
    }
    
    private func listOfEpisodes(model: CharacterModel) -> String {
        model.episode.compactMap { $0.split(separator: "/")
                .last
            .map { String($0)}}
        .joined(separator: ", ")
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
