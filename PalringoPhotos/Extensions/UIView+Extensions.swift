//
//  UIView+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func roundView(with value: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = value
    }

    func blurView(isLight: Bool = false) {
        backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: isLight ? .light : .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        prepareSubviewsForAutolayout(blurEffectView)
        applyFullConstraints(to: blurEffectView)
    }

    func prepareSubviewsForAutolayout(_ subviews: UIView...) {
        prepareSubviewsForAutolayout(subviews)
    }

    func prepareSubviewsForAutolayout(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func applyFullConstraints(to views: UIView..., withSafeAreas: Bool = false) {
        applyFullConstraints(to: views, withSafeAreas: withSafeAreas)
    }

    func applyFullConstraints(to views: [UIView], withSafeAreas: Bool) {
        views.forEach {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.topAnchor : topAnchor),
                $0.bottomAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: withSafeAreas ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor)
            ])
        }
    }

    func fadeIn(with duration: TimeInterval = Style.defaultAnimationDuration) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = 1.0
            }
        }
    }

    func fadeOut(with duration: TimeInterval = Style.defaultAnimationDuration) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = 0.0
            }
        }
    }

    func rotate180(with duration: TimeInterval = Style.defaultAnimationDuration) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = CGAffineTransform(rotationAngle: .pi)
            }
        }
    }

    func scale(with duration: TimeInterval = Style.defaultAnimationDuration, withScale: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = CGAffineTransform(scaleX: withScale, y: withScale)
            }
        }
    }

    func resetTransform(with duration: TimeInterval = Style.defaultAnimationDuration) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = .identity
            }
        }
    }

    func animateLayoutIfNeeded(with duration: TimeInterval = Style.defaultAnimationDuration) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.layoutIfNeeded()
            }
        }
    }

    func createPulsator(point: CGPoint, width: CGFloat, color: CGColor, isSolid: Bool = false, duration: TimeInterval = Style.defaultAnimationDuration, completion: (()->())? = nil) {
        let pulsator = Pulsator()
        pulsator.position = CGPoint(x: point.x, y: point.y)
        pulsator.backgroundColor = color
        pulsator.radius = width
        pulsator.numPulse = 1
        pulsator.animationDuration = duration
        pulsator.repeatCount = 1
        pulsator.autoRemove = true

        pulsator.start(isSolid: isSolid)

        layer.addSublayer(pulsator)

        // The - 0.25 is to avoid any clipping in animation transition
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.25) {
            completion?()
        }
    }

}
