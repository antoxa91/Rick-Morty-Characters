//
//  SearchView.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    var isFiltering: Bool { get }
    var filteredCharacters: [CharacterModel] { get }
}

protocol SearchResultsUpdateDelegate: AnyObject {
    func updateSearchResults()
}

final class SearchView: UIView, SearchViewProtocol {
    private enum Constraints {
        static let searchTextFieldLeading: CGFloat = 25
        static let searchTextFieldTrailing: CGFloat = -16
        static let filterButtonHeightMultiplier: CGFloat = 0.5
        static let filterButtonWidthMultiplier: CGFloat = 0.5
        static let filterButtonTrailing: CGFloat = -16
    }
    
    // MARK: Properties
    private let charactersLoader: CharactersLoadable
    
    private(set) var filteredCharacters: [CharacterModel] = []
    weak var delegate: SearchResultsUpdateDelegate?
    
    private var isSearchBarEmpty: Bool {
        guard let text = searchTextField.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    
    // MARK: Private UI Properties
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.filtersIcon, for: .normal)
        button.tintColor = AppColorEnum.text.color
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchTextField: SearchTextField = {
        let textField = SearchTextField()
        textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return textField
    }()
    
    // MARK: Init
    init(charactersLoader: CharactersLoadable) {
        self.charactersLoader = charactersLoader
        super.init(frame: .zero)
        setupView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupView() {
        backgroundColor = AppColorEnum.appBackground.color
        addSubviews(searchTextField, filterButton)
        searchTextField.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            filteredCharacters = []
            delegate?.updateSearchResults()
            return
        }
        
        charactersLoader.fetchSearchableCharacters(name: searchText) { [weak self] characters in
            self?.filteredCharacters = characters
            self?.delegate?.updateSearchResults()
        }
    }
    
    ///TODO - realize
    @objc private func filterButtonTapped() {
        print(#function)
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: Constraints.searchTextFieldLeading),
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor,
                                                      constant: Constraints.searchTextFieldTrailing),
            
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterButton.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: Constraints.filterButtonHeightMultiplier),
            filterButton.widthAnchor.constraint(equalTo: heightAnchor,
                                                multiplier: Constraints.filterButtonWidthMultiplier),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: Constraints.filterButtonTrailing)
        ])
    }
}

// MARK: UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.placeholder = "Search"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
