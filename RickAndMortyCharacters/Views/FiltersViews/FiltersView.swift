//
//  FiltersView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

final class FiltersView: UIView {
    private enum FilterTitle: String {
        case status = "Status"
        case gender = "Gender"
    }
    
    private enum ConstraintConsts {
        static let leadingAndTrailing: CGFloat = 20
        static let applyButtonHeight: CGFloat = 42
        static let navBarHeight: CGFloat = 26
        static let topAndBottom: CGFloat = 40
    }
    
    // MARK: Private UI Properties
    private lazy var navBarStackView = FiltersViewNavigationStack()
    private lazy var statusFilterView = FilterTypeView(title: FilterTitle.status.rawValue,
                                                       filterOptions: CharacterStatus.allCases)
    private lazy var genderFilterView = FilterTypeView(title: FilterTitle.gender.rawValue,
                                                       filterOptions: CharacterGender.allCases)
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(AppColorEnum.text.color, for: .normal)
        button.backgroundColor = AppColorEnum.turquoise.color
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var hFilterTypesStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fillProportionally
        vStack.spacing = 40
        vStack.addArrangedSubview(statusFilterView)
        vStack.addArrangedSubview(genderFilterView)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupViews() {
        backgroundColor = AppColorEnum.appBackground.color
        addSubviews(navBarStackView, applyButton, hFilterTypesStackView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            navBarStackView.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: ConstraintConsts.topAndBottom/2),
            navBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -ConstraintConsts.leadingAndTrailing),
            navBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: ConstraintConsts.leadingAndTrailing),
            navBarStackView.heightAnchor.constraint(equalToConstant: ConstraintConsts.navBarHeight),
            
            hFilterTypesStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                           constant: ConstraintConsts.leadingAndTrailing),
            hFilterTypesStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                            constant: -ConstraintConsts.leadingAndTrailing),
            hFilterTypesStackView.topAnchor.constraint(equalTo: navBarStackView.bottomAnchor,
                                                       constant: ConstraintConsts.topAndBottom),
            hFilterTypesStackView.bottomAnchor.constraint(equalTo: applyButton.topAnchor,
                                                          constant: -ConstraintConsts.topAndBottom),

            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -ConstraintConsts.topAndBottom),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -ConstraintConsts.leadingAndTrailing),
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: ConstraintConsts.leadingAndTrailing),
            applyButton.heightAnchor.constraint(equalToConstant: ConstraintConsts.applyButtonHeight)
        ])
    }
}
