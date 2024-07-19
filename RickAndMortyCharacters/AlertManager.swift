//
//  AlertManager.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 19.07.2024.
//

import UIKit

///TODO: - может не нужен и заменить логами?
final class AlertManager {
    static func showErrorAlert(_ vc: UIViewController,
                               title: String = "Ошибка",
                               message: NetworkError,
                               actionTitle: String = "OK"
    ) {
        let ac = UIAlertController(title: title, message: message.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default))
        
        DispatchQueue.main.async {
            vc.present(ac, animated: true, completion: nil)
        }
    }
}
