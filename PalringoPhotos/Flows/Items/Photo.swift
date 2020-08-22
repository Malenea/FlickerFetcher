//
//  Photo.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

struct Photo: Equatable {

    let id: String
    let name: String
    let url: URL

    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
