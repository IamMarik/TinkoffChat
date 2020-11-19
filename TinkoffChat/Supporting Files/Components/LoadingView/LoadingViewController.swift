//
//  LoadingViewController.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 19.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var containterView: UIView!
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        containterView.layer.cornerRadius = 14
        containterView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        containterView.layer.shadowRadius = 1.63
        containterView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containterView.backgroundColor = Themes.current.colors.profile.loadingViewBackground        
    }
    
    func show(in presentingView: UIView, animated: Bool = true, completion: (() -> Void)? = nil) {
        presentingView.addSubview(view)
        view.frame = presentingView.bounds
    }
    
    func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        view.removeFromSuperview()
    }

}
