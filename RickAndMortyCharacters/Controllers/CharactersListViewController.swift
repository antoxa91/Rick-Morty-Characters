//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit
import OSLog

final class CharactersListViewController: UIViewController {
    
    // MARK: Private Properties
    private let charactersLoader: CharactersLoadable
    
    // MARK: Private UI Properties
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppColorEnum.appBackground.color
        tableView.register(CharactersTableViewCell.self,
                           forCellReuseIdentifier: CharactersTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView(charactersLoader: charactersLoader)
        searchView.delegate = self
        return searchView
    }()
    
    // MARK: Init
    init(charactersLoader: CharactersLoadable) {
        self.charactersLoader = charactersLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        downloadInitialCharacters()
        NotificationCenter.default.addObserver(self, selector: #selector(noInternetConnection(notification:)), name: .networkStatusChanged, object: nil)
    }
    
    // MARK: Setup
    private func setupView() {
        title = "Rick & Morty Characters"
        navigationItem.backButtonDisplayMode = .minimal
        view.addSubviews(charactersTableView, searchView)
    }
    
    // MARK: Private Methods
    private func downloadInitialCharacters() {
        charactersLoader.fetchInitialCharacters {[weak self] in
            self?.charactersTableView.reloadData()
        }
    }
    
    private func downloadAdditionalCharacters() {
        charactersLoader.fetchAdditionalCharacters() { [weak self] indexPathsToAdd in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.charactersTableView.performBatchUpdates {
                    self.charactersTableView.insertRows(at: indexPathsToAdd, with: .fade)
                }
            }
        }
    }
    
    @objc private func noInternetConnection(notification: Notification) {
        if !NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async {
                let vc = NetworkErrorViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 40),
            
            charactersTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 8),
            charactersTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchView.isFiltering ?
        searchView.filteredCharacters.count : charactersLoader.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier, for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }
        
        let character = searchView.isFiltering ?
        searchView.filteredCharacters[indexPath.row] : charactersLoader.characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = searchView.isFiltering ?
        searchView.filteredCharacters[indexPath.row] : charactersLoader.characters[indexPath.row]
        
        let vc = CharacterProfileViewController(character: character)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/4
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = FooterLoaderView()
        !searchView.isFiltering ? footer.startAnimating() : footer.stopAnimating()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}

// MARK: - UIScrollViewDelegate
extension CharactersListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard charactersLoader.isShouldLoadMore,
              !charactersLoader.isLoadingMoreCharacters,
              !charactersLoader.characters.isEmpty,
              !searchView.isFiltering else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.downloadAdditionalCharacters()
            }
            timer.invalidate()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - CharacterSearchControllerDelegate
extension CharactersListViewController: SearchResultsUpdateDelegate {
    func updateSearchResults() {
        DispatchQueue.main.async {
            self.charactersTableView.reloadData()
        }
    }
}
