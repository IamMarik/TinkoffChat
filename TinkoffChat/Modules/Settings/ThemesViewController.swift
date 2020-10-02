//
//  ThemeSettingsViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    weak var delegate: ThemesPickerDelegate?
    
    var onThemeDidChanged: ((ThemeOptions) -> Void)?
    
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeOptions.allCases.forEach {
            let themeView = ThemeOptionView(themeOption: $0)
            themeView.delegate = self
            self.stackView.addArrangedSubview(themeView)
        }
        
    }
    
}

extension ThemesViewController: ThemeOptionViewDelegate {
    
    func viewDidSelected(_ view: ThemeOptionView, withThemeOption themeOption: ThemeOptions) {
        stackView.arrangedSubviews
            .compactMap { $0 as? ThemeOptionView }
            .filter { $0 !== view }
            .forEach { $0.isSelected = false }
        delegate?.themeDidChanged(on: themeOption)
        onThemeDidChanged?(themeOption)
    }
        
}


protocol ThemesPickerDelegate: class {
    
    func themeDidChanged(on themeOption: ThemeOptions)
    
}
