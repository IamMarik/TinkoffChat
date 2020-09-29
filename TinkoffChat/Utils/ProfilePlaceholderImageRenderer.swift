//
//  TextAvatarDrawer.swift
//  TinkoffChat
//
//  Created by Marik on 20.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreText

class ProfilePlaceholderImageRenderer {

    // static var xOffset: CGFloat = 32

    static var colors: [UIColor] = [.systemBlue, .systemPink, .systemTeal, Colors.sunFlower, .systemGreen]


    static func drawProfilePlaceholderImage(forName name: String, inRectangleOfSize rectangleSize: CGSize) -> UIImage? {
        
        guard let font = UIFont(name: "Roboto-Medium", size: rectangleSize.width / 2) else {
            return nil
        }
        
        let xOffset = rectangleSize.width / 7.5

        let nameParts = name.split(separator: " ")

        let backgroundColor = colors[abs(name.hash) % colors.count]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let fontAttributes: [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font: font,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor.black]

        if nameParts.count == 1,
           let firstLetter = nameParts.first?.first {
            let letterString = String(firstLetter).uppercased() as NSString
            let letterSize = letterString.size(withAttributes: fontAttributes)

            let renderer = UIGraphicsImageRenderer(size: rectangleSize)

            let image = renderer.image { ctx in
                let backgroundRect = CGRect(origin: .zero, size: rectangleSize)
                backgroundColor.setFill()
                ctx.fill(backgroundRect)
                let textRect = CGRect(x: (rectangleSize.width - letterSize.width) / 2,
                                      y: (rectangleSize.height - letterSize.height) / 2,
                                      width: letterSize.width,
                                      height: letterSize.height)
                letterString.draw(in: textRect,
                                        withAttributes: fontAttributes)
            }
            return image
        } else if nameParts.count > 1,
               let firstLetter = nameParts.first?.first,
               let secondLetter = nameParts[1].first {

            let firstLetterString = String(firstLetter).uppercased() as NSString
            let secondLetterString = String(secondLetter).uppercased() as NSString

            let firstLetterSize = firstLetterString.size(withAttributes: fontAttributes)
            let secondLetterSize = secondLetterString.size(withAttributes: fontAttributes)
            let renderer = UIGraphicsImageRenderer(size: rectangleSize)

            let image = renderer.image { ctx in
                let backgroundRect = CGRect(origin: .zero, size: rectangleSize)
                backgroundColor.setFill()
                ctx.cgContext.setStrokeColor(backgroundColor.cgColor)
                ctx.cgContext.setLineWidth(0)
                ctx.cgContext.addEllipse(in: backgroundRect)
                ctx.cgContext.drawPath(using: .fillStroke)
               //ctx.fill(backgroundRect)

                let firstTextRect = CGRect(x: (rectangleSize.width - (firstLetterSize.width + secondLetterSize.width - xOffset)) / 2,
                                           y: (rectangleSize.height - firstLetterSize.height) / 2,
                                           width: firstLetterSize.width,
                                           height: firstLetterSize.height)

                let secondTextRect = CGRect(x: (rectangleSize.width + (firstLetterSize.width - secondLetterSize.width - xOffset)) / 2 ,
                                            y: (rectangleSize.height - firstLetterSize.height) / 2,
                                            width: secondLetterSize.width,
                                            height: secondLetterSize.height)


                firstLetterString.draw(in: firstTextRect,
                                       withAttributes: fontAttributes)

                secondLetterString.draw(in: secondTextRect,
                                        withAttributes: fontAttributes)
            }
            return image
        }
        return nil
    }
}
