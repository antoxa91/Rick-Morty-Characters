//
//  NetworkErrorView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import UIKit

protocol NetworkErrorViewDelegate: AnyObject {
    func retryButtonTapped()
}

final class NetworkErrorView: UIView {
    private enum ConstraintConstants {
        static let imageTop: CGFloat = 120
        static let imageHeight: CGFloat = 263
        
        static let networkErrorLabelTop: CGFloat = 35
        static let errorDescriptionLabelTop: CGFloat = 10
        static let retryButtonTop: CGFloat = 10
        
        static let buttonHeight: CGFloat = 42
        static let buttonWidth: CGFloat = 220

    }
    
    weak var delegate: NetworkErrorViewDelegate?
    
    // MARK: Private UI Properties
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .networkError)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var networkErrorLabel = BaseLabel(font: .IBMPlexSans(fontType: .bold, size: 28),
                                                   textAlignment: .center,
                                                   text: "Network Error")
    private lazy var errorDescriptionLabel = BaseLabel(font: .IBMPlexSans(size: 16),
                                                       textAlignment: .center,
                                                       text: "There was an error connecting.\nPlease check your internet",
                                                       textColor: AppColorEnum.gray.color)
    
    private lazy var retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = AppColorEnum.turquoise.color
        btn.layer.cornerRadius = 16
        btn.setTitle("Retry", for: .normal)
        btn.setTitleColor(AppColorEnum.text.color, for: .normal)
        btn.titleLabel?.font = .IBMPlexSans(fontType: .semiBold, size: 18)
        btn.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        backgroundColor = AppColorEnum.appBackground.color
        addSubviews(errorImageView, retryButton, networkErrorLabel, errorDescriptionLabel)
    }
    
    @objc private func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: ConstraintConstants.imageTop),
            errorImageView.heightAnchor.constraint(equalToConstant: ConstraintConstants.imageHeight),
            errorImageView.widthAnchor.constraint(equalTo: heightAnchor),
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            networkErrorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            networkErrorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor,
                                                   constant: ConstraintConstants.networkErrorLabelTop),
            
            errorDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorDescriptionLabel.topAnchor.constraint(equalTo: networkErrorLabel.bottomAnchor,
                                                       constant: ConstraintConstants.errorDescriptionLabelTop),
            
            retryButton.topAnchor.constraint(equalTo: errorDescriptionLabel.bottomAnchor,
                                             constant: ConstraintConstants.retryButtonTop),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: ConstraintConstants.buttonWidth),
            retryButton.heightAnchor.constraint(equalToConstant: ConstraintConstants.buttonHeight)
        ])
    }
}
