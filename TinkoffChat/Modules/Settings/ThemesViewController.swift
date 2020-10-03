//
//  ThemeSettingsViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate: class {
    func themeDidChanged(on themeOption: ThemeOptions)
}

class ThemesViewController: UIViewController {
    
    weak var delegate: ThemesPickerDelegate?
    
    var onThemeDidChanged: ((ThemeOptions) -> Void)?
    
    let initialThemeOption = ThemeManager.shared.themeOption
    
    
    @IBOutlet var stackView: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentTheme = ThemeManager.shared.themeOption
        
        ThemeOptions.allCases.forEach {
            let themeView = ThemeOptionView(themeOption: $0)
            themeView.delegate = self
            themeView.isSelected = $0 == currentTheme
            self.stackView.addArrangedSubview(themeView)
        }
        
    }
    
    private func selectTheme(option themeOption: ThemeOptions) {
        stackView.arrangedSubviews
            .compactMap { $0 as? ThemeOptionView }
            .filter { $0 !== view }
            .forEach { $0.isSelected = $0.themeOption == themeOption }
        
        delegate?.themeDidChanged(on: themeOption)
        onThemeDidChanged?(themeOption)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func cancelBarButtonDidTap(_ sender: Any) {
        selectTheme(option: initialThemeOption)
    }

}

extension ThemesViewController: ThemeOptionViewDelegate {
    
    func viewDidSelected(_ view: ThemeOptionView, withThemeOption themeOption: ThemeOptions) {
       selectTheme(option: themeOption)
    }
        
}
