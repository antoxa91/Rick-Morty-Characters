//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

protocol AlertDisplaying: AnyObject {
    func showErrorAlert(with message: NetworkError)
}

final class CharactersListViewController: UIViewController {
    
    // MARK: Private Properties
    private var characters: [CharacterModel] = []
    private let networkService: NetworkServiceProtocol
    
    // MARK: Private UI Properties
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppColorEnum.appBackground.color
        tableView.register(CharactersTableViewCell.self,
                           forCellReuseIdentifier: CharactersTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .systemBlue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        downloadCharacters()
    }
    
    // MARK: Private Methods
    private func setupView() {
        title = "Rick & Morty Characters"
        navigationItem.backButtonDisplayMode = .minimal
        view.addSubviews(charactersTableView, spinner)
        spinner.startAnimating()
    }
    
    private func downloadCharacters() {
        networkService.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.charactersTableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            case .failure(let failure):
                AlertManager.showErrorAlert(self ?? UIViewController(), message: failure)
                break
            }
        }
    }
    
    // MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            charactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: charactersTableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: charactersTableView.centerYAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource
extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier, for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character)
        cell.alertDelegate = self
        return cell
    }
}


// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        let vc = CharacterProfileViewController(character: character)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/4
    }
}

// MARK: - AlertDisplaying
extension CharactersListViewController: AlertDisplaying {
    func showErrorAlert(with message: NetworkError) {
        AlertManager.showErrorAlert(self, message: message)
    }
}
