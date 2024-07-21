//
//  CharacterSearchController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 20.07.2024.
//

import UIKit
import OSLog

protocol SearchControllerProtocol: AnyObject {
    var isFiltering: Bool { get }
    var filteredCharacters: [CharacterModel] { get }
}

protocol SearchResultsUpdateDelegate: AnyObject {
    func updateSearchResults()
}

final class CharacterSearchController: UISearchController, SearchControllerProtocol {
    
    // MARK: Properties
    private let charactersLoader: CharactersLoadable
    
    private(set) var filteredCharacters: [CharacterModel] = []
    weak var searchResultsUpdateDelegate: SearchResultsUpdateDelegate?

    private var isSearchBarEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return isActive && !isSearchBarEmpty
    }
    
    // MARK: Init
    init(charactersLoader: CharactersLoadable) {
        self.charactersLoader = charactersLoader
        super.init(searchResultsController: nil)
        setupSearchController()
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupSearchController() {
        searchResultsUpdater = self
        searchBar.delegate = self
    }
    
    private func setupAppearance() {
        searchBar.searchTextField.leftView?.tintColor = AppColorEnum.text.color
        searchBar.tintColor = AppColorEnum.text.color
        
        let searchTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.IBMPlexSans(size: 14)
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchTextAttributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: AppColorEnum.text.color]
        )
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredCharacters = []
            searchResultsUpdateDelegate?.updateSearchResults()
            return
        }

        charactersLoader.fetchSearchableCharacters(name: searchText) { [weak self] characters in
            self?.filteredCharacters = characters
            self?.searchResultsUpdateDelegate?.updateSearchResults()
        }
    }
}

// MARK: - UISearchBarDelegate
extension CharacterSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Search"
    }
}
