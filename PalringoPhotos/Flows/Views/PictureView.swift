//
//  PictureView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class PictureView: UIView {

    // Components
    private(set) lazy var imageView = makeImageView()
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self.imageView, duration: Style.defaultAnimationDuration, options: .transitionFlipFromTop, animations: {
                    self.imageView.image = self.image
                })
            }
        }
    }

    // Life cycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

}

private extension PictureView {

    func setupUI() {
        prepareSubviewsForAutolayout(imageView)
        applyFullConstraints(to: imageView)
    }

}

private extension PictureView {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }

}
