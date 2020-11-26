//
//  UIViewController + emitEmblems.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 25.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIWindow {
    static let emblemLayerName = "EmblemLayer"
    
    static let emblemImage = #imageLiteral(resourceName: "emblem").withRenderingMode(.alwaysTemplate)
    
    func emitEmblemOnTouch() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchHandler(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.cancelsTouchesInView = false
        longPressGesture.delegate = EmitGestureRecognizerManager.shared
        addGestureRecognizer(longPressGesture)
    }
        
    private func addEmblemLayer(at point: CGPoint) {
        let emblemLayer = CAEmitterLayer()
        emblemLayer.name = Self.emblemLayerName
        emblemLayer.emitterPosition = point
        emblemLayer.emitterShape = .circle
        emblemLayer.beginTime = 0
        emblemLayer.timeOffset = 0.01
        emblemLayer.emitterCells = [makeEmblemCell()]
        layer.addSublayer(emblemLayer)
        emblemLayer.frame = bounds
    }
    
    private func makeEmblemCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = Self.emblemImage.cgImage
        cell.scale = 0.1
        cell.emissionRange = .pi * 2
        cell.lifetime = 10
        cell.birthRate = 10
        cell.velocity = 300
        cell.velocityRange = 20
        cell.yAcceleration = 100
        cell.xAcceleration = 20
        cell.alphaRange = 0.5
        cell.alphaSpeed = -0.4
        cell.spin = 0.5
        cell.spinRange = 2
        return cell
    }
    
    @objc private func touchHandler(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            addEmblemLayer(at: sender.location(in: self))
        case .changed:
            guard let layer = layer.sublayers?.first(where: { $0.name == Self.emblemLayerName })
                    as? CAEmitterLayer else {
                return
            }
            layer.emitterPosition = sender.location(in: self)
        case .ended, .cancelled:
            layer.sublayers?.filter { $0.name == Self.emblemLayerName }.forEach { $0.removeFromSuperlayer()
            }
        default:
            break
        }
    }
}

private class EmitGestureRecognizerManager: NSObject, UIGestureRecognizerDelegate {
    static let shared = EmitGestureRecognizerManager()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
