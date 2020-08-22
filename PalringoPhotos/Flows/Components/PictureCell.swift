//
//  PictureCell.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class PictureCell: UICollectionViewCell {

    // Cell identifier
    static let identifier = "PictureCell"

    // Components
    private lazy var pictureView = makePictureView()
    private lazy var containerView = makeContainerView()
    private lazy var titleLabel = makeTitleLabel()

    // Control variables
    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }

    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            titleLabel.text = photo.name
            self.fetchTask = CachedRequest.request(url: photo.url) { [weak self] data, isCached in
                guard let data = data else { return }
                let newImage = UIImage(data: data)
                if isCached {
                    self?.pictureView.imageView.image = newImage
                } else if self?.photo == photo {
                    self?.pictureView.image = newImage
                }
            }
        }
    }

    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pictureView.imageView.image =  nil
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.charcoalGray.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }

}

private extension PictureCell {

    func setupUI() {
        backgroundColor = .charcoalGray

        contentView.prepareSubviewsForAutolayout(pictureView, containerView)
        containerView.prepareSubviewsForAutolayout(titleLabel)
        contentView.applyFullConstraints(to: pictureView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.defaultPadding),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Style.defaultPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: Style.defaultPadding)
        ])
    }

}

private extension PictureCell {

    func makePictureView() -> PictureView {
        let pictureView = PictureView()
        pictureView.clipsToBounds = true
        return pictureView
    }

    func makeContainerView() -> UIView {
        let view = UIView()
        return view
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .offWhite
        label.textAlignment = .center
        label.font = Style.subtitleFont
        return label
    }

}
