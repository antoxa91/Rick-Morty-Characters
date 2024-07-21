//
//  FiltersViewNavigationStack.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

final class FiltersViewNavigationStack: UIStackView {
    // MARK: Private UI Properties
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = AppColorEnum.text.color
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .IBMPlexSans(size: 14)
        button.tintColor = AppColorEnum.text.color
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
            let label = UILabel()
        label.text = "Filters"
        label.textColor = AppColorEnum.text.color
        label.font = .IBMPlexSans(fontType: .bold, size: 20)
        return label
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        addArrangedSubview(dismissButton)
        addArrangedSubview(titleLabel)
        addArrangedSubview(resetButton)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Action
    @objc private func dismissButtonTapped() {
        print(#function)
        // delegate  self.dismiss(animated: true)
    }
    
    @objc private func resetButtonTapped() {
        print(#function)
        // self.reset(animated: true)
    }
}
