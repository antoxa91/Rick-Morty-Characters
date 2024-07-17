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
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .bold, size: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans()
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
        
        contentView.backgroundColor = AppColorEnum.cellBackground.color
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
    ///FIXME - сделать скругление адаптивным
    override func layoutSubviews() {
        characterImageView.layer.cornerRadius = 8
    }
    
    ///FIXME - сделать размеры картинки адаптивными под размер экрана
    ///высота всей ячейки 96
    private func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            characterImageView.widthAnchor.constraint(equalToConstant: 84),
            characterImageView.heightAnchor.constraint(equalToConstant: 64),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor),
            
            
            statusLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            statusLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            
            speciesLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 6),
            speciesLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),

            
            genderLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 15),
            genderLabel.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor)
        ])
    }
}
