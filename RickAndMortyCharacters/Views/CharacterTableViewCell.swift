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
    
    /// FIXME: - лейблы очень похожие может вынести в отдельный класс или расширение
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .semiBold, size: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubviews(characterImageView, nameLabel, statusLabel, genderLabel, speciesLabel)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = AppColorEnum.appBackground.color.cgColor
        contentView.layer.cornerRadius = 25
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        genderLabel.text = nil
        speciesLabel.text = nil
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
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            statusLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            statusLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor, constant: 2),
            
            speciesLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 3),
            speciesLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor, constant: 2),
            
            genderLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            genderLabel.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor)
        ])
    }
}

// MARK: - ConfigurableViewProtocol
extension CharactersTableViewCell: ConfigurableViewProtocol {
    typealias ConfigirationModel = CharacterModel
    
    func configure(with model: CharacterModel) {
        nameLabel.text = model.name
        statusLabel.text = model.status.text
        statusLabel.textColor = model.status.color
        speciesLabel.text = "• " + model.species
        genderLabel.text = model.gender.text
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
