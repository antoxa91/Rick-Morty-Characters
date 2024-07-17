//
//  ViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

final class CharactersViewController: UIViewController {
    
    // MARK: Private Properties
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.backgroundColor = AppColorEnum.appBackground.color
        tableView.register(CharactersTableViewCell.self,
                           forCellReuseIdentifier: CharactersTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var characters: [CharacterModel] = []
    
    private let networkService: NetworkServiceProtocol
    
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
        downloadCharacters()
    }
    
    // MARK: Private Methods
    private func setupView() {
        title = "Rick & Morty Characters"
        view.addSubview(charactersTableView)
    }
    
    private func downloadCharacters() {
        networkService.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
                DispatchQueue.main.async {
                    self.charactersTableView.reloadData()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier, for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
}


// MARK: - UITableViewDelegate
extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CharacterDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/4
    }
}
