//
//  UILabel + Extension.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 18.07.2024.
//


import UIKit

extension UILabel {
    func setAttributedText(
        leadingText: String,
        leadingFont: UIFont = UIFont.IBMPlexSans(fontType: .bold),
        leadingColor: UIColor,
        trailingText: String,
        trailingFont: UIFont = UIFont.IBMPlexSans(fontType: .bold),
        trailingColor: UIColor = AppColorEnum.text.color
    ) {
        let attributedString = NSMutableAttributedString(
            string: leadingText,
            attributes: [
                .font: leadingFont,
                .foregroundColor: leadingColor
            ]
        )
        
        let trailingAttributes: [NSAttributedString.Key: Any] = [
            .font: trailingFont,
            .foregroundColor: trailingColor
        ]
        
        attributedString.append(NSAttributedString(string: trailingText, attributes: trailingAttributes))
        
        self.attributedText = attributedString
    }
    
    func setAttributedText(
        leadingText: CharacterInfoLabel,
        leadingFont: UIFont = UIFont.IBMPlexSans(fontType: .bold, size: 16),
        leadingColor: UIColor = AppColorEnum.text.color,
        trailingText: String,
        trailingFont: UIFont = UIFont.IBMPlexSans(fontType: .regular, size: 16),
        trailingColor: UIColor = AppColorEnum.text.color
    ) {
        let attributedString = NSMutableAttributedString(
            string: leadingText.rawValue,
            attributes: [
                .font: leadingFont,
                .foregroundColor: leadingColor
            ]
        )
        
        let trailingAttributes: [NSAttributedString.Key: Any] = [
            .font: trailingFont,
            .foregroundColor: trailingColor
        ]
        
        attributedString.append(NSAttributedString(string: trailingText, attributes: trailingAttributes))
        
        self.attributedText = attributedString
    }
}
