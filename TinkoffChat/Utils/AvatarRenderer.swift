//
//  TextAvatarDrawer.swift
//  TinkoffChat
//
//  Created by Marik on 20.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreText

class AvatarRenderer {

    static var xOffset: CGFloat = 40.0

    static var font = UIFont(name: "Roboto Medium", size: 120)

    static var colors: [UIColor] = [UIColor.blue, UIColor.green, UIColor.magenta]

    static func draw(withName name: String, size: CGSize) -> UIImage? {
        guard let font = font else { return nil }

        let nameParts = name.split(separator: " ")

        let backgroundColor = colors[name.hash % colors.count]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let fontAttributes: [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font: font,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor.black]

        if nameParts.count == 1,
           let firstLetter = nameParts.first?.first {
            let text = String(firstLetter)
            let textSize = (text as NSString).size(withAttributes: fontAttributes)

            let renderer = UIGraphicsImageRenderer(size: size)

            let image = renderer.image { ctx in
                let backgroundRect = CGRect(origin: .zero, size: size)
                backgroundColor.setFill()
                ctx.fill(backgroundRect)
                let textRect = CGRect(x: (size.width - textSize.width) / 2,
                                      y: (size.height - textSize.height) / 2,
                                      width: textSize.width,
                                      height: textSize.height)
                (text as NSString).draw(in: textRect,
                                        withAttributes: fontAttributes)
            }
            return image
        } else if nameParts.count > 1,
               let firstLetter = nameParts.first?.first,
               let secondLetter = nameParts[1].first {

            let firstLetterString = String(firstLetter) as NSString
            let secondLetterString = String(secondLetter) as NSString

            let firstLetterSize = firstLetterString.size(withAttributes: fontAttributes)
            let secondLetterSize = secondLetterString.size(withAttributes: fontAttributes)
            let renderer = UIGraphicsImageRenderer(size: size)

            let image = renderer.image { ctx in
                let backgroundRect = CGRect(origin: .zero, size: size)
                backgroundColor.setFill()
                ctx.fill(backgroundRect)

                let firstTextRect = CGRect(x: (size.width - (firstLetterSize.width + secondLetterSize.width - xOffset)) / 2,
                                           y: (size.height - firstLetterSize.height) / 2,
                                           width: firstLetterSize.width,
                                           height: firstLetterSize.height)

                let secondTextRect = CGRect(x: (size.width + (firstLetterSize.width - secondLetterSize.width - xOffset)) / 2 ,
                                            y: (size.height - firstLetterSize.height) / 2,
                                            width: firstLetterSize.width,
                                            height: firstLetterSize.height)


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
