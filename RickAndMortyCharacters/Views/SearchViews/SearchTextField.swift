//
//  SearchTextField.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 21.07.2024.
//

import UIKit

final class SearchTextField: UITextField {
    private lazy var searchIconView = SearchIconView(image: .searchIcon,
                                                     frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let placeholderAttributes = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: AppColorEnum.text.color]
        )
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.IBMPlexSans(size: 14)
        ]
        
        attributedPlaceholder = placeholderAttributes
        defaultTextAttributes = textAttributes
        
        backgroundColor = AppColorEnum.appBackground.color
        layer.borderColor = AppColorEnum.gray.color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
        
        leftView = searchIconView
        leftViewMode = .always
        translatesAutoresizingMaskIntoConstraints = false
        
        returnKeyType = .search
    }
}
