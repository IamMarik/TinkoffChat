//
//  ProfileNavigationBar.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileNavigationBar: UIView {
    
    weak var delegate: ProfileNavigationBarDelegate?

    @IBOutlet var contentView: UIView!
        
    @IBOutlet var navigationBarView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var closeButton: UIButton!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 55)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        invalidateIntrinsicContentSize()
    }

    private func configureView() {
        let bundle = Bundle(for: ProfileNavigationBar.self)
        bundle.loadNibNamed("\(ProfileNavigationBar.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let theme = ThemeManager.shared.theme
        navigationBarView.backgroundColor = theme.colors.navigationBar.background
        titleLabel.textColor = theme.colors.navigationBar.title
        
        
        
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        delegate?.closeButtonDidTapped()
    }
    
}


protocol ProfileNavigationBarDelegate: class {
    
    func closeButtonDidTapped()
}
