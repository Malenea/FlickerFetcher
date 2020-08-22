//
//  ActionButton.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class ActionButton: UIView {

    // Completion
    var tappedOn: Style.emptyAction?

    // Components
    private lazy var imageView = makeImageView()

    // Control variables
    private let image: UIImage?

    init(frame: CGRect = .zero, image: UIImage?) {
        self.image = image

        super.init(frame: frame)

        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        self.image = nil

        super.init(coder: coder)

        setupUI()
        setupGesture()
    }

}

private extension ActionButton {

    func setupUI() {
        prepareSubviewsForAutolayout(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc func tappedOnButton(_ sender: UILongPressGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            switch sender.state {
            case .began:
                self?.scale(with: Style.shortAnimationDuration, withScale: Style.shrinkScale)
            default:
                self?.scale(with: Style.shortAnimationDuration, withScale: Style.expandScale)
                self?.tappedOn?()
            }
        }
    }

    func setupGesture() {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tappedOnButton))
        pressGesture.minimumPressDuration = 0.0
        addGestureRecognizer(pressGesture)
    }

}

private extension ActionButton {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }

}
