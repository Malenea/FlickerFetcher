//
//  ArtistsInfoView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class ArtistsInfoView: UIView {

    // Items
    private var imageURL: String
    private var image: UIImage?
    private var title: String

    // Components
    private lazy var imageView = makeImageView()
    private lazy var titleLabel = makeTitleLabel()

    // Life cycle
    init(frame: CGRect = .zero, title: String, imageURL: String) {
        self.imageURL = imageURL
        self.title = title

        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        self.imageURL = ""
        self.title = ""

        super.init(coder: coder)

        setupUI()
    }

}

extension ArtistsInfoView {

    func update(title: String, imageURL: String) {
        guard self.title != title, self.imageURL != imageURL else { return }

        self.title = title
        self.imageURL = imageURL
        titleLabel.text = title
        imageView.download(from: imageURL)
    }

}

private extension ArtistsInfoView {

    func setupUI() {
        prepareSubviewsForAutolayout(imageView, titleLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.defaultPadding),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image?.scale ?? 1.0),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.trailingAnchor, constant: Style.defaultPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Style.defaultPadding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

private extension ArtistsInfoView {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.roundView(with: Style.bigPadding)
        imageView.contentMode = .scaleAspectFit
        imageView.download(from: imageURL)
        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .offWhite
        label.textAlignment = .center
        label.font = Style.subtitleFont
        label.text = title
        return label
    }

}
