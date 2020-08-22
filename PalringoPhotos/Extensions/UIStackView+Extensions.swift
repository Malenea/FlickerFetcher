//
//  UIStackView+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    func addArrangedSubviews(_ subviews: UIView...) {
        addArrangedSubviews(subviews)
    }

    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }

}
