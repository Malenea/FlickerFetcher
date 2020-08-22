//
//  PhotoDetailViewModel.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 21/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

final class PhotoDetailViewModel: ViewModel {

    let photo: Photo

    init(photo: Photo) {
        self.photo = photo
    }

}
