//
//  ThemeOptionView.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 02.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeOptionView: UIView {
    
    weak var delegate: ThemeOptionViewDelegate?
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                containerButton.layer.borderColor = UIColor.systemBlue.cgColor
                containerButton.layer.borderWidth = 2
            } else {
                containerButton.layer.borderColor = UIColor(hex: 0x979797).cgColor
                containerButton.layer.borderWidth = 1
            }
        }
    }
    
    private var themeOption: ThemeOptions = .classic
    
    private var containerButton = UIButton()
    
    private var incomingMessageSampleView = UIView()
    
    private var outgoingMessageSampleView = UIView()
    
    private var themeNameLabel = UILabel()

    
    init(themeOption: ThemeOptions) {
        super.init(frame: .zero)
        self.themeOption = themeOption
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
        
    private func setupView() {
        let theme = themeOption.theme
        
        self.backgroundColor = .clear
    
        addSubview(containerButton)
        containerButton.translatesAutoresizingMaskIntoConstraints = false
        containerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        containerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        containerButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
        containerButton.layer.borderWidth = 1
        containerButton.layer.borderColor = UIColor(hex: 0x979797).cgColor
        containerButton.layer.cornerRadius = 14
        containerButton.backgroundColor = theme.colors.background
        
        addSubview(incomingMessageSampleView)
        incomingMessageSampleView.translatesAutoresizingMaskIntoConstraints = false
        incomingMessageSampleView.topAnchor.constraint(equalTo: containerButton.topAnchor, constant: 10).isActive = true
        incomingMessageSampleView.leadingAnchor.constraint(equalTo: containerButton.leadingAnchor, constant: 24).isActive = true
        incomingMessageSampleView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        incomingMessageSampleView.layer.cornerRadius = 6
        
        incomingMessageSampleView.backgroundColor = theme.colors.imcomingMessage
                
        addSubview(outgoingMessageSampleView)
        outgoingMessageSampleView.translatesAutoresizingMaskIntoConstraints = false
        outgoingMessageSampleView.bottomAnchor.constraint(equalTo: containerButton.bottomAnchor, constant: -10).isActive = true
        outgoingMessageSampleView.trailingAnchor.constraint(equalTo: containerButton.trailingAnchor, constant: -24).isActive = true
        outgoingMessageSampleView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        outgoingMessageSampleView.leadingAnchor.constraint(equalTo: incomingMessageSampleView.trailingAnchor, constant: 18).isActive = true
        outgoingMessageSampleView.widthAnchor.constraint(equalTo: incomingMessageSampleView.widthAnchor).isActive = true
        outgoingMessageSampleView.layer.cornerRadius = 6
        
        outgoingMessageSampleView.backgroundColor = theme.colors.outgoingMessage
        
        addSubview(themeNameLabel)
        themeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        themeNameLabel.topAnchor.constraint(equalTo: containerButton.bottomAnchor, constant: 16).isActive = true
        themeNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        themeNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        themeNameLabel.textAlignment = .center
        themeNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        themeNameLabel.textColor = .white
        
        themeNameLabel.text = theme.name
        
        incomingMessageSampleView.isUserInteractionEnabled = false
        outgoingMessageSampleView.isUserInteractionEnabled = false
        containerButton.addTarget(self, action: #selector(self.viewDidSelected), for: .touchDown)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewDidSelected))
        themeNameLabel.addGestureRecognizer(tap)
        themeNameLabel.isUserInteractionEnabled = true
    }
        
    @objc func viewDidSelected() {
        isSelected = true
        delegate?.viewDidSelected(self, withThemeOption: themeOption)
    }

}

protocol ThemeOptionViewDelegate: class {
    
    func viewDidSelected(_ view: ThemeOptionView, withThemeOption themeOption: ThemeOptions)
    
}

