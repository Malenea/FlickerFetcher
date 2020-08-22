//
//  CommentView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class CommentView: UIView {

    // Components
    private lazy var backgroundLabelView = makeBackgroundLabelView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var commentLabel = makeCommentLabel()

    // Control variables
    var name: NSAttributedString? {
        didSet {
            titleLabel.attributedText = name
        }
    }
    var comment: NSAttributedString? {
        didSet {
            commentLabel.attributedText = comment
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

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundLabelView.bounds
        gradientLayer.colors = [UIColor.offWhite.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        backgroundLabelView.layer.insertSublayer(gradientLayer, at: 0)
    }

}

private extension CommentView {

    func setupUI() {
        roundView(with: Style.defaultPadding)
        blurView(isLight: true)

        prepareSubviewsForAutolayout(backgroundLabelView, titleLabel, commentLabel)
        NSLayoutConstraint.activate([
            backgroundLabelView.topAnchor.constraint(equalTo: topAnchor, constant: Style.defaultPadding),
            backgroundLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundLabelView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Style.defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.defaultPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.defaultPadding),

            commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.bigPadding),
            commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.defaultPadding),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.defaultPadding),
            commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.defaultPadding)
        ])
    }

}

private extension CommentView {

    func makeBackgroundLabelView() -> UIView {
        let view = UIView()
        return view
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        return label
    }

    func makeCommentLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }

}
