//
//  Photographers.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

class Photographer {

    let photographer: Photographers
    var photos = [[Photo]]()

    init(photographer: Photographers) {
        self.photographer = photographer
    }

}

enum Photographers: String, CaseIterable {

    case dersascha
    case alfredoliverani
    case photographybytosh

    var displayName: String {
        switch self {
        case .dersascha:
            return "Sascha Gebhardt"
        case .alfredoliverani:
            return "Alfredo Liverani"
        case .photographybytosh:
            return "Martin Tosh"
        }
    }

    var imageURL: String {
        switch self {
        case .dersascha:
            return "https://farm6.staticflickr.com/5489/buddyicons/26383637@N06_r.jpg"
        case .alfredoliverani:
            return "https://farm4.staticflickr.com/3796/buddyicons/41569704@N00_l.jpg"
        case .photographybytosh:
            return "https://farm9.staticflickr.com/8756/buddyicons/125551752@N05_r.jpg"
        }
    }

}
