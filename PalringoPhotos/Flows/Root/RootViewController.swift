//
//  RootViewController.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class RootViewController: UIViewController {

    // Coordinator and model
    weak var coordinator: RootCoordinator?
    private var viewModel: RootViewModel?

    // Components
    private lazy var topFrameView = makeTopFrameView()
    private lazy var topHeaderView = makeTopHeaderView()
    private var topHeaderViewBottomConstraint: NSLayoutConstraint!
    private lazy var collectionView = makeCollectionView()

    private lazy var scrollToTopButton = makeScrollToTopButton()

    // Control variables
    private var isFetchingPhotos = false
    private var isTopExpanded = false
    private var topHeight = Style.topHeaderHeight

    private var currentPhotographer: Photographer?

    // Life cycle
    init(nibName: String? = nil, bundle: Bundle? = nil, viewModel: RootViewModel) {
        self.viewModel = viewModel
        self.currentPhotographer = viewModel.photographers.first

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

        setupUI()

        fetchNextPage()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y >= view.safeAreaInsets.bottom {
            scrollToTopButton.fadeIn()
        } else {
            scrollToTopButton.fadeOut()
        }
    }

}

extension RootViewController {

    func update(_ count: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates({
                for index in 0...count {
                    self?.collectionView.deleteSections(IndexSet(integer: index))
                }
                if let currentPhotographer = self?.currentPhotographer, !currentPhotographer.photos.isEmpty {
                    for index in 0...currentPhotographer.photos.count - 1 {
                        self?.collectionView.insertSections(IndexSet(integer: index))
                    }
                }
                self?.collectionView.reloadData()
            }, completion: { _ in
                self?.fetchNextPage()
            })
        }
    }

}

private extension RootViewController {

    func setupUI() {
        view.backgroundColor = .charcoalGray

        view.prepareSubviewsForAutolayout(topFrameView, collectionView, topHeaderView, scrollToTopButton)
        NSLayoutConstraint.activate([
            topFrameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topFrameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topFrameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topFrameView.heightAnchor.constraint(equalToConstant: topHeight),

            topHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            topHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),

            scrollToTopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Style.hugePadding),
            scrollToTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Style.hugePadding),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: Style.defaultButtonSize),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: Style.defaultButtonSize)
        ])

        topHeaderViewBottomConstraint = topHeaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topHeight + view.safeAreaInsets.top)
        topHeaderViewBottomConstraint.isActive = true

        collectionView.contentInset.top = topHeight + view.safeAreaInsets.top

        scrollToTopButton.roundView(with: Style.defaultButtonSize / 2)
    }

}

private extension RootViewController {

    func makeTopFrameView() -> UIView {
        let view = UIView()
        return view
    }

    func openTopHeader() {
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        if collectionView.contentOffset.y >= view.safeAreaInsets.bottom {
            scrollToTopButton.fadeOut()
        }
        topHeaderView.change(!isTopExpanded)
        collectionView.scale(withScale: Style.shrinkScale)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.topHeaderViewBottomConstraint.constant = self.view.frame.height - self.view.safeAreaInsets.top - self.topHeight
            UIView.animate(withDuration: Style.defaultAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
        isTopExpanded = true
        collectionView.isScrollEnabled = false
    }

    func closeTopHeader() {
        if collectionView.contentOffset.y >= view.safeAreaInsets.bottom {
            scrollToTopButton.fadeIn()
        }
        topHeaderView.change(!isTopExpanded)
        collectionView.scale(withScale: Style.expandScale)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.topHeaderViewBottomConstraint.constant = self.topHeight
            UIView.animate(withDuration: Style.defaultAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
        isTopExpanded = false
        collectionView.isScrollEnabled = true
    }

    @objc func swipedOnTopHeader(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            guard isTopExpanded else { break }
            closeTopHeader()
        case .down:
            guard !isTopExpanded else { break }
            openTopHeader()
        default:
            break
        }
    }

    func makeTopHeaderView() -> TopHeaderView {
        let topHeaderViewModel = TopHeaderViewModel(photographers: viewModel?.photographers ?? [])
        let topHeaderView = TopHeaderView(viewModel: topHeaderViewModel)
        let slideUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedOnTopHeader))
        slideUpGesture.direction = .up
        topHeaderView.addGestureRecognizer(slideUpGesture)
        let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedOnTopHeader))
        slideDownGesture.direction = .down
        topHeaderView.addGestureRecognizer(slideDownGesture)
        topHeaderView.changedPhotographer = { [weak self] photographer in
            let count = (self?.currentPhotographer?.photos.count ?? 1) - 1
            self?.closeTopHeader()
            self?.currentPhotographer = photographer
            self?.update(count)
        }
        return topHeaderView
    }

    func makeCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .charcoalGray
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }

    func makeScrollToTopButton() -> ActionButton {
        let button = ActionButton(image: UIImage(named: "ic_arrowUp"))
        button.backgroundColor = .offWhite
        button.fadeOut(with: .zero)
        button.tappedOn = { [weak self] in
            guard let self = self else { return }
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            button.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: Style.defaultAnimationDuration * 1.5, animations: {
                    button.transform = CGAffineTransform(translationX: .zero, y: -self.view.frame.height / 2)
                }) { _ in
                    button.transform = .identity
                    button.isUserInteractionEnabled = true
                }
            }
        }
        return button
    }

}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = currentPhotographer?.photos[indexPath.section][indexPath.row] else { return }
        coordinator?.presentPhotoDetailViewController(photo: photo)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentPhotographer?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPhotographer?.photos[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.identifier, for: indexPath) as? PictureCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.identifier, for: indexPath) }
        let photo = self.photo(forIndexPath: indexPath)
        cell.photo = photo
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Style.collectionViewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }

}

extension RootViewController {

    func photo(forIndexPath indexPath: IndexPath) -> Photo? {
        guard let currentPhotographer = currentPhotographer else { return nil }
        if indexPath.section == currentPhotographer.photos.count - 1 { fetchNextPage() }
        return currentPhotographer.photos[indexPath.section][indexPath.item]
    }

    func fetchNextPage() {
        guard let currentPhotographer = currentPhotographer else { return }
        if isFetchingPhotos { return }
        isFetchingPhotos = true

        let currentPage = currentPhotographer.photos.count
        coordinator?.fetchPhotoFor(currentPhotographer.photographer, forPage: currentPage + 1, completion: { [weak self] photos in
            if photos.count > 0 {
                currentPhotographer.photos.append(photos)
                self?.collectionView.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        })
    }

}
