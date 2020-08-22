//
//  Coordinator.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

// MARK: Generic coordinator protocol
protocol Coordinator {

    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()

}
