//
//  FiltersViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

protocol FiltersVCDelegate: AnyObject {
    func updateSearchResults()
    var filteredCharacters: [CharacterModel] { get }
    func resetConnectionType(to type: ConnectionType)
}

final class FiltersViewController: UIViewController {
    private let networkService: CharactersLoader
    
    private(set) var filteredCharacters: [CharacterModel] = []
    weak var delegate: FiltersVCDelegate?
    
    private enum ConstraintConsts {
        static let leadingAndTrailing: CGFloat = 20
        static let applyButtonHeight: CGFloat = 42
        static let navBarHeight: CGFloat = 26
        static let topAndBottom: CGFloat = 40
    }
    
    // MARK: Private UI Properties
    private lazy var navBarStackView: FiltersViewNavigationStack = {
        let navBarStackView = FiltersViewNavigationStack()
        navBarStackView.delegate = self
        return navBarStackView
    }()
    
    private lazy var statusFilterView = FilterTypeView(title: FilterParameters.status,
                                                       filterOptions: CharacterStatus.allCases)
    private lazy var genderFilterView = FilterTypeView(title: FilterParameters.gender,
                                                       filterOptions: CharacterGender.allCases)
    
    private lazy var vFilterTypesStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fillEqually
        vStack.addArrangedSubview(statusFilterView)
        vStack.addArrangedSubview(genderFilterView)
        return vStack
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(AppColorEnum.text.color, for: .normal)
        button.backgroundColor = AppColorEnum.turquoise.color
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vFinalStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillProportionally
        vStack.spacing = 20
        vStack.addArrangedSubview(navBarStackView)
        vStack.addArrangedSubview(vFilterTypesStack)
        vStack.addArrangedSubview(applyButton)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: Init
    init(networkService: CharactersLoader) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    // MARK: Setup
    private func setupViews() {
        view.backgroundColor = AppColorEnum.appBackground.color
        view.addSubview(vFinalStack)
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            vFinalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: ConstraintConsts.leadingAndTrailing),
            vFinalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -ConstraintConsts.leadingAndTrailing),
            vFinalStack.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: ConstraintConsts.topAndBottom/2),
            vFinalStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                constant: -ConstraintConsts.topAndBottom),
        ])
    }
    
    // MARK: Action
    @objc private func applyButtonTapped() {
        networkService.filterBy(name: nil, parameters: FilterParameters(
            status: statusFilterView.selectedOption,
            gender: genderFilterView.selectedOption)
        ) { [weak self] characters in
            self?.filteredCharacters = characters
            self?.delegate?.updateSearchResults()
            self?.delegate?.resetConnectionType(to: .filtering)
            self?.dismiss(animated: true)
        }
    }
}


// MARK: - FilterNavBarDelegate
extension FiltersViewController: FilterNavBarDelegate {
    func dismissFiltersViewController() {
        self.dismiss(animated: true)
    }
    
    func resetFilters() {
        statusFilterView.reset()
        genderFilterView.reset()
        delegate?.resetConnectionType(to: .default)
    }
}
