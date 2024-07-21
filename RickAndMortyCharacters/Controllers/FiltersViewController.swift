//
//  FiltersViewController.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

final class FiltersViewController: UIViewController {
    private lazy var filtersView = FiltersView()
    
    override func loadView() {
        self.view = filtersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {

    }
}
