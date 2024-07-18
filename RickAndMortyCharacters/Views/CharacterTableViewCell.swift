//
//  CharacterTableViewCell.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigirationModel
    func configure(with model: ConfigirationModel)
    func fetchImage(with model: ConfigirationModel)
}

final class CharactersTableViewCell: UITableViewCell {
    static let identifier = String(describing: CharactersTableViewCell.self)
    
    // MARK: Private UI Properties
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColorEnum.gray.color
        return imageView
    }()
    
    private lazy var nameLabel = BaseLabel(font: .IBMPlexSans(fontType: .semiBold, size: 18))
    private lazy var statusAndSpeciesLabel = BaseLabel()
    private lazy var genderLabel = BaseLabel()
    
    private lazy var vInfoStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(statusAndSpeciesLabel)
        vStack.addArrangedSubview(genderLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        contentView.backgroundColor = AppColorEnum.cellBackground.color
        contentView.addSubviews(characterImageView, vInfoStackView)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = AppColorEnum.appBackground.color.cgColor
        contentView.layer.cornerRadius = 25
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        statusAndSpeciesLabel.text = nil
        genderLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = AppColorEnum.gray.color
        } else {
            contentView.backgroundColor = AppColorEnum.cellBackground.color
        }
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        characterImageView.layer.cornerRadius = 8
    }
    
    ///FIXME - сделать размеры картинки адаптивными под размер экрана
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            characterImageView.widthAnchor.constraint(equalToConstant: 84),
            characterImageView.heightAnchor.constraint(equalToConstant: 64),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            vInfoStackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            vInfoStackView.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            vInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vInfoStackView.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor)
        ])
    }
}

// MARK: - ConfigurableViewProtocol
extension CharactersTableViewCell: ConfigurableViewProtocol {
    typealias ConfigirationModel = CharacterModel
    
    func configure(with model: CharacterModel) {
        nameLabel.text = model.name
        genderLabel.text = model.gender.text
        statusAndSpeciesLabel.setAttributedText(leadingText: model.status.text,
                                                leadingColor: model.status.color,
                                                trailingText: " • " + model.species)
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
                let thumbnailSize = CGSize(width: 150, height: 150)
                image?.prepareThumbnail(of: thumbnailSize) { [weak self] preparedImage in
                    DispatchQueue.main.async {
                        self?.characterImageView.image = preparedImage
                    }
                }
            case .failure(let failure):
                debugPrint(failure.localizedDescription)
                break
            }
        }
    }
}
