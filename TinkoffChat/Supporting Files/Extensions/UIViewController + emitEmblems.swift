//
//  UIViewController + emitEmblems.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 25.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension UIViewController {
    static let emblemLayerName = "EmblemLayer"
    
    func emitEmblemOnTouch() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchHandler(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(longPressGesture)
    }
        
    private func addEmblemLayer(at point: CGPoint) {
        print("added at \(point)")
        let emblemLayer = CAEmitterLayer()
        emblemLayer.name = Self.emblemLayerName
        emblemLayer.emitterPosition = point
        emblemLayer.emitterShape = .point
        emblemLayer.beginTime = 0
        emblemLayer.timeOffset = 0.05
        emblemLayer.emitterCells = [makeEmblemCell()]
        view.layer.addSublayer(emblemLayer)
        emblemLayer.frame = view.bounds
    }
    
    private func makeEmblemCell() -> CAEmitterCell{
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "Launch")?.cgImage
        cell.scale = 0.2
        cell.emissionRange = .pi * 2
        cell.lifetime = 20
        cell.birthRate = 1
        cell.velocity = 300
        cell.velocityRange = 20
        cell.yAcceleration = 100
        cell.xAcceleration = 20
        cell.spin = 0.5
        cell.spinRange = 2
        return cell
    }
    
    @objc private func touchHandler(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            addEmblemLayer(at:  sender.location(in: view))
        case .changed:
            guard let layer = view.layer.sublayers?.first(where: { $0.name == Self.emblemLayerName })
                    as? CAEmitterLayer else {
                return
            }
            layer.emitterPosition = sender.location(in: view)
        case .ended, .cancelled:
            view.layer.sublayers?.filter { $0.name == Self.emblemLayerName }.forEach { $0.removeFromSuperlayer()
            }
        default:
            break
        }
    }
}
