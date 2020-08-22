//
//  LoadingView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class LoadingView: UIView {

    // Control variables
    private var previousRandomColorIndex: Int?
    private var timer: Timer?

    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        clipsToBounds = true
    }

}

extension LoadingView {

    func createRandomColor(with index: Int? = nil) -> UIColor {
        let colorArray: [UIColor] = UIColor.getPastelColors()
        let randomColorIndex = Int.random(in: 0...3)
        if let previousRandomColorIndex = previousRandomColorIndex, randomColorIndex == previousRandomColorIndex {
            return createRandomColor(with: randomColorIndex)
        }
        previousRandomColorIndex = randomColorIndex
        return colorArray[randomColorIndex].withAlphaComponent(0.5)
    }

    func createRandomPulse() {
        DispatchQueue.main.async { [weak self] in
            let randX = CGFloat.random(in: 0.0...(self?.frame.width ?? 0.0))
            let randY = CGFloat.random(in: 0.0...(self?.frame.height ?? 0.0))
            let point = CGPoint(x: randX, y: randY)
            let color = self?.createRandomColor().cgColor ?? UIColor.clear.cgColor
            let width = self?.frame.width ?? 0.0
            self?.createPulsator(point: point, width: width, color: color, duration: Style.longAnimationDuration)
        }
    }

    func startAnimating() {
        if let timer = timer {
            timer.invalidate()
        }

        timer = Timer.scheduledTimer(withTimeInterval: Style.defaultAnimationDuration, repeats: true, block: { [weak self] _ in
            self?.createRandomPulse()
        })
    }

    func stopAnimating() {
        guard let timer = timer else { return }
        timer.invalidate()
    }

}
