//
//  PhotoDetailViewController.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 21/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDetailViewController: UIViewController {

    // Coordinator and model
    weak var coordinator: RootCoordinator?
    private var viewModel: PhotoDetailViewModel?

    // Components
    private lazy var backgroundImageView = makeBackgroundImageView()
    private lazy var backgroundBlurView = makeBackgroundBlurView()
    private lazy var loadingView = makeLoadingView()
    private lazy var imageView = makeImageView()
    private lazy var infoView = makeInfoView()
    private var infoViewLeadingConstraint: NSLayoutConstraint!
    private lazy var infoButton = makeInfoButton()
    private lazy var backButton = makeBackButton()

    // Control variables
    private var image: UIImage? {
        didSet {
            loadingView.stopAnimating()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self.backgroundImageView, duration: Style.defaultAnimationDuration, options: .transitionCrossDissolve, animations: {
                    self.backgroundImageView.image = self.image
                })
                UIView.transition(with: self.imageView, duration: Style.defaultAnimationDuration, options: .transitionFlipFromTop, animations: {
                    self.imageView.image = self.image
                })
            }
        }
    }
    private var isInfoExpanded: Bool = false {
        didSet {
            if isInfoExpanded {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.infoViewLeadingConstraint.constant = self.view.frame.width * 0.3
                    UIView.animate(withDuration: Style.defaultAnimationDuration) {
                        self.imageView.scale(withScale: Style.shrinkScale)
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.infoViewLeadingConstraint.constant = self.view.frame.width
                    UIView.animate(withDuration: Style.defaultAnimationDuration) {
                        self.imageView.scale(withScale: Style.expandScale)
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }

    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }

    // Life cycle
    init(nibName: String? = nil, bundle: Bundle? = nil, viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nibName, bundle: bundle)

        print("💚 Initiated root view controller")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("💖 De-initiated root view controller")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.startAnimating()

        setupUI()
        setupImage()

        guard let viewModel = viewModel else { return }
        coordinator?.fetchCommentsFor(viewModel.photo, completion: { [weak self] photoComments in
            self?.infoView.comments = photoComments
        })
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

}

private extension PhotoDetailViewController {

    func setupUI() {
        view.backgroundColor = .charcoalGray

        view.prepareSubviewsForAutolayout(backgroundImageView, backgroundBlurView, loadingView, imageView, infoView, backButton, infoButton)
        view.applyFullConstraints(to: backgroundImageView, backgroundBlurView, loadingView, imageView)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Style.hugePadding),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Style.hugePadding),
            backButton.heightAnchor.constraint(equalToConstant: Style.defaultButtonSize),
            backButton.widthAnchor.constraint(equalToConstant: Style.defaultButtonSize),

            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            infoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Style.hugePadding),
            infoButton.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: -Style.hugePadding),
            infoButton.widthAnchor.constraint(equalToConstant: Style.defaultButtonSize),
            infoButton.heightAnchor.constraint(equalToConstant: Style.defaultButtonSize),
        ])

        infoViewLeadingConstraint = infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width)
        infoViewLeadingConstraint.isActive = true

        backButton.roundView(with: Style.defaultButtonSize / 2)
        infoButton.roundView(with: Style.defaultButtonSize / 2)
    }

    func setupImage() {
        if let viewModel = viewModel {
            self.fetchTask = CachedRequest.request(url: viewModel.photo.url) { [weak self] data, isCached in
                guard let data = data else { return }
                let newImage = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = newImage
                }
            }
        }
    }

}

private extension PhotoDetailViewController {

    func makeBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        return imageView
    }

    func makeBackgroundBlurView() -> UIView {
        let view = UIView()
        view.blurView(isLight: true)
        return view
    }

    func makeLoadingView() -> LoadingView {
        let loadingView = LoadingView()
        return loadingView
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeInfoView() -> InfoView {
        let infoView = InfoView()
        return infoView
    }

    func makeInfoButton() -> ActionButton {
        let button = ActionButton(image: UIImage(named: "ic_learn")?.tinted(with: .white))
        button.backgroundColor = .charcoalGray
        button.tappedOn = { [weak self] in
            guard let self = self else { return }
            self.isInfoExpanded.toggle()
        }
        return button
    }

    func makeBackButton() -> ActionButton {
        let button = ActionButton(image: UIImage(named: "ic_back")?.tinted(with: .white))
        button.backgroundColor = .charcoalGray
        button.tappedOn = { [weak self] in
            self?.coordinator?.removePhotoDetailViewController()
        }
        return button
    }

}
