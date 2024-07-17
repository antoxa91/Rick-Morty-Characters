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
}


final class CharactersTableViewCell: UITableViewCell {
    static let identifier = String(describing: CharactersTableViewCell.self)

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
    
    /// FIXME: - лейблы очень похожие может вынести в отдельный класс или расширение
    /// Проверить шрифты на соответствие
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .IBMPlexSans(fontType: .bold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubviews(characterImageView, nameLabel, statusLabel, genderLabel, speciesLabel)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        genderLabel.text = nil
        speciesLabel.text = nil
    }
    
    
    // MARK: Layout
    override func layoutSubviews() {
        // скруглить картинку
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            characterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            statusLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            // dot
            
            speciesLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 8),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            
            genderLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            genderLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            genderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
