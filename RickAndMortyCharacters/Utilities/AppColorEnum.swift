//
//  AppColorEnum.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 17.07.2024.
//

import UIKit

enum AppColorEnum {
    case appBackground
    case cellBackground
    case text
    
    case red
    case green
    case gray
    case turquoise
    
    var color: UIColor {
        switch self {
        case .appBackground:
            return UIColor(hex: 0x000000)
        case .cellBackground:
            return UIColor(hex: 0x151517)
        case .text:
            return UIColor(hex: 0xFFFFFF)
        case .red:
            return UIColor(hex: 0xD62300)
        case .green:
            return UIColor(hex: 0x198737)
        case .gray:
            return UIColor(hex: 0x686874)
        case .turquoise:
            return UIColor(hex: 0x42B4CA)
        }
    }
}
