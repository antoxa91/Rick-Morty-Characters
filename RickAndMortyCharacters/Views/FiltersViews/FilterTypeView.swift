//
//  FilterTypeView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

final class FilterTypeView<T: RawRepresentable>: UIView where T.RawValue == String {
    // MARK: Private UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .IBMPlexSans(fontType: .semiBold, size: 14)
        label.textColor = AppColorEnum.text.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var filterButtonStack = UIStackView()
    
    // MARK: Init
    init(title: String, filterOptions: [T]) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.filterButtonStack = getButtonsStack(options: filterOptions)
        addSubviews(titleLabel, filterButtonStack)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helper Methods
    private func getButtonsStack(options: [T]) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 4
        options.enumerated().forEach { index, option in
            let btn = getBtn(title: option.rawValue.capitalized)
            btn.tag = index  // установить тег для кнопки
            stack.addArrangedSubview(btn)
        }
        
        return stack
    }
    
    ///TODO: - может отдельный класс для этих кнопок?
    private func getBtn(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.backgroundColor = AppColorEnum.appBackground.color
        btn.layer.cornerRadius = 24
        btn.setTitleColor(AppColorEnum.text.color, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .IBMPlexSans()
        btn.layer.borderColor = AppColorEnum.cellBackground.color.cgColor
        btn.layer.borderWidth = 2
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return btn
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            filterButtonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            filterButtonStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterButtonStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButtonStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


extension UIStackView {
    func getButtonsStack(options: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 4
        options.enumerated().forEach { index, option in
            let btn = getBtn(title: option.capitalized)
            btn.tag = index  // установить тег для кнопки
            stack.addArrangedSubview(btn)
        }
        
        return stack
    }
    
    private func getBtn(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.backgroundColor = AppColorEnum.appBackground.color
        btn.layer.cornerRadius = 24
        btn.setTitleColor(AppColorEnum.text.color, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .IBMPlexSans()
        btn.layer.borderColor = AppColorEnum.cellBackground.color.cgColor
        btn.layer.borderWidth = 2
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return btn
    }
}
