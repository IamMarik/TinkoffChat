//
//  ThemeSettingsViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


class ThemesViewController: UIViewController {
    
    /*
     Если не делать поле делегата weak, это может стать причиной memory leak,
     например ссылка на объект этого класса хранится в поле объекта делегата,
     а этот объект захватывает сильную ссылку на делегат.
    */
    weak var delegate: ThemesPickerDelegate?
        
    let initialThemeOption = Themes.currentThemeOption
    
    @IBOutlet var stackView: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentThemeOption = Themes.currentThemeOption
        view.backgroundColor = Themes.current.colors.settings.background
        
        ThemeOptions.allCases.forEach {
            let themeView = ThemeOptionView(themeOption: $0)
            themeView.delegate = self
            themeView.isSelected = $0 == currentThemeOption
            self.stackView.addArrangedSubview(themeView)
        }
        
    }
    
    private func selectTheme(option themeOption: ThemeOptions) {
        stackView.arrangedSubviews
            .compactMap { $0 as? ThemeOptionView }
            .filter { $0 !== view }
            .forEach { $0.isSelected = $0.themeOption == themeOption }
        
        Themes.saveApplicationTheme(themeOption) {
            /*  После сохранения темы в UserDefaults, обновим тему и вызовем метод делегата,
             специально не сделал слабую ссылку в списке захвата, чтобы обновить тему,
             если пользователь быстро закроет текущий ViewController
             */
            DispatchQueue.main.async {
                self.delegate?.themeDidChanged(on: themeOption)
                self.updateTheme()
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.isNavigationBarHidden = false
            }
        }
      
    }
    
    private func updateTheme() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = Themes.current.colors.settings.background
        }
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
