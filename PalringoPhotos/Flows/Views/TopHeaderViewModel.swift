//
//  TopHeaderViewModel.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

final class TopHeaderViewModel: ViewModel {

    let photographers: [Photographer]

    init(photographers: [Photographer]) {
        self.photographers = photographers
    }

}
