//
//  FilterTypeView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

protocol ResetFilterSettings: AnyObject {
    func reset()
}

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
    
    // MARK: Private Properties
    private var selectedButton: FilterButton?
    
    var selectedOption: String? {
        return selectedButton?.titleLabel?.text?.replacingOccurrences(of: " ✓", with: "")
    }
    
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
            let btn = FilterButton(frame: .zero, title: option.rawValue.capitalized)
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }
        
        return stack
    }
    
    @objc private func buttonTapped(_ sender: FilterButton) {
        selectedButton?.isSelected = false
        sender.isSelected.toggle()
        selectedButton = sender.isSelected ? sender : nil
    }
    
//    @objc private func buttonTapped(_ sender: FilterButton) {
//        if let selectedButton, selectedButton != sender {
//            selectedButton.isSelected = false
//        }
//        
//        sender.isSelected.toggle()
//        selectedButton = sender
//    }
//    
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

// MARK: ResetFilterSettings
extension FilterTypeView: ResetFilterSettings {
    func reset() {
          selectedButton = nil
           for view in filterButtonStack.arrangedSubviews {
               if let button = view as? FilterButton {
                   button.isSelected = false
               }
           }
      }
}
