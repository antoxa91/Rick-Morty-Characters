//
//  BaseLabel.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//

import UIKit

final class BaseLabel: UILabel {
    
    init(font: UIFont = .IBMPlexSans(),
         textAlignment: NSTextAlignment = .left,
         cornerRadius: CGFloat = 0,
         clipsToBounds: Bool = false
    ) {
        super.init(frame: .zero)
        
        self.font = font
        self.textAlignment = textAlignment
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
        setupDefaultStyle()
    }
     
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefaultStyle() {     
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textColor = AppColorEnum.text.color
    }
}
