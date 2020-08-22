//
//  RootCoordinator.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

// MARK: Init and initial methods
final class RootCoordinator: Coordinator {

    // Coordinators and navigation controller
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    // Start function
    func start() {
        var photographers = [Photographer]()
        for photographer in Photographers.allCases {
            photographers.append(Photographer(photographer: photographer))
        }
        let rootViewModel = RootViewModel(photographers: photographers)
        let vc = RootViewController(viewModel: rootViewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

}

extension RootCoordinator {

    func presentPhotoDetailViewController(photo: Photo) {
        let photoDetailViewModel = PhotoDetailViewModel(photo: photo)
        let vc = PhotoDetailViewController(viewModel: photoDetailViewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func removePhotoDetailViewController() {
        navigationController.popViewController(animated: true)
    }

}

extension RootCoordinator {

    func fetchPhotoFor(_ photographer: Photographers, forPage: Int, completion: @escaping Style.photosAction) {
        APIHandler.shared.getPhotosUrls(for: photographer, forPage: forPage, completion: completion)
    }

    func fetchCommentsFor(_ photo: Photo, completion: @escaping ([PhotoComment]) -> Void) {
        APIHandler.shared.getPhotoComments(for: photo, completion: completion)
    }
}
