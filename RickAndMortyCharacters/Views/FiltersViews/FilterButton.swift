//
//  FilterButton.swift
//  RickAndMortyCharacters
//
//  Created by Антон Стафеев on 22.07.2024.
//

import UIKit

final class FilterButton: UIButton {
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.setup(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
            animateButtonTap()
        }
    }
    
    private func setup(title: String) {
        heightAnchor.constraint(equalToConstant: 36).isActive = true
        setTitleColor(AppColorEnum.text.color, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = .IBMPlexSans()
        layer.cornerRadius = 14
        layer.borderColor = AppColorEnum.cellBackground.color.cgColor
        layer.borderWidth = 3
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = AppColorEnum.text.color
            setTitleColor(AppColorEnum.appBackground.color, for: .normal)
            setTitle("\(self.title(for: .normal) ?? "") ✓", for: .normal)
        } else {
            backgroundColor = AppColorEnum.appBackground.color
            setTitleColor(AppColorEnum.text.color, for: .normal)
            setTitle(self.title(for: .normal)?.replacingOccurrences(of: " ✓", with: ""), for: .normal)
        }
    }
    
    private func animateButtonTap() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.transform = .init(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            self.transform = .identity
        }

        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
}
