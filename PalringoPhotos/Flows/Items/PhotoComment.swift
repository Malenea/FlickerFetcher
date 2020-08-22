//
//  PhotoComment.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 21/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

struct PhotoComment: Equatable {

    let id: String
    let author: String
    let comment: String

    static func ==(lhs: PhotoComment, rhs: PhotoComment) -> Bool {
        return (lhs.id == rhs.id && lhs.author == rhs.author && lhs.comment == rhs.comment)
    }

}
