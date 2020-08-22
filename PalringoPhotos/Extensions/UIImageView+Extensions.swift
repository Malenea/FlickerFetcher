//
//  UIImageView+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, completion: Style.emptyAction? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.contentMode = mode
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self, duration: Style.defaultAnimationDuration, options: .transitionFlipFromTop, animations: {
                    self.image = image
                }) { _ in
                    completion?()
                }
            }
        }.resume()
    }

    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: Style.emptyAction? = nil) {
        guard let url = URL(string: link) else { return }

        download(from: url, contentMode: mode) {
            completion?()
        }
    }

}
