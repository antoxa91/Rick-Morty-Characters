//
//  UIView + Extension.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
