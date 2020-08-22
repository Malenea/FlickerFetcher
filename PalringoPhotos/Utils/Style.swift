//
//  Style.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

struct Style {

    // Typealiases
    typealias emptyAction = () -> Void
    typealias photographerAction = (Photographer?) -> Void
    typealias photosAction = ([Photo]) -> Void

    // Fonts
    static var titleFont: UIFont = UIFont.systemFont(ofSize: 48.0, weight: .semibold)
    static var subtitleFont: UIFont = UIFont.systemFont(ofSize: 24.0, weight: .regular)
    static var normalSemiBoldFont: UIFont = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
    static var normalFont: UIFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

    // Sizes
    static var defaultPadding: CGFloat = 8.0
    static var bigPadding: CGFloat = 16.0
    static var hugePadding: CGFloat = 24.0

    static var defaultHeight: CGFloat = 1.0
    
    static var topHeaderHeight: CGFloat = 96.0

    static var horizontalArrowHeight: CGFloat = 10.0
    static var horizontalArrowWidth: CGFloat = 20.0

    static var collectionViewCellHeight: CGFloat = 200.0

    static var defaultButtonSize: CGFloat = 48.0

    // Animation
    static var shortAnimationDuration: TimeInterval = 0.2
    static var defaultAnimationDuration: TimeInterval = 0.5
    static var longAnimationDuration: TimeInterval = 6.0

    static var shrinkScale: CGFloat = 0.9
    static var expandScale: CGFloat = 1.0

}
