//
//  InfoView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 21/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class InfoView: UIView {

    // Components
    var comments: [PhotoComment] = [] {
        didSet {
            if comments.isEmpty {
                let commentView = CommentView()
                commentView.name = "".htmlAttributedString()
                commentView.comment = "No comments found for this photo".htmlAttributedString().with(font: Style.normalSemiBoldFont)
                stackView.addArrangedSubview(commentView)
            } else {
                for comment in comments {
                    let commentView = CommentView()
                    commentView.name = comment.author.htmlAttributedString().with(font: Style.normalSemiBoldFont)
                    commentView.comment = comment.comment.htmlAttributedString().with(font: Style.normalFont)
                    stackView.addArrangedSubview(commentView)
                }
            }
        }
    }

    // Control variables
    private lazy var titleLabel = makeTitleLabel()
    private lazy var containerView = makeContainerView()
    private lazy var stackView = makeStackView()

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

private extension InfoView {

    func setupUI() {
        blurView()

        prepareSubviewsForAutolayout(titleLabel, containerView)
        containerView.prepareSubviewsForAutolayout(stackView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Style.hugePadding),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.hugePadding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Style.defaultPadding),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -(Style.defaultPadding * 2.0))
        ])
    }

}

private extension InfoView {

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .offWhite
        label.textAlignment = .center
        label.font = Style.subtitleFont
        label.text = "Comments"
        return label
    }

    func makeContainerView() -> UIScrollView {
        let view = UIScrollView()
        return view
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = Style.bigPadding
        return stackView
    }

}
