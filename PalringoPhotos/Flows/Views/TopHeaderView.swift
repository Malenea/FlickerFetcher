//
//  TopHeaderView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class TopHeaderView: UIView {

    // Coordinator and view model
    private var viewModel: TopHeaderViewModel

    // Completion
    public var changedPhotographer: Style.photographerAction?

    // Items
    private var currentPhotographer: Photographer?

    // Components
    private lazy var topContainerView = makeTopContainerView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var separatorView = makeSeparatorView()
    private lazy var artistInfoView = makeArtistInfoView()
    private lazy var arrowDownImageView = makeArrowDownImageView()
    private lazy var containerScrollView = makeContainerScrollView()
    private lazy var stackView = makeStackView()

    // Life cycle
    init(frame: CGRect = .zero, viewModel: TopHeaderViewModel) {
        self.viewModel = viewModel
        self.currentPhotographer = viewModel.photographers.first

        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        self.viewModel = TopHeaderViewModel(photographers: [])
        self.currentPhotographer = nil

        super.init(coder: coder)

        setupUI()
    }

}

extension TopHeaderView {

    func change(_ isExpanding: Bool) {
        switch isExpanding {
        case true:
            artistInfoView.fadeOut()
            containerScrollView.fadeIn()
            arrowDownImageView.rotate180()
        case false:
            artistInfoView.fadeIn()
            containerScrollView.fadeOut()
            arrowDownImageView.resetTransform()
        }
    }

}

private extension TopHeaderView {

    func setupUI() {
        blurView()

        prepareSubviewsForAutolayout(topContainerView, containerScrollView)
        topContainerView.prepareSubviewsForAutolayout(artistInfoView, arrowDownImageView)
        containerScrollView.prepareSubviewsForAutolayout(titleLabel, separatorView, stackView)

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: Style.topHeaderHeight),

            arrowDownImageView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -Style.defaultPadding),
            arrowDownImageView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            arrowDownImageView.heightAnchor.constraint(equalToConstant: Style.horizontalArrowHeight),
            arrowDownImageView.widthAnchor.constraint(equalToConstant: Style.horizontalArrowWidth),

            artistInfoView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: Style.defaultPadding),
            artistInfoView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: Style.defaultPadding),
            artistInfoView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: Style.defaultPadding),
            artistInfoView.bottomAnchor.constraint(equalTo: arrowDownImageView.topAnchor, constant: -Style.defaultPadding),

            containerScrollView.topAnchor.constraint(equalTo: topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.topAnchor, constant: Style.bigPadding),
            titleLabel.centerXAnchor.constraint(equalTo: containerScrollView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: containerScrollView.widthAnchor, constant: -Style.defaultPadding),

            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.bigPadding),
            separatorView.heightAnchor.constraint(equalToConstant: Style.defaultHeight),
            separatorView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            separatorView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Style.hugePadding),
            stackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor)
        ])
    }

}

private extension TopHeaderView {

    func makeTopContainerView() -> UIView {
        let view = UIView()
        return view
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .offWhite
        label.textAlignment = .center
        label.font = Style.titleFont
        label.text = "Choose a photographer"
        return label
    }

    func makeSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .offWhite
        return separator
    }

    func makeArtistInfoView() -> ArtistsInfoView {
        guard let currentPhotographer = currentPhotographer else { return ArtistsInfoView(title: "", imageURL: "") }
        let view = ArtistsInfoView(title: currentPhotographer.photographer.displayName, imageURL: currentPhotographer.photographer.imageURL)
        return view
    }

    func makeArrowDownImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrowDown")?.tinted(with: .offWhite)
        return imageView
    }

    func makeContainerScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.fadeOut(with: .zero)
        return scrollView
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()

        viewModel.photographers.forEach {
            let choiceButton = ChoiceButton(photographer: $0)
            choiceButton.tappedOn = { [weak self] photographer in
                guard let photographer = photographer else { return }

                for case let choiceButton as ChoiceButton in stackView.arrangedSubviews {
                    choiceButton.isSelected = false
                    if photographer.photographer == choiceButton.photographer.photographer {
                        choiceButton.isSelected = true
                    }
                }
                self?.currentPhotographer = photographer
                self?.artistInfoView.update(title: photographer.photographer.displayName, imageURL: photographer.photographer.imageURL)

                self?.changedPhotographer?(photographer)
            }
            if let currentPhotographer = currentPhotographer, $0.photographer == currentPhotographer.photographer {
                choiceButton.isSelected = true
            }
            stackView.addArrangedSubview(choiceButton)
        }

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Style.hugePadding
        return stackView
    }

}
