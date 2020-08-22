//
//  ChoiceButton.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class ChoiceButton: UIView {

    // Completion
    public var tappedOn: Style.photographerAction?

    // Items
    let photographer: Photographer

    // Components
    private lazy var pulsatorView = makePulsatorView()
    private lazy var titleLabel = makeTitleLabel()

    // Control variables
    public var isSelected = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = self.isSelected ? .offWhite : .clear
                self.titleLabel.textColor = self.isSelected ? .charcoalGray : .offWhite
            }
        }
    }

    // Life cycle
    init(frame: CGRect = .zero, photographer: Photographer) {
        self.photographer = photographer

        super.init(frame: frame)

        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension ChoiceButton {

    func setupUI() {
        clipsToBounds = true

        prepareSubviewsForAutolayout(pulsatorView, titleLabel)
        NSLayoutConstraint.activate([
            pulsatorView.topAnchor.constraint(equalTo: topAnchor),
            pulsatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pulsatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pulsatorView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc func tappedOnView(_ sender: UITapGestureRecognizer) {
        guard !isSelected else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.titleLabel, duration: Style.defaultAnimationDuration, options: .transitionCrossDissolve, animations: {
                self.titleLabel.textColor = self.isSelected ? .offWhite : .charcoalGray
            })
        }
        pulsatorView.createPulsator(point: sender.location(in: self), width: frame.width, color: UIColor.offWhite.cgColor, isSolid: true) { [weak self] in
            self?.tappedOn?(self?.photographer)
        }
    }

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        addGestureRecognizer(tapGesture)
    }

}

private extension ChoiceButton {

    func makePulsatorView() -> UIView {
        let view = UIView()
        return view
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .offWhite
        label.textAlignment = .center
        label.font = Style.subtitleFont
        label.text = photographer.photographer.displayName
        return label
    }
}
